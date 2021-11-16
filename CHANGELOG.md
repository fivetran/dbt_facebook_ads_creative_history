# dbt_facebook_ads_creative_history v0.4.0

## Features
- Allow for multiple sources by unioning source tables across multiple Facebook Ads connectors.
  - Refer to the [README](https://github.com/fivetran/dbt_facebook_ads_creative_history#unioning-multiple-facebook-ad-connectors) for more details.

## Under the Hood
- Unioning: The unioning occurs in the staging tmp models using the `fivetran_utils.union_data` macro.
- Unique tests: Because columns that were previously used for unique tests may now have duplicate fields across multiple sources, these columns are combined with the new `source_relation` column for unique tests and tested using the `dbt_utils.unique_combination_of_columns` macro.
- Source Relation column: To distinguish which source each record comes from, we added a new `source_relation` column in each staging and final model and applied the `fivetran_utils.source_relation` macro.
    - The `source_relation` column is included in all joins and window function partition clauses in the transform package. Note that an event from one Facebook Ad source will _never_ be attributed to an event from a different Facebook Ad connector.

## Contributors
- [@pawelngei](https://github.com/pawelngei)

# dbt_facebook_ads_creative_history v0.1.0 -> v0.4.0
Refer to the relevant release notes on the Github repository for specific details for the previous releases. Thank you!