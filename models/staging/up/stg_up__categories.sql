with latest as (
    select
    *
from {{ ref('up_categories_snapshot') }}
where dbt_valid_to is null
)

select * from latest
