with base as (

    select *
    from {{ ref('stg_facebook_ads__creative_history') }}

), required_fields as (

    select
        _fivetran_id,
        asset_feed_spec_link_urls,
        source_relation
    from base
    where asset_feed_spec_link_urls is not null

), unnested as (

    select
        _fivetran_id,
        nullif(elements->>'display_url','') as display_url,
        nullif(elements->>'website_url','') as website_url,
        row_number() over (partition by _fivetran_id) as index,
        source_relation
    from required_fields
    left join lateral json_array_elements(asset_feed_spec_link_urls::json) as elements 
        on True

)

select *
from unnested

