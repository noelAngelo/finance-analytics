{%- macro generate_date_key(column) -%}
    date_trunc('day', {{ column }}::TIMESTAMP) as {{ column }}_date,
    date_part('hour', {{ column }}::TIMESTAMP) as {{ column }}_hour,
    date_part('minute', {{ column }}::TIMESTAMP) as {{ column }}_minute,
    date_part('second', {{ column }}::TIMESTAMP) as {{ column }}_second
{%- endmacro -%}