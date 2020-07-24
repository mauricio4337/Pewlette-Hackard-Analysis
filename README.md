# Pewlette-Hackard-Analysis
*Problem: Determine the percent of the work force that will be retiring in the next three years to ensure that Pewlette-Hackard has a pipeline of competent replacements.

* Retirement Eligible Employees
The table unique_titles.csv contains a list of current employees that are eligible for retirement and grouped by the current employee title.  The table was created from different employee data sources: Individual employee records, department employee records, and department information.  The separate record tables were merged and filtered.  The first filter applied selected employees born between 1962 and 1965 (i.e. the employees ready to retire), the second filter selected only active employees (employees with a to_date of 1999-01-01), since not all employees born between 1962 and 1965 are still with the company.  Finally, the data in unique_titles.csv contains information about employees current position in the company.  Duplicate records exist for the same employee that has had multiple positions in the company.  Removing these duplicates gives a true picture of the number of employees in each position ready to retire.

* Mentorship Ready Employees
Pewlette-Hackard could ensure a smooth transition of new employees into senior position by advancing qualified employees from within the companies.  Pewlette-Hackard can also take advantage of the tremendous amount of knowledge that the retirement ready employees have to train employees identified for mentorship.  Employee records were queried for current employees born in 1965.  This query data was stored in mentorship.csv.  Duplicate employee records were intentionally left in this case so that informed decisions could be made based on the number and types of positions held within company by employees ready for mentorship.
