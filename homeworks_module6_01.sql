
Sql дз Университет
(Нужны все скрипты создания БД, схем, таблиц)
Создаем схему Инженерно Экономического университета
Этап №1 Создание схемы. Определить самостоятельно типы данных для каждого поля(колонки). Самостоятельно определить что является primary key и foreign key.
1. Создать таблицу с факультетами: id, имя факультета, стоимость обучения
2. Создать таблицу с курсами: id, номер курса, id факультета
3. Создать таблицу с учениками: id, имя, фамилия, отчество, бюджетник/частник, id курса


--0.1 создание базу данных education
CREATE DATABASE education
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
--0.1 создание схемы 
CREATE SCHEMA IF NOT EXISTS university_engineering_economic
    AUTHORIZATION postgres;	

--1. Создать таблицу с факультетами: id, имя факультета, стоимость обучения	
CREATE TABLE IF NOT EXISTS university_engineering_economic.faculty (id serial primary key,
																	name varchar(100),
																	price numeric(9,2));

--2. Создать таблицу с курсами: id, номер курса, id факультета
CREATE TABLE IF NOT EXISTS university_engineering_economic.course (id serial primary key,
													name varchar(100),
													faculty_id int REFERENCES university_engineering_economic.faculty(id));

--3. Создать таблицу с учениками: id, имя, фамилия, отчество, бюджетник/частник, id курса
CREATE TABLE IF NOT EXISTS university_engineering_economic.student (id serial primary key,
													first_name varchar(100),
													surname varchar(100),
													patronymic varchar(100),												
													budget boolean,
													course_id int REFERENCES university_engineering_economic.course(id));
													
													
													
--Этап №2 Заполнение данными:
--1. Создать два факультета: Инженерный (30 000 за курс) , Экономический (49 000 за курс)
--2. Создать 1 курс на Инженерном факультете: 1 курс
--3. Создать 2 курса на экономическом факультете: 1, 4 курс
--4. Создать 5 учеников:
--Петров Петр Петрович, 1 курс инженерного факультета, бюджетник
--Иванов Иван Иваныч, 1 курс инженерного факультета, частник
--Михно Сергей Иваныч, 4 курс экономического факультета, бюджетник
--Стоцкая Ирина Юрьевна, 4 курс экономического факультета, частник
--Младич Настасья (без отчества), 1 курс экономического факультета, частник													

--1. Создать два факультета: Инженерный (30 000 за курс) , Экономический (49 000 за курс)
INSERT INTO university_engineering_economic.faculty (name, price) values('Инженерный', 30000);
INSERT INTO university_engineering_economic.faculty (name, price) values ('Экономический', 49000);

--2. Создать 1 курс на Инженерном факультете: 1 курс
INSERT INTO university_engineering_economic.course (name, faculty_id) values('1 курс', (select id from university_engineering_economic.faculty where name like 'Инженерный'));

--3. Создать 2 курса на экономическом факультете: 1, 4 курс
INSERT INTO university_engineering_economic.course (name, faculty_id) values('1 курс', (select id from university_engineering_economic.faculty where name like 'Экономический'));
INSERT INTO university_engineering_economic.course (name, faculty_id) values('4 курс', (select id from university_engineering_economic.faculty where name like 'Экономический'));

--4. Создать 5 учеников:
--Петров Петр Петрович, 1 курс инженерного факультета, бюджетник
INSERT INTO university_engineering_economic.student (first_name, surname, patronymic, budget, course_id) values('Петр', 'Петров', 'Петрович', true,
(SELECT id FROM university_engineering_economic.course where faculty_id = (select id from university_engineering_economic.faculty where name like 'Инженерный')));

--Иванов Иван Иваныч, 1 курс инженерного факультета, частник
INSERT INTO university_engineering_economic.student (first_name, surname, patronymic, budget, course_id) values('Иван', 'Иванов', 'Иванович', false,
(SELECT id FROM university_engineering_economic.course where faculty_id = (select id from university_engineering_economic.faculty where name like 'Инженерный')));

--Михно Сергей Иваныч, 4 курс экономического факультета, бюджетник
INSERT INTO university_engineering_economic.student (first_name, surname, patronymic, budget, course_id) values('Сергей', 'Михно', 'Иванович', true,
(SELECT id FROM university_engineering_economic.course 
	where name like '4%'
	and
	faculty_id = (select id from university_engineering_economic.faculty where name like 'Эконом%')));
	
--Стоцкая Ирина Юрьевна, 4 курс экономического факультета, частник
INSERT INTO university_engineering_economic.student (first_name, surname, patronymic, budget, course_id) values('Ирина', 'Стоцкая', 'Сергеевна', false,
(SELECT id FROM university_engineering_economic.course 
	where name like '4%'
	and
	faculty_id = (select id from university_engineering_economic.faculty where name like 'Эконом%')));

--Младич Настасья (без отчества), 1 курс экономического факультета, частник
INSERT INTO university_engineering_economic.student (first_name, surname, budget, course_id) values('Настасья', 'Младич', false,
(SELECT id FROM university_engineering_economic.course 
	where name like '1%'
	and
	faculty_id = (select id from university_engineering_economic.faculty where name like 'Эконом%')));
	
	
--Этап №3 Выборка данных. Необходимо написать sql запросы :
--1. Вывести всех студентов, кто платит больше 30_000.
--2. Перевести всех студентов Петровых на 1 курс экономического факультета.
--3. Вывести всех студентов без отчества или фамилии.
--4. Вывести всех студентов содержащих в фамилии или в имени или в отчестве "ван".
--5. Удалить все записи из всех таблиц.	

--1. Вывести всех студентов, кто платит больше 30_000.
SELECT id, surname, first_name, patronymic, budget
	FROM university_engineering_economic.student 
	where budget = false
	and course_id in (SELECT id FROM university_engineering_economic.course 
	where faculty_id = (SELECT id
	FROM university_engineering_economic.faculty where price > 30000));

--2. Перевести всех студентов Петровых на 1 курс экономического факультета.	
UPDATE university_engineering_economic.student
	SET course_id = (SELECT id FROM university_engineering_economic.course 
	where  name like '1%'
	and 
	faculty_id = (select id from university_engineering_economic.faculty where name like 'Эконом%'))
	WHERE surname like 'Петров%';
	
--3. Вывести всех студентов без отчества или фамилии.	
SELECT *
	FROM university_engineering_economic.student 
	where 
	patronymic is null
	or
	surname is null
	;

--4. Вывести всех студентов содержащих в фамилии или в имени или в отчестве "ван".	
SELECT *
	FROM university_engineering_economic.student 
	where 
	first_name like '%ван%' 
	or
	surname like '%ван%' 
	or
	patronymic like '%ван%' 
	;
	
--5. Удалить все записи из всех таблиц.		
TRUNCATE TABLE university_engineering_economic.faculty, university_engineering_economic.course, university_engineering_economic.student;
	
	
	
	



 



