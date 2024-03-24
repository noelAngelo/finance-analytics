with source as (
    select * from {{ source('main', 'raw_up_categories') }}
),

attributes as (
    select
        id,
        attributes ->> 'name' as name,
        _loaded_timestamp
    from source
),

parent as (
    select
        id,
        relationships -> 'parent' -> 'data' ->> 'id' as parent_id,
        relationships -> 'parent' -> 'data' ->> 'type' as parent_type,
        relationships -> 'parent' -> 'links' ->> 'related' as parent_related
    from source
),

children as (
    select
        id,
        relationships -> 'children' -> 'data' as children_data
    from source
),

links as (
    select
        id,
        links ->> 'self' as category_link
    from source
)

select * 
from attributes
left join parent on attributes.id = parent.id
left join children on attributes.id = children.id
left join links on attributes.id = links.id
