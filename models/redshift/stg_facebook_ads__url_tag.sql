with base as (

    select *
    from {{ ref('stg_facebook_ads__creative_history') }}

), numbers as (

    select *
    from {{ ref('utils__facebook_ads__numbers') }}

), required_fields as (

    select
        _fivetran_id,
        creative_id,
        url_tags,
        source_relation
    from base
    where url_tags is not null


), flattened_url_tags as (

    select
        _fivetran_id,
        creative_id,
        json_extract_array_element_text(required_fields.url_tags, numbers.generated_number::int - 1, true) as element,
        source_relation
    from required_fields
    inner join numbers
        on json_array_length(required_fields.url_tags) >= numbers.generated_number


), extracted_fields as (

    select
        _fivetran_id,
        creative_id,
        json_extract_path_text(element,'key') as key,
        json_extract_path_text(element,'value') as value,
        json_extract_path_text(element,'type') as type,
        source_relation
    from flattened_url_tags

)

select *
from extracted_fields
