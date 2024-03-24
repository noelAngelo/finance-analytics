select
    id,
    name,
    parent_id,
    category_link
from {{ ref('base_up__categories') }}
