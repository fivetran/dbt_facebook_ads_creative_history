
with base as (

  select *
  from {{ ref('stg_facebook_ads__creative_history') }}

), required_fields as (

  select
    _fivetran_id,
    creative_id,
    {% for app in ['ios','ipad','android','iphone'] %}
    from_json(
      template_app_link_spec_{{ app }}, 
      'array<struct<index:INT, app_name:STRING, app_store_id:STRING, url:STRING, class_name:STRING, package_name:STRING, template_page:STRING>>') 
    as template_app_link_spec_{{ app }} 
    {% if not loop.last %},{% endif %}
    {% endfor %}
  from base

{% for app in ['ios','ipad','android','iphone'] %}

), exploded_{{ app }} as (

  select 
    *,
    explode(template_app_link_spec_{{ app }}) as element
  from required_fields

), flattened_{{ app }} as (

  select
    _fivetran_id,
    creative_id,
    '{{ app }}' as app_type,
    element.index as index,
    element.app_name as app_name,
    element.app_store_id as app_store_id,
    element.class_name as class_name,
    element.package_name as package_name,
    element.template_page as template_page
  from exploded_{{ app }}

{% endfor %}

), unioned as (

    select * from flattened_ios
    union all
    select * from flattened_iphone
    union all
    select * from flattened_ipad
    union all
    select * from flattened_android

)

select *
from unioned
