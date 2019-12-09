--CONSTRUCTION OF DATA TABLES

-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.
DROP TABLE employees;

--Create employees and departments tables, define emp_no and dept_no as Primary Keys, check creation of tables.
--Import data from .CSV files and confirm the data was imported properly.
CREATE TABLE employees (
    emp_no VARCHAR PRIMARY KEY NOT NULL,
	birth_date VARCHAR NOT NULL,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    gender VARCHAR(1) NOT NULL,
    hire_date VARCHAR NOT NULL
);
--Check Table
SELECT * FROM employees
LIMIT(20);


CREATE TABLE departments (
    dept_no VARCHAR PRIMARY KEY NOT NULL,
    dept_name VARCHAR NOT NULL
);
--Check Table
SELECT * FROM departments
LIMIT(20);

--Create titles table. This .csv file has no ID PK column, so I need to import data first, then add a PK column.
--Used Alter Table and Add Column to add integer ID SERIAL PRIMARY KEY. Then define Foreign Key by REFERENCES to
--reference emp_no in titles to emp_no in employees.
DROP TABLE titles;

CREATE TABLE titles (
    emp_no VARCHAR NOT NULL REFERENCES employees(emp_no),
    title VARCHAR NOT NULL,
    from_date VARCHAR NOT NULL,
    to_date VARCHAR NOT NULL
);
--Import .CSV data before running next commands.
ALTER TABLE titles
ADD COLUMN ID SERIAL PRIMARY KEY;

--Check Table
SELECT * FROM titles
LIMIT(20);

--The strategy for adding integer ID SERIAL PRIMARY KEY worked in titles and FK approach. Repeat for other tables.
DROP TABLE salaries;

CREATE TABLE salaries (
    emp_no VARCHAR NOT NULL REFERENCES employees(emp_no),
	salary VARCHAR NOT NULL,
    from_date VARCHAR NOT NULL,
    to_date VARCHAR NOT NULL
);
--Again, import .CSV data before adding the ID SERIAL PRIMARY KEY column.
ALTER TABLE salaries
ADD COLUMN ID SERIAL PRIMARY KEY;

--Check Table
SELECT * FROM salaries
LIMIT(20);

--Create dept_emp table as with the other tables. Add data and then add the ID column.
--Note here that we will have 2 Foreign Keys, one for emp_no in employees, the other for dept_no in departments.
DROP TABLE dept_emp;

CREATE TABLE dept_emp (
    emp_no VARCHAR NOT NULL REFERENCES employees(emp_no),
	dept_no VARCHAR NOT NULL REFERENCES departments(dept_no),
    from_date VARCHAR NOT NULL,
    to_date VARCHAR NOT NULL
);
--Import .CSV data before adding the ID column.
ALTER TABLE dept_emp
ADD COLUMN ID SERIAL PRIMARY KEY;

--Check Table
SELECT * FROM dept_emp
LIMIT(20);

--Same ideas as in dept_emp table. Two Foreign Keys to employees(emp_no) and departments(dept_no).
DROP TABLE dept_manager;

CREATE TABLE dept_manager (
    dept_no VARCHAR NOT NULL REFERENCES departments(dept_no),
    emp_no VARCHAR NOT NULL REFERENCES employees(emp_no),
    from_date VARCHAR NOT NULL,
    to_date VARCHAR NOT NULL
);
--Import .csv table data, then execute this code for ID column.
ALTER TABLE dept_manager
ADD COLUMN ID SERIAL PRIMARY KEY;

--Check Table
SELECT * FROM dept_manager
LIMIT(20);

--DATA ANALYSIS SECTION
--1. List employee number, last name, first name, gender, salary.
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.gender, salaries.salary
FROM salaries
INNER JOIN employees
ON salaries.emp_no = employees.emp_no;
--Checked the output and 300024 rows affected. The employees file has 300025 rows including header.
SELECT COUNT(emp_no) FROM employees;

--2. List employees hired in 1986. Use % wildcard after hire_date of 1986.
SELECT *
FROM employees
WHERE hire_date LIKE '1986%'
--Checked output and 30150 rows affected.

--3. List the manager of each department: dept. number, dept. name, manager emp_no, last name, first name, start and end employment dates.
SELECT dept_manager.dept_no, dept_manager.emp_no, dept_manager.from_date, dept_manager.to_date,
departments.dept_name, employees.last_name, employees.first_name
FROM dept_manager
INNER JOIN departments
ON departments.dept_no = dept_manager.dept_no
INNER JOIN employees
ON employees.emp_no = dept_manager.emp_no;
--Checked and found 24 rows affected. The dept_manager table has 24 rows, so everything appears OK. 
SELECT COUNT(dept_no) FROM dept_manager;

--4. List department of each employee: employee number, last name, first name, dept name.
SELECT dept_emp.emp_no, dept_emp.dept_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
INNER JOIN employees
ON dept_emp.emp_no = employees.emp_no
INNER JOIN departments
ON departments.dept_no = dept_emp.dept_no;
--Check that dept_emp rows are all OK.
SELECT COUNT(emp_no) FROM dept_emp;




