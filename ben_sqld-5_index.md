# Домашнее задание к занятию 12.5. «Индексы»

### Задание 1

Напишите запрос к учебной базе данных, который вернёт процентное отношение общего размера всех индексов к общему размеру всех таблиц.

```sql
SELECT round(sum(index_length) * 100 / sum(data_length), 2) as percent
FROM INFORMATION_SCHEMA.TABLES;
```
```Процентное отношение общего размера всех индексов к общему размеру всех таблиц составляет 40.34 %```

![sakila_6](https://github.com/benli6/ben_sqld-5_reldb/blob/main/screenshots/sakila_6.png)

---

### Задание 2

Выполните explain analyze следующего запроса:
```sql
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id
```
- перечислите узкие места;

`Самыми узкими местами в данном запросе являются создание оконной функции и декартово произведение сразу пяти таблиц. При этом ни то ни другое действие в данном запросе не нужны, и более того - продоцируют ошибки. Декартово произведение создает 642 000 строк, что заставляет даже небольшие по стоимости операции проходить огромное количество итераций. Примерно на это уходит 2,5 секунды. А оконная функция поглощает примерно 3 секунды, производя в каждой из этих строк математические операции и захватывая при этом ненужную здесь таблицу фильмов. Но в этом нет никакой необходимости, поскольку в результате всё равно извлекаются уникальные 391 строк, сгруппированные по людям.`

`В результате этого запроса есть 8 ошибок. Я не очень понимаю, каким именно образом это получается, но из-за объединения таблиц оплаты и аренды, людям начисляютися платежи других покупателей, произведенные в это же время. В представленном примере у Донны Томпсон вместо платежа стоимостью 21.96 на 30.07.2005 получился платеж 24.95. Поэтому на самом деле самым узким местом этого запроса является некорректность его даннных.`

![error_1](https://github.com/benli6/ben_sqld-5_reldb/blob/main/screenshots/sakila_error_1.png)

![error_2](https://github.com/benli6/ben_sqld-5_reldb/blob/main/screenshots/sakila_error_2.png)

- оптимизируйте запрос: внесите корректировки по использованию операторов, при необходимости добавьте индексы.

`В связи со всем вышеперечисленным я вижу самым оптимальным вариантом переписать запрос с нуля, чтобы, во-первых, достичь правильных данных, а во-вторых, за 22 миллисекунды вместо 6 тысяч.`

```sql
select concat(c.last_name, ' ', c.first_name), sum(p.amount)
from customer c 
join payment p on p.customer_id = c.customer_id 
where date(p.payment_date) = '2005-07-30'
group by 1
```

`С добавлением индекса по колонке с датой оплаты время запроса уменьшилось до 2,7 миллисекунд`

```sql
-- добавление индекса
create index date_index
on payment(payment_date);

-- запрос
select concat(c.last_name, ' ', c.first_name), sum(p.amount)
from customer c
join payment p using(customer_id)
where p.payment_date >= '2005-07-30 00:00:00' and p.payment_date <= '2005-07-30 23:59:59'
group by 1;

-- explain analyze
-> Limit: 200 row(s)  (actual time=2.668..2.697 rows=200 loops=1)
    -> Table scan on <temporary>  (actual time=2.667..2.687 rows=200 loops=1)
        -> Aggregate using temporary table  (actual time=2.667..2.667 rows=391 loops=1)
            -> Nested loop inner join  (cost=507.46 rows=634) (actual time=0.029..2.013 rows=634 loops=1)
                -> Index range scan on p using date_index over ('2005-07-30 00:00:00' <= payment_date <= '2005-07-30 23:59:59'), with index condition: ((p.payment_date >= TIMESTAMP'2005-07-30 00:00:00') and (p.payment_date <= TIMESTAMP'2005-07-30 23:59:59'))  (cost=285.56 rows=634) (actual time=0.022..1.139 rows=634 loops=1)
                -> Single-row index lookup on c using PRIMARY (customer_id=p.customer_id)  (cost=0.25 rows=1) (actual time=0.001..0.001 rows=1 loops=634)
```

---

### Задание 3*

Самостоятельно изучите, какие типы индексов используются в PostgreSQL. Перечислите те индексы, которые используются в PostgreSQL, а в MySQL — нет.

|                          | MySQL                            | PostgreSQL                                   |
|--------------------------|----------------------------------|----------------------------------------------|
| B-Tree index             | Есть                             | Есть                                         |
| Пространственные индексы | R-Tree с квадратичным разбиением | Rtree_GiST(используется линейное разбиение)  |
| Hash index               | Только в таблицах типа Memory    | Есть                                         |
| Bitmap index             | Нет                              | Есть                                         |
| Inverted index           | Есть                             | Есть                                         |
| Partial index            | Нет                              | Есть                                         |
| Function based index     | Нет                              | Есть                                         |
