{% snapshot up_transactions_snapshot %}
{{
    
        config(
        alias='up_transactions_snapshot',
        target_schema='snapshots',
        unique_key='transaction_id',
        strategy='check',
        check_cols=['category_id', 'settled_at_date'],
        )
}}

select
        transaction_id,
        account_id,
        transfer_account_id,
        description as transaction_description,
        category_id,
        currency_code,
        value::INTEGER as transaction_amount,
        value_in_base_units as transaction_amount_in_base_units,
        card_purchase_method,
        card_number_suffix,
        {{ generate_date_key('created_at') }},
        {{ generate_date_key('settled_at') }},
        _loaded_timestamp
    from {{ ref('base_up__transactions') }}

{% endsnapshot %}