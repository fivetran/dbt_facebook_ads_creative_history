with base as (

    select *
    from {{ ref('int__facebook_ads__carousel_media_prep') }}

), fields as (

    select
        _fivetran_id,
        creative_id,
        caption,
        description,
        message,
        link,
        index,
        source_relation
    from base

)

select *
from fields
