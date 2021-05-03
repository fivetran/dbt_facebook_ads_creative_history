with base as (

    select *
    from {{ ref('stg_facebook_ads__creative_history') }}

), required_fields as (

    select
        _fivetran_id,
        creative_id,
        explode(from_json(url_tags, 'array<struct<key:STRING, value:STRING, type:STRING>>')) as url_tags
    from base
    where url_tags is not null


), flattened_url_tags as (

    select
        _fivetran_id,
        creative_id,
        url_tags.key as key,
        url_tags.value as value,
        url_tags.type as type
    from required_fields


)

select *
from flattened_url_tags
