--Создать базу данных test
--Исполнить этот запрос https://github.com/pthom/northwind_psql/blob/master/northwind.sql
--Есть таблицы
--orders - заказы
--order_details - детали заказа (ид заказа,  ид продукта, цена за 1 шт, количество штук, скидка) - по сути перечень товаров внутри заказов
--products - продукты
--employees - сотрудники

--Необходимо составить отчет для менеджеров (отправить мне sql скрипты):
--1. Посчитать количество заказов за все время
--2. Посчитать сумму по всем заказам за все время (учитывая скидки)
--3. Показать сколько сотрудников работает в каждом городе.
--4. Выявить самый продаваемый товар в штуках. Вывести имя продукта и его количество.
--5. Выявить фио сотрудника, у которого сумма всех заказов самая маленькая

--0. Создать базу данных test
CREATE DATABASE test
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LOCALE_PROVIDER = 'libc'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
--1. Посчитать количество заказов за все время	
SELECT COUNT(1) as "Количество заказов за все время" FROM public.orders;	

--Результат
--830

--2. Посчитать сумму по всем заказам за все время (учитывая скидки)
SELECT SUM(unit_price * quantity - (unit_price * quantity * discount)) as "Сумма по всем заказам за все время (учитывая скидки)" FROM public.order_details;

--Результат
--1265793.038653364


--3. Показать сколько сотрудников работает в каждом городе.
SELECT city as "Город", COUNT(city) as "Количество работников"
FROM public.employees group BY city;

--Результат
--"Redmond" 1
--"London" 4
--"Tacoma" 1
--"Kirkland" 1
--"Seattle"	2


--4. Выявить самый продаваемый товар в штуках. Вывести имя продукта и его количество.
SELECT pr.product_name as "Самый продоваемый товар", det.sm as "Количество"
FROM (
	SELECT product_id, SUM(quantity) as sm
	FROM public.order_details
	GROUP BY product_id
	ORDER BY sm DESC limit 1
) det JOIN public.products pr ON det.product_id = pr.product_id;

--Результат
--"Camembert Pierrot"	1577


--5. Выявить фио сотрудника, у которого сумма всех заказов самая маленькая 


	