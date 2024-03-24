with source as (
    select id as account_id, type, _loaded_timestamp from {{ source('main', 'raw_up_accounts') }}
),

attributes as (
    select
        id,
        attributes ->> 'displayName' as display_name,
        attributes ->> 'accountType' as account_type,
        attributes ->> 'ownershipType' as ownership_type,
        attributes ->> 'createdAt' as created_at
    from {{ source('main', 'raw_up_accounts') }}
),

balance as (
    select
        id,
        attributes -> 'balance' ->> 'currencyCode' as currency_code,
        attributes -> 'balance' ->> 'value' as value,
        attributes -> 'balance' ->> 'valueInBaseUnits' as value_in_base_units
    from {{ source('main', 'raw_up_accounts') }}
),

links as (
    select
        id,
        links ->> 'self' as account_link
    from {{ source('main', 'raw_up_accounts') }}
)

select * from source
left join attributes on source.account_id = attributes.id
left join balance on source.account_id = balance.id
left join links on source.account_id = links.id
