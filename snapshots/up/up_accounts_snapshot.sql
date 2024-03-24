{% snapshot up_accounts_snapshot %}

{{
    config(
      alias='up_accounts_snapshot',
      target_schema='snapshots',
      unique_key='account_id',
      strategy='check',
      check_cols=['display_name'],
    )
}}

select
        account_id,
        display_name,
        account_type,
        ownership_type,
        {{ generate_date_key('created_at') }},
        _loaded_timestamp
    from {{ ref('base_up__accounts')}}

{% endsnapshot %}