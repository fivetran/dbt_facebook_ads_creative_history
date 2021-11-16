with base as (

    select *
    from {{ ref('int__facebook_ads__carousel_media_prep') }}

), unnested as (

    select
        _fivetran_id,
        creative_id,
        index,
        explode(url_tags) as url_tag,
        source_relation
    from base

), extract_values as (

    select 
        _fivetran_id,
        creative_id,
        index,
        url_tag.value,
        url_tag.key,
        source_relation
    from unnested

)

select *
from extract_values
