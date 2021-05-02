with base as (

    select *
    from {{ ref('stg_facebook_ads__creative_history') }}

), required_fields as (

    select
        _fivetran_id,
        explode(from_json(asset_feed_spec_link_urls, 'array<struct<display_url:STRING, website_url:STRING>>')) as asset_feed_spec_link_urls
    from base
    where asset_feed_spec_link_urls is not null

), flattened as (

    select
        _fivetran_id,
        nullif(asset_feed_spec_link_urls.display_url, '') as display_url,
        nullif(asset_feed_spec_link_urls.website_url, '') as website_url,
        row_number() over (partition by _fivetran_id order by _fivetran_id) as index
    from required_fields

)

select *
from flattened

