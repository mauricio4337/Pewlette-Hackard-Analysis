-- Challenge Queries
  
  --  Create table of employees with birth date 
  --  from 1952 to 1955 and hired from 1985 to 1988
  --  (i.e. employees that are eligible for retirement)
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


  -- Count number of employees in retirement_info table
SELECT COUNT(first_name) FROM retirement_info;

-- Join departments and dept_manager tables
-- filtering for current managers
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments AS d
INNER JOIN dept_manager AS dm
ON d.dept_no = dm.dept_no
WHERE dm.to_date = '9999-01-01';

-- Join dept_emp and retirement_info tables
-- Selecting current employees from retirement_info table
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info AS ri
LEFT JOIN dept_emp AS de
ON ri.emp_no = de.emp_no
WHERE de.to_date = '9999-01-01';

-- Employee count by department number
-- Results saved to dept_size table 
SELECT COUNT(ce.emp_no), de.dept_no
INTO dept_size
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Employee list with gender and salary
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
INNER JOIN dept_emp AS de
	ON (e.emp_no = de.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- table of department managers
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

-- table of employees with departments
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO dept_info
FROM current_emp AS ce
INNER JOIN dept_emp AS de
	ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
	ON (de.dept_no = d.dept_no);

-- table of sales employees
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO sales_info
FROM current_emp AS ce
INNER JOIN dept_emp AS de
	ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
	ON (de.dept_no = d.dept_no)
WHERE d.dept_name = 'Sales';

-- table of sales and development employees
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO sales_dev
FROM current_emp AS ce
INNER JOIN dept_emp AS de
	ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
	ON (de.dept_no = d.dept_no)
WHERE d.dept_name  IN ('Sales','Development')
ORDER BY d.dept_name; 

-- Number of employees retiring by title
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO ret_titles
FROM current_emp AS ce
INNER JOIN titles AS ti
	ON (ce.emp_no = ti.emp_no)
ORDER BY ce.emp_no;

-- Partition
SELECT emp_no,
	first_name,
	last_name,
	to_date,
	title
INTO unique_titles
FROM (
	SELECT emp_no,
	first_name,
	last_name,
	to_date,
	title, ROW_NUMBER() OVER
	(PARTITION BY (emp_no)
	ORDER BY to_date DESC) rn
	FROM ret_titles
	) tmp WHERE rn = 1
ORDER BY emp_no;

-- Count retiring by title
SELECT COUNT(title),title
INTO retiring_title
FROM unique_titles
GROUP BY title
ORDER BY COUNT DESC;

-- table of employees suitable for mentorship program
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	ti.title
INTO mentorship
FROM employees AS e
INNER JOIN dept_emp AS de
	ON (e.emp_no = de.emp_no)
INNER JOIN titles AS ti
	ON (e.emp_no = ti.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

Select * From mentorship;