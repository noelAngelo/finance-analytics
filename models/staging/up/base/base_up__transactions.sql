with source as (
    select 
        type, 
        id as transaction_id, 
        _loaded_timestamp from {{ source('main', 'raw_up_transactions') }}
),

attributes as (
    select
        id,
        attributes ->> 'status' as status,
        attributes ->> 'rawText' as raw_text,
        attributes ->> 'description' as description,
        attributes ->> 'message' as message,
        attributes ->> 'isCategorizable' as is_categorisable,
        attributes ->> 'roundUp' as round_up,
        attributes ->> 'cashback' as cashback,
        attributes ->> 'foreignAmount' as foreign_amount,
        attributes ->> 'settledAt' as settled_at,
        attributes ->> 'createdAt' as created_at
    from {{ source('main', 'raw_up_transactions') }}
),

hold_info as (
    select 
        id,
        attributes -> 'holdInfo' -> 'amount' ->> 'currencyCode' as currency_code,
        attributes -> 'holdInfo' -> 'amount' ->> 'value' as amount_value,
        attributes -> 'holdInfo' -> 'amount' ->> 'valueInBaseUnits' as value_in_base_units,
        attributes -> 'holdInfo' ->> 'foreignAmount' as foreign_amount_value
    from {{ source('main', 'raw_up_transactions') }}
),

card_purchase_method as (
    select 
        id,
        attributes -> 'cardPurchaseMethod' ->> 'method' as card_purchase_method,
        attributes -> 'cardPurchaseMethod' ->> 'cardNumberSuffix' as card_number_suffix
    from {{ source('main', 'raw_up_transactions') }}
),

amount as (
    select
        id,
        attributes -> 'amount' ->> 'currencyCode' as currency_code,
        attributes -> 'amount' ->> 'value' as value,
        attributes -> 'amount' ->> 'valueInBaseUnits' as value_in_base_units,
        attributes -> 'amount' ->> 'foreignAmount' as foreign_amount
    from {{ source('main', 'raw_up_transactions') }}
),

account as (
    select
        id,
        relationships -> 'transferAccount' -> 'data' ->> 'id' as transfer_account_id,
        relationships -> 'transferAccount' -> 'data' ->> 'type' as transfer_account_type,
        relationships -> 'account' -> 'data' ->> 'id' as account_id,
        relationships -> 'account' -> 'data' ->> 'type' as account_type,
        relationships -> 'account' -> 'links' ->> 'related' as account_related
    from {{ source('main', 'raw_up_transactions') }}
),

category as (
    select
        id,
        relationships -> 'category' -> 'data' ->> 'id' as category_id,
        relationships -> 'category' -> 'data' ->> 'type' as category_type,
        relationships -> 'category' -> 'links' ->> 'self' as category_link,
        relationships -> 'category' -> 'links' ->> 'related' as category_related
    from {{ source('main', 'raw_up_transactions') }}
),

parent_category as (
    select
        id,
        relationships -> 'parentCategory' -> 'data' ->> 'id' as parent_category_id,
        relationships -> 'parentCategory' -> 'data' ->> 'type' as parent_category_type,
        relationships -> 'parentCategory' -> 'links' -> 'related' as parent_category_related
    from {{ source('main', 'raw_up_transactions') }}
),

tags as (
    select
        id,
        relationships -> 'tags' -> 'data' as tags_data
    from {{ source('main', 'raw_up_transactions') }}
),

links as (
    select
        id,
        links ->> 'self' as transaction_link
    from {{ source('main', 'raw_up_transactions') }}
)

select *
from source
left join attributes on source.transaction_id = attributes.id
-- left join hold_info on source.transaction_id = hold_info.id
left join card_purchase_method on source.transaction_id = card_purchase_method.id
left join amount on source.transaction_id = amount.id
left join account on source.transaction_id = account.id
left join category on source.transaction_id = category.id
left JOIN parent_category on source.transaction_id = parent_category.id
left join tags on source.transaction_id = tags.id
left join links on source.transaction_id = links.id

