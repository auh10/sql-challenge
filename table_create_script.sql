-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/koRq4G
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INT   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "birth_date" VARCHAR   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "gender" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

CREATE TABLE "titles" (
    "emp_no" INT   NOT NULL,
    "title" VARCHAR   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "titles" ADD CONSTRAINT "fk_titles_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");


--------------------------



1. List the following details of each employee: employee number, last name, first name, gender, and salary.
--combine columns for: employee number, last name, first name, gender, salary
SELECT e.emp_no, e.first_name, e.last_name, e.gender, s.salary
FROM employees AS e
JOIN salaries AS s
ON e.emp_no = s.emp_no;

2. List employees who were hired in 1986.
-- employees hired in 1986
SELECT first_name, last_name, hire_date
FROM employees
WHERE "hire_date" >= '1986-01-01' AND "hire_date" < '1987-01-01';

3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name, and start and end employment dates.
--manager of each department with the following information: department number, department name, the manager's employee number, 
--last name, first name, and start and end employment dates.

CREATE VIEW managers_details AS
SELECT t.title, d.dept_no, d.dept_name, dm.emp_no, e.last_name,e.first_name, dm.from_date, dm.to_date
FROM departments d
LEFT JOIN dept_manager dm
ON d.dept_no = dm.dept_no
LEFT JOIN employees e
ON dm.emp_no = e.emp_no
LEFT JOIN titles t
ON e.emp_no = t.emp_no
WHERE t.title = 'Manager';

4. List the department of each employee with the following information: employee number, last name, first name, and department name.
--dept of each employee: employee #,last name, first name, dept name
CREATE VIEW dept_of_emp AS
SELECT d.dept_no, de.emp_no, e.last_name, e.first_name, d.dept_name
FROM departments d
LEFT JOIN dept_emp de
ON d.dept_no = de.dept_no
LEFT JOIN employees e
ON de.emp_no = e.emp_no;


5. List all employees whose first name is "Hercules" and last names begin with "B."
--all employees whose first name is "Hercules" and last names begin with "B."
CREATE VIEW hercules_b AS
SELECT e.first_name, e.last_name
FROM employees AS e
WHERE e.first_name = 'Hercules' AND e.last_name LIKE 'B%';


6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
--list all employees in Sales department, employee number, last name, first name, and department name.
CREATE VIEW sales_emps AS
SELECT d.dept_no, de.emp_no, e.last_name, e.first_name, d.dept_name
FROM departments AS d
LEFT JOIN dept_emp AS de
ON d.dept_no = de.dept_no
LEFT JOIN employees AS e
ON de.emp_no = e.emp_no
WHERE e.first_name IN
(	
	SELECT e.first_name
	FROM departments
	WHERE e.last_name IN
	(
		SELECT e.last_name 
		FROM employees
		WHERE d.dept_no IN
		(
			SELECT d.dept_no
			FROM departments
			WHERE d.dept_name = 'Sales'
		)
	)
);


7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
--List all employees in Sales and Development depts: employee number, last name, first name, and department name.
CREATE VIEW sales_dev_emps AS
SELECT de.emp_no, e.last_name, e.first_name, d.dept_name
FROM departments AS d
LEFT JOIN dept_emp AS de
ON d.dept_no = de.dept_no
LEFT JOIN employees AS e
ON de.emp_no = e.emp_no
WHERE e.first_name IN
(	
	SELECT e.first_name
	FROM departments
	WHERE e.last_name IN
	(
		SELECT e.last_name 
		FROM employees
		WHERE d.dept_no IN
		(
			SELECT d.dept_no
			FROM departments
			WHERE d.dept_name = 'Sales' OR d.dept_name='Development'
		)
	)
);


8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
--In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
CREATE VIEW last_name_count AS
SELECT e.last_name, COUNT(e.last_name) AS "Last Name Count"
FROM employees e
GROUP BY e.last_name
ORDER BY "Last Name Count" DESC;



