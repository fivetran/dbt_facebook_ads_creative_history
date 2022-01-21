with base as (

    select *
    from {{ ref('stg_facebook_ads__creative_history') }}

), required_fields as (

    select
        _fivetran_id,
        creative_id,
        url_tags,
        source_relation
    from base
    where url_tags is not null

), cleaned_json as (

    select
        _fivetran_id,
        creative_id,
        json_extract_array(replace(trim(url_tags, '"'),'\\','')) as cleaned_url_tags,
        source_relation
    from required_fields

), unnested as (

    select 
        _fivetran_id, 
        creative_id, 
        url_tag_element, 
        source_relation
    from cleaned_json
    left join unnest(cleaned_url_tags) as url_tag_element
    where cleaned_url_tags is not null

), fields as (

    select
        _fivetran_id,
        creative_id,
        json_extract_scalar(url_tag_element, '$.key') as key,
        json_extract_scalar(url_tag_element, '$.value') as value,
        json_extract_scalar(url_tag_element, '$.type') as type,
        source_relation
    from unnested

)

select *
from fields
