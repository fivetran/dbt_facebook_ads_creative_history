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
        replace(trim(url_tags::text, '"'),'\\','')::json as cleaned_url_tags,
        source_relation,
    from required_fields

), unnested as (

    select _fivetran_id, creative_id, url_tag_element, source_relation
    from cleaned_json
    left join lateral json_array_elements(cleaned_url_tags) as url_tag_element on True
    {# TODO: on True... True and source_relation? #}
    where cleaned_url_tags is not null

), fields as (

    select
        _fivetran_id,
        creative_id,
        url_tag_element->>'key' as key,
        url_tag_element->>'value' as value,
        url_tag_element->>'type' as type,
        source_relation
    from unnested

)

select *
from fields
