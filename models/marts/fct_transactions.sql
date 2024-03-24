with up as (
    select
        transaction_id,
        created_at_date,
        account_id,
        category_id,
        transaction_amount,
        CASE
            WHEN transaction_description LIKE 'Transfer%' THEN 'transfer'
            WHEN transaction_amount < 0 THEN 'purchase'
            WHEN transaction_amount > 0 THEN 'income'
        END as transaction_type,
        transfer_account_id as transfer_to_account_id,
        transaction_description
    from {{ ref('stg_up__transactions') }}
)

select 
    u.transaction_id,
    d.date_day as transaction_date,
    u.account_id,
    c.id as category_id,
    u.transaction_amount,
    u.transaction_type,
    u.transfer_to_account_id,
    u.transaction_description
from up u
left join {{ ref('dim_date') }} d on u.created_at_date = d.date_day
left join {{ ref('dim_accounts') }} a on u.account_id = a.account_id
left join {{ ref('dim_categories') }} c on u.category_id = c.id