-- Queries for employees eligible for early retirement
  -- All employees born from 1952 to 1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

  -- 1952
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

  -- 1953
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

  -- 1954
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

  -- 1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

  -- Include hire date conditions from 1985 to 1988
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

  -- Count employees eligible for retirement
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

  -- Save querry results as a table
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


-- Drop retirement_info table to recreate with emp_no
DROP TABLE retirement_info;

-- Add emp_no to query to join with dept_employees table
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check table
SELECT * FROM retirement_info;

-- Join departments and dept_managers tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments AS d
INNER JOIN dept_manager AS dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
FROM retirement_info AS ri
LEFT JOIN dept_employees AS de
ON ri.emp_no = de.emp_no;

-- Joining retirement_info and dept_emp tables 
-- Save results to current_emp with to_date = 9999-01-01 (currently employed)
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info AS ri
LEFT JOIN dept_employees AS de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
-- Results saved to dept_size table 
SELECT COUNT(ce.emp_no), de.dept_no
INTO dept_size
FROM current_emp as ce
LEFT JOIN dept_employees as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Ordered search of salaries by to_date
select * from salaries
order by to_date DESC;

-- Query for employees eligible for retirement
-- Include gender information in the query
-- Results saved to emp_info table
SELECT emp_no, 
	first_name, 
	last_name,
	gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


-- Join three tables: employees, salaries, and dept_emp
-- Query for retirement eligibility and current employee
-- Results saved to emp_info table
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees AS e
INNER JOIN salaries AS s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_employees AS de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	AND (de.to_date = '9999-01-01');

-- Join tables dept_managers, departments, and current_emp
-- to get the employee info of department managers
-- Results saved to manager_info table
SELECT dm.dept_no,
	d.dept_name,
	dm.emp_no,
	ce.last_name,
	ce.first_name,
	dm.from_date,
	dm.to_date
INTO manager_info
FROM dept_manager AS dm
	INNER JOIN departments as d
		ON (dm.dept_no=d.dept_no)
	INNER JOIN current_emp AS ce
		ON (dm.emp_no=ce.emp_no);

-- Join three tables current_emp, dept_employees, and departments
-- to add department names to current employees
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO dept_info
FROM current_emp AS ce
	INNER JOIN dept_employees AS de
		ON (ce.emp_no=de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no=d.dept_no);
		

-- Create a tailored list for the sales department
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
-- INTO sales_info
FROM current_emp AS ce
	INNER JOIN dept_employees AS de
		ON (ce.emp_no=de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no=d.dept_no)
WHERE dept_name IN ('Sales','Development');

