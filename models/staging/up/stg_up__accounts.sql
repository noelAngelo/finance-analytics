with latest as (
    select
    account_id,
    display_name,
    account_type,
    ownership_type,
    created_at_date,
    created_at_hour,
    created_at_minute,
    created_at_second
from {{ ref('up_accounts_snapshot') }}
where dbt_valid_to is null
)

select * from latest
