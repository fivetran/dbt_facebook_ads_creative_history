with base as (

    select *
    from {{ ref('int__facebook_ads__carousel_media_prep') }}

), unnested as (

    select
        _fivetran_id,
        creative_id,
        index,
        element->>'key' as key,
        element->>'value' as value,
        source_relation
    from base
    inner join lateral json_array_elements(url_tags) as element 
        on True

)

select *
from unnested
