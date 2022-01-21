with base as (

  select *
  from {{ ref('stg_facebook_ads__creative_history') }}

), required_fields as (

  select
    _fivetran_id,
    creative_id,
    template_app_link_spec_ios,
    template_app_link_spec_ipad,
    template_app_link_spec_android,
    template_app_link_spec_iphone,
    source_relation
  from base

{% for app in ['ios','ipad','android','iphone'] %}

), unnested_{{ app }} as (

  select
    _fivetran_id,
    creative_id,
    '{{ app }}' as app_type,
    element->>'index' as index,
    element->>'app_name' as app_name,
    element->>'app_store_id' as app_store_id,
    element->>'class' as class_name,
    element->>'package' as package_name,
    element->>'template_page' as template_page,
    source_relation
  from required_fields
  left join lateral json_array_elements(template_app_link_spec_{{ app }}::json) as element on True
  {# TODO: on True... True and source_relation? #}

{% endfor %}

), unioned as (

    select * from unnested_ios
    union all
    select * from unnested_iphone
    union all
    select * from unnested_ipad
    union all
    select * from unnested_android

)

select *
from unioned
