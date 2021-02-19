{{ config(enabled=target.type=='snowflake') }}

with base as (

    select *
    from {{ ref('int__facebook_ads__carousel_media_prep') }}
  
), unnested as (

    select 
    
        _fivetran_id,
        creative_id,
        index,
        url_tags:key::string as key,
        url_tags:value::string as value
    
    from base
)

select *
from unnested