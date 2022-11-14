{% macro pre_sql(db_name, schema_name) %}
{% set sql %}

CREATE TABLE IF NOT EXISTS {{db_name}}.{{schema_name}}.MOVIE_RAW_PAYLOAD
COMMENT = 'RAW table MOVIE_RAW_PAYLOAD for MOVIE'
(
  RAW_PAYLOAD VARIANT,
	LOADED_AT TIMESTAMP_TZ
);

{% endset %}

{% do run_query(sql) %}
{% do log('Local SQL executed', info=True) %}

{%- endmacro %}
