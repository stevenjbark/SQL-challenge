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
--Checked output and 36150 rows affected.

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

--5. List employees with first name "Hercules" and last name starts with a "B."
SELECT *
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

--6. List all employees in Sales Department including employee number, last name, first name, and department name
--First try to use subquery. Worked, but how to get the department name despite query specifically for 'Sales'?
--Because multiple employee numbers generated from the nested subqueries, I needed to use IN for the top query.
SELECT employees.emp_no, employees.last_name, employees.first_name
FROM employees
WHERE emp_no IN (
	SELECT emp_no
	FROM dept_emp
	WHERE dept_no = (
		SELECT dept_no
		FROM departments
		WHERE dept_name = 'Sales'
	)
);

--Now try the standard INNER JOIN approach.
SELECT employees.emp_no, employees.last_name, employees.first_name, dept_emp.dept_no, departments.dept_name
FROM dept_emp
INNER JOIN employees
ON dept_emp.emp_no = employees.emp_no
INNER JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE dept_name = 'Sales';
--Worked! Generated dept_name and dept_no columns.

--7. List all employees in Sales and Development departments, employee number, last name, first name, department name
SELECT employees.emp_no, employees.last_name, employees.first_name, dept_emp.dept_no, departments.dept_name
FROM dept_emp
INNER JOIN employees
ON dept_emp.emp_no = employees.emp_no
INNER JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE dept_name = 'Sales' OR dept_name = 'Development';

--8. In decending order, list the frequency of employee last names.
SELECT COUNT(last_name), employees.last_name 
FROM employees
GROUP BY last_name
ORDER BY COUNT(last_name) DESC; 
--Baba 226 to Foolsday with 1 count, 1638 rows.


