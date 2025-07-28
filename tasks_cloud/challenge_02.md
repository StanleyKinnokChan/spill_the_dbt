# Spill the dbt Challenge 02: Library Loan Issues 

## Objective
Identify and fix issues in a dbt model that aggregates late fees for overdue library loans by writing and running tests. Compare the fixed model's output with a provided CSV seed using the dbt-utils package.

## Prerequisites

- Completed the project setup in the README_cloud.md
- Basic knowledge of SQL and dbt
- Concept of staging layer and refactoring


## Steps to Complete the Challenge

### Step 1: Initialize a dbt Project (if not already done)
1. Go to the dbt Cloud Studio.
2. Initialize the dbt project.
3. Click **Commit and sync** when you confirm all the work of a step is complete.

**Reference Images:**
![Initialization](https://i.imgur.com/Dv12b8n.png)
![Commit and Sync](https://i.imgur.com/BhqbHPK.png)

### Step 2: Create a New Model

- Under the models directory, create a new directory named "library_loans".
- Under "library_loans", create two folders "source" and "marts".
- Copy the customers_with_late_fees.sql to your under "library_loans" directory and save the model

### Step 3: Adding source yml under models directory and staging layer
Just like challenge 01, we will create a staging layer to clean and prepare the data.

Under the library_loans/source directory, add a source.yml file to define the library_loans data source. 

For each table defined in source.yml, you should add a source model within the same directory.
  - loans
  - members
  - books_factual
  - books_fictionals

**Reference Image:**
![Source YAML Setup](https://i.imgur.com/d9u04vv.png)


### Step 4: Replace the source reference in the legacy model
The model customer_with_late_fees.sql contains full qualified table names, you will need to replace them with source references.

### Step 5: Configure the Model in `dbt_project.yml`

In your `dbt_project.yml` file, add the following configuration to set the materialization for your models:

```
models:
  spill_the_dbt_project:
    library_loans:
        marts:
          materialized: table
```
This sets the library_loans models in the marts directory to be materialized as a table.

### Step 6: Verify the Model Can Run

Run the following command to ensure the model is correctly set up:
```
dbt run -s library_loans
```
This will create the table `customers_with_late_fees`. 

However, stakeholders have indicated that the data is incorrect and does not match the existing report `solution.csv`.


### Step 7: Add Tests in schema.yml

We need to create tests to identify issues in our source data.

Create schema.yml in the "models/library_loans" directory

Add tests to schema.yml, to check the following assumptions:

- All id fields should not contain null values
- All books in the factual and fictional ranges should be unique
- Customers should have three tiers of membership: Bronze, Silver and Gold
- We can only loan books from our factual and fictional ranges
- We can only loan books to members from the members table

Here is an example of formating tests in `schema.yml`.

```yml
version: 2

sources:
  - name: library
    schema: main
    tables:
      - name: books_factual
        columns:
          - name: book_id
            data_tests:
              - unique
              - not_null
      - name: books_fictional
```
You can learn more about [applying tests](https://docs.getdbt.com/docs/build/data-tests) in the dbt documentation.


Execute the following command to run the tests:
```bash
dbt test -s library_loans
```

You should see output indicating that some tests have failed.

**Reference Image:**
![Test Failed](https://i.imgur.com/h2FAKD6.png)

### Step 8: Create a new model and Resolve Failed Tests

Add a new models `stg_books` in the "source" subdirectory under "library_loans" directory. 

Note: `stg_books` is the union all of factual and fictional with a new column to indicate genre: 'Fact' or 'Fiction'

Update schema.yml the run the test against the new staging tables. Those assumptions to check were:

- All id fields should not contain null values
- All books in the factual and fictional ranges should be unique
- Customers should have three tiers of membership: Bronze, Silver and Gold
- We can only loan books from our factual and fictional ranges
- We can only loan books to members from the members table

Here's is a starting point for your `schema.yml` file
```yml
version: 2

sources:
  - name: library
    schema: main
    tables:
      - name: books_factual
      - name: books_fictional
      - name: loans
      - name: members

models:
  - name: stg_books
    columns:
      - name: book_id
        data_tests:
          - unique
          - not_null
  ```
Then run and test your dbt model.

```bash
dbt run -s library_loans
```

dbt run should return:
![Book model Passed](https://i.imgur.com/ekEHk6a.png)

```bash
dbt test -s library_loans
```

and dbt test should return:
![Test Failed after book model](https://i.imgur.com/LHYbJNo.png)

Refine the code so all staging tables pass the tests now and in the future. 
- Remove any rows with null ids
- Remove any duplicate entries (SELECT DISTINCT/ GROUP BY should be sufficient)
- Remove any values not within the accepted values


Run and test your model with dbt build, you should see:

![Test Passed after code refinement](https://i.imgur.com/qPvJsD8.png)

### Step 8: Refactor customer_with_late_fees to Use the staging layer

Modify the `customers_with_late_fees.sql` model to use the staging models.
- Use {{ source("source_name", "table_name") }} to reference the source tables
- Use {{ ref('stg_books') }} to reference the staging tables

Split the customer_with_late_fees query into 2 tables: 
- the CTE `customer_withdrawls`
- the final output `customers_with_late_fees`

Run and Test the Model:
```
dbt build -s library_loans
```

dbt build applies both run and test at once, you can learn more about the [dbt build command](https://docs.getdbt.com/reference/commands/build) in the dbt documentation.

![Book model Passed](https://i.imgur.com/6XmCCfq.png)

### Step 9: Add Custom Generic Tests

We need to add tests for additional assumptions:
- late fees should always be positive or zero, any negative values are refunds which have been already passed on to the customer and should be excluded
- `customers_with_late_fees` should always have 1 row per customer
- member names in `members`, `customer_withdrawls` and `customers_with_late_fees` should not contain digits, warn the user rather than stop the workflow

These tests will require you to create custom generic tests. 

**Example:**
Create a folder 'generic' under 'tests' directory. 
Create a file tests/positive_late_fees.sql:

```sql
{% test positive_late_fees(model, column_name) %}
  SELECT *
  FROM {{ model }}
  WHERE {{ column_name }} < 0
{% endtest %}
```
Add Tests to schema.yml

```yml
models:
  - name: customers_with_late_fees
    columns:
      - name: fee_to_pay
        tests:
          - positive_late_fees
```
Run the Tests

```bash
dbt test -s customers_with_late_fees
```
If you encounter any tests failing, fix them accordingly.

dbt build should return:
![custom tests passed](https://i.imgur.com/TGL4kz0.png)

### Step 10: Verify Data Correctness with dbt-utils

Install the dbt_utils package to use additional testing capabilities.

Create a  `packages.yml` file in the same level (folder) as your `dbt_project.yml` file, with the following code included.

```yml
packages:
  - package: dbt-labs/dbt_utils
    version: 0.9.2
```
Run `dbt deps` to install the package.
```bash
dbt deps
```

Copy 'ch02_data/solution.csv' from the repo to the `seeds` folder and run `dbt seed` to load it to your database.

```bash
dbt seed
```

Update `schema.yml` to include an equal_rowcount test. 

```
version: 2

models:
  - name: customers_with_late_fees
    tests:
      - dbt_utils.equal_rowcount:
          compare_model: ref('solution')

seeds:
  - name: solution

```
Note this uses the term `tests` which is the older version of `data-tests`.
Also be aware this test is in model level but not column level.

Build the model
```bash
dbt build -s customers_with_late_fees
```

dbt build should return


![Book model Passed](https://i.imgur.com/doukmQV.png)

### Task complete!

This project was a look at testing in dbt, we: 

- Configured standard generic tests to stop pipelines running
- Created our own generic tests to warn about issues
- Installed a dbt package `dbt-utils` for more tests

Save your work to GitHub, share what you've learned with **#SpilltheDBT**, and get ready for the next challenge!