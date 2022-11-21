# stack-playpen

Playpen for dbt, terraform, airflow, flyway...

## Issues

- You need to run deploy twice to get the event - there is a sequencing bug I haven't resolved
- You need to rename the topic after destroy to get Snowflake to add a subscription to the pipe/SQS queue. This is a bug with Snowflake. Just add -1... -2 etc

## Terraform

Powershell:
``` shell
.\scripts\deploy_dev.ps1
```

SH:
``` shell
TBC
```

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

## DBT Freshness

Run:

``` shell
dbt source freshness
```
