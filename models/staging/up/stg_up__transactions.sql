with latest as (
    select
    transaction_id,
    account_id,
    transfer_account_id,
    transaction_description,
    category_id,
    currency_code,
    transaction_amount,
    transaction_amount_in_base_units
    card_purchase_method,
    card_number_suffix,
    settled_at_date,
    settled_at_hour,
    settled_at_minute,
    settled_at_second,
    created_at_date,
    created_at_hour,
    created_at_minute,
    created_at_second
    from {{ ref('up_transactions_snapshot') }}
    where dbt_valid_to is null
)
select * from latest