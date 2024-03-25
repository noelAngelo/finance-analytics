{% snapshot up_categories_snapshot %}
{{
    
        config(
        alias='up_categories_snapshot',
        target_schema='snapshots',
        unique_key='category_id',
        strategy='check',
        check_cols=['category_id', 'category_name', 'parent_category_id'],
        )
}}

select
        id as category_id,
        name as category_name,
        category_link,
        parent_id as parent_category_id,
        parent_type as parent_category_type,
        parent_related as parent_category_link,
        _loaded_timestamp
    from {{ ref('base_up__categories') }}

{% endsnapshot %}