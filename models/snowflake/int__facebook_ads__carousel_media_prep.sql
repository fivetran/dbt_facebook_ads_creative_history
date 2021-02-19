{{ config(enabled=target.type=='snowflake') }}

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
        parse_json(object_story_link_data_child_attachments) as child_attachments
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
        attachments.index as index,
        attachments.value:link  as link,
        attachments.value:url_tags as url_tags
  
    from required_fields, 
    lateral flatten( input => child_attachments ) as attachments

), flattened_url_tags as (
    
    select 
        _fivetran_id,
        creative_id,
        caption, 
        description, 
        message,
        element,
        flattened_child_attachments.index,
        link,
        url_tags.value as url_tags

    from flattened_child_attachments, 
    lateral flatten( input => url_tags ) as url_tags
)

select *
from flattened_url_tags