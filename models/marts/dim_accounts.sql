with up as (
    select
        account_id,
        display_name,
        account_type,
        ownership_type,
        created_at_date,
        created_at_hour,
        created_at_minute,
        created_at_second,
        'Up Bank' as account_bank
    from {{ ref('stg_up__accounts') }}
)

select *
from up u