with base as (

    select *
    from {{ ref('stg_facebook_ads__creative_history') }}

), required_fields as (

    select
        _fivetran_id,
        creative_id,
        object_story_link_data_caption,
        object_story_link_data_description,
        object_story_link_data_link,
        object_story_link_data_message,
        explode(
          from_json(
              object_story_link_data_child_attachments,
              'array<struct<link:STRING, url_tags:array<struct<key:STRING, type:STRING, value:STRING>>>>'
            ) 
          ) as child_attachments,
        source_relation
    from base
    where object_story_link_data_child_attachments is not null

), flattened_child_attachments as (

    select
        _fivetran_id,
        creative_id,
        object_story_link_data_caption as caption,
        object_story_link_data_description as description,
        object_story_link_data_message as message,
        child_attachments as element,
        child_attachments.link  as link,
        child_attachments.url_tags as url_tags,
        row_number() over (partition by _fivetran_id, creative_id order by child_attachments.link) as index,
        source_relation
    from required_fields

)

select *
from flattened_child_attachments
