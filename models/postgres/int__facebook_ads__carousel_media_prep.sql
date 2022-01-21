with base as (

    select *
    from {{ ref('stg_facebook_ads__creative_history') }}

), required_fields as (

    select
        _fivetran_id,
        creative_id,
        object_story_link_data_child_attachments,
        object_story_link_data_caption,
        object_story_link_data_description,
        object_story_link_data_link,
        object_story_link_data_message,
        source_relation
    from base
    where object_story_link_data_child_attachments is not null

), unnested as (

    select
        _fivetran_id,
        creative_id,
        object_story_link_data_caption as caption,
        object_story_link_data_description as description,
        object_story_link_data_message as message,
        element->>'link' as link,
        element->'url_tags' as url_tags,
        row_number() over (partition by _fivetran_id, creative_id) as index,
        source_relation
    from required_fields
    left join lateral json_array_elements(object_story_link_data_child_attachments::json) as element 
        on True
)

select *
from unnested
