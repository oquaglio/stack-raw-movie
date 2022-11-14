# stack-playpen

Playpen for dbt, terraform, airflow, flyway...

## Create Python Virt Env for DBT

In root:

``` shell
py -m venv dbt-env
```

``` shell
.\dbt-venv\Scripts\Activate.ps1
```

``` shell
pip install dbt-snowflake
```

## Run DBT macros

Create tables:

``` shell
dbt run-operation pre_sql --args '{db_name: DEV, schema_name: RAW_MOVIE}'
```
