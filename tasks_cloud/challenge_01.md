# Spill the dbt Challenge 01: Lego Data Analysis

## Objective

In this challenge, you'll set up a dbt project to analyze Lego data using the data sitting in Snowflake. You'll create dbt models and learn how to run and test your models.

## Prerequisites

- Completed the project setup in the README_cloud.md
- Basic knowledge of SQL and dbt

## Steps to Complete the Challenge

### Step 1: Initialize a dbt Project (if not already done)
1. Go to the dbt Cloud Studio.
2. Initialize the dbt project.
3. Click **Commit and sync** when you confirm all the work of a step is complete.

**Reference Images:**
- ![Initialization](https://i.imgur.com/Dv12b8n.png)
- ![Commit and Sync](https://i.imgur.com/BhqbHPK.png)

### Step 2: Adding source yml under models directory

Under the models directory, create a new directory named "lego". Add a source.yml file to define the Lego data source. 

**Reference Image:**
- ![Source YAML Setup](https://i.imgur.com/xwSEDQ1.png)

### Step 3: Create a New Model

Copy the provided SQL script ch01_sql_script.sql in the repository to your new lego directory. Save the model.

**Reference Image:**
- ![Model Creation](https://i.imgur.com/DEJ6N9M.png)

### Step 4: Verify the Model can run

Run the following command to ensure the model is correctly set up:

```
dbt build -s lego
```
If you encounter any errors, fix them accordingly.

You should see output indicating that the model has run successfully.

**Reference Image:**
- ![Model Run Success](https://i.imgur.com/aPfvIek.png)



### Step 5: Add Tests in schema.yml

Create a `schema.yml` file in the `models/lego` directory to add tests ensuring the columns [theme_name, set_name, set_year] have no null values:

```yml
version: 2

models:
  - name: lego
    columns:
      - name: column_name # replace with actual column name
        data_tests:
          - not_null
```

**Reference Image:**
- ![Schema Tests Setup](https://i.imgur.com/ZaJY3j0.png)


### Step 6: Modularise the SQL and add Ref Functions

**1. Adding new source staging layer.**

Source should be not be directly referenced by the model. They should be rendered into separate source models before being referenced by the main model.

Create a new subdirectory "source" under lego directory for better management. Put the source.yml file there. Create all source table models in the "source" subdirectory for later use. The file should be started with `stg_` to indicate it is a staging model.

**Reference Image:**
- ![Source Models Structure](https://i.imgur.com/VWpLFzg.png)

**2. Create a new SQL model for the UNIQUE_PARTS CTE.**

Create another subdirectory "marts" under lego directory for better management.

Open `lego.sql` and copy the SQL code for the UNIQUE_PARTS CTE into a new file, `unique_parts.sql` under "marts" subdirectory. Ensure that `unique_parts.sql` selects the data you need and ends with a SELECT statement.

Replace the source reference in `unique_parts.sql` with the source model you created earlier using the ref function.

**Reference Image:**
- ![Unique Parts Model](https://i.imgur.com/6qokTfQ.png)

**3. Modify lego.sql to Reference unique_parts.sql**

Move lego.sql to "marts" subdirectory, modify the query to reference unique_parts using the ref function.

```sql
SELECT *
FROM {{ ref('unique_parts') }}
WHERE -- your conditions
```

This tells dbt to use the unique_parts model as a dependency. Also replaced all source reference with the source model you created earlier.

**Reference Image:**
- ![Lego Model with Ref](https://i.imgur.com/w9E2vqb.png)

You can learn more about [model references](https://docs.getdbt.com/reference/dbt-jinja-functions/ref) in the dbt documentation.

**4. Ensure the model runs**

Run the following command to ensure the model is correctly set up:

```
dbt run -s lego
```

If you encounter any errors fix them.

You should see output indicating that the model ran successfully.

**Reference Image:**
- ![Model Run Verification](https://i.imgur.com/w9E2vqb.png)

### Step 7: Configure the Model in `dbt_project.yml`

In your `dbt_project.yml` file, modify the configuration by setting the project name and the materialization for your models:

```yml
models:
  spill_the_dbt_project:
    lego:
      marts:
        lego:
          materialized: table
```

This sets the lego model outputs to be materialized as tables in the database.

**Reference Image:**
- ![dbt Project Configuration](https://i.imgur.com/s13eFMU.png)

### Step 8: Generate Docs

Generate the documentation site to visualize your models and their dependencies.

Run:

```bash
dbt docs generate
```

This will generate documentation for your project. Click the "Docs" button in the top right corner on the left panel to view the documentation.

Navigate to the lego model and verify it depends on unique_parts and other related source models.

**Reference Image:**
- ![Documentation Generation](https://i.imgur.com/kFGmLrE.png)

You can learn more about [dbt docs commands](https://docs.getdbt.com/reference/commands/cmd-docs) in the dbt documentation.

### Step 9: Run the Entire Workflow

Run the following command to build and test your models:

```
dbt build -s lego
```

This command will:
- Run your models
- Run your tests
- Generate documentation

If you encounter any errors, fix them accordingly.

You should see output indicating that your models ran successfully and that tests passed.

### Step 10: Verify the Table Creation

In the snowflake console, verify that the lego table has been created and contains the expected data.

You should see:
- An output of table names from the database, including your newly created models.
- An output of the lego table showing Lego themes, sets, unique parts, and a count of parts.

**Reference Image:**
- ![Documentation Generation](https://i.imgur.com/YRwki8d.png)

### Task complete!

This project was an introduction to working with dbt, we:
- Set up a dbt Project
- Created and Configured a Model
- Ran, Tested, and Documented the Model

Save your work to GitHub, share what you've learned with **#SpilltheDBT**, and get ready for the next challenge!