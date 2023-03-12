
# Домашнее задание к занятию 12.2. «Работа с данными (DDL/DML)»


### Задание 1
1.1. Поднимите чистый инстанс MySQL версии 8.0+. Можно использовать локальный сервер или контейнер Docker.

1.2. Создайте учётную запись sys_temp. 

1.3. Выполните запрос на получение списка пользователей в базе данных. (скриншот)

![sakila_1](https://github.com/benli6/ben_sqld-5_reldb/blob/main/screenshots/sakila_1.png)

1.4. Дайте все права для пользователя sys_temp. 

1.5. Выполните запрос на получение списка прав для пользователя sys_temp. (скриншот)

![sakila_2](https://github.com/benli6/ben_sqld-5_reldb/blob/main/screenshots/sakila_2.png)

1.6. Переподключитесь к базе данных от имени sys_temp.

![sakila_3](https://github.com/benli6/ben_sqld-5_reldb/blob/main/screenshots/sakila_3.png)

1.6. По ссылке https://downloads.mysql.com/docs/sakila-db.zip скачайте дамп базы данных.

1.7. Восстановите дамп в базу данных.

1.8. При работе в IDE сформируйте ER-диаграмму получившейся базы данных. При работе в командной строке используйте команду для получения всех таблиц базы данных. (скриншот)

![sakila_4](https://github.com/benli6/ben_sqld-5_reldb/blob/main/screenshots/sakila_4.png)

---

### Задание 2
Составьте таблицу, используя любой текстовый редактор или Excel, в которой должно быть два столбца: в первом должны быть названия таблиц восстановленной базы, во втором названия первичных ключей этих таблиц.


|  № |     Table     |       Column PK      |
|:--:|:-------------:|:--------------------:|
| 1  | actor         | actor_id             |
| 2  | address       | address_id           |
| 3  | category      | category_id          |
| 4  | city          | city_id              |
| 5  | country       | country_id           |
| 6  | customer      | customer_id          |
| 7  | film          | film_id              |
| 8  | film_actor    | actor_id, film_id    |
| 9  | film_category | film_id, category_id |
| 10 | film_text     | film_id              |
| 11 | inventory     | inventory_id         |
| 12 | language      | language_id          |
| 13 | payment       | payment_id           |
| 14 | rental        | rental_id            |
| 15 | staff         | staff_id             |
| 16 | store         | store_id             |


--- 

### Задание 3*
3.1. Уберите у пользователя sys_temp права на внесение, изменение и удаление данных из базы sakila.

3.2. Выполните запрос на получение списка прав для пользователя sys_temp. (скриншот)

![sakila_5](https://github.com/benli6/ben_sqld-5_reldb/blob/main/screenshots/sakila_5.png)


---

Простыня со всеми запросами

![sql_sakila](https://github.com/benli6/ben_sqld-5_reldb/blob/main/ben_sqld-5_sakila.sql)