[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) ![dbt logo and version](https://img.shields.io/static/v1?logo=dbt&label=dbt-version&message=0.20.x&color=orange)
# Facebook Ads Backwards Compatibility

This package models Facebook Ads data from [Fivetran's connector](https://fivetran.com/docs/applications/facebook-ads). It uses data in the format described by [this ERD](https://fivetran.com/docs/applications/facebook-ads#schemainformation). 

The main focus of the package is to transform the core ad object tables into models with schemas that match the old Fivetran Facebook connector. 

## Models

This package contains transformation models, designed to work simultaneously with our [Facebook Ads source package](https://github.com/fivetran/dbt_facebook_ads_source) and our [multi-platform Ad Reporting package](https://github.com/fivetran/dbt_ad_reporting). A dependency on the source package is declared in this package's `packages.yml` file, so it will automatically download when you run `dbt deps`. The primary outputs of this package are described below.

| **model**                                   | **description**                                                                                     |
| ------------------------------------------- | --------------------------------------------------------------------------------------------------  |
| stg_facebook_ads__app_link                  | Maps to the app_link table in the old connector                                                     |
| stg_facebook_ads__carousel_media_url_tags   | Maps to the carousel_media_url_tag table in the old connector                                       |
| stg_facebook_ads__carousel_media            | Maps to the carousel_media table in the old connector                                               |
| stg_facebook_ads__creative_history_asset_feed_spec_link_url    | Maps to the creative_history_asset_feed_spec_link_url table in the old connector |
| stg_facebook_ads__asset_feed_spec_link_url    | (Postgres Only) Maps to the creative_history_asset_feed_spec_link_url table in the old connector |
| stg_facebook_ads__url_tag                   | Maps to the url_tag table in the old connector                                                      |

## Installation Instructions

`dbt_facebook_ads_creative_history` currently supports `dbt 0.20.x`.

Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your `packages.yml`

```yaml
packages:
  - package: fivetran/facebook_ads_creative_history
    version: [">=0.3.0", "<0.4.0"]
```

## Configuration

By default, this package will look for your Facebook Ads data in the `facebook_ads` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your Facebook Ads data is, please add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    facebook_ads_schema: your_schema_name
    facebook_ads_database: your_database_name 
```

For additional configurations for the source models, visit the [Facebook Ads source package](https://github.com/fivetran/dbt_facebook_ads_source).

### Changing the Build Schema
By default this package will build the Facebook Ads staging models within a schema titled (<target_schema> + `_stg_facebook_ads`) and the Facebook Creative History final models with a schema titled (<target_schema> + `_facebook_ads_creative_history`) in your target database. If this is not where you would like your modeled Facebook data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
models:
  facebook_ads_creative_history:
    +schema: my_new_schema_name # leave blank for just the target_schema
  facebook_ads_source:
    +schema: my_new_schema_name # leave blank for just the target_schema
```
## Database Support

This package has been tested on BigQuery, Snowflake, Redshift, Postgres, and Spark.
## Contributions

Additional contributions to this package are very welcome! Please create issues or open PRs against `master`. Check out [this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

## Resources:
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Have questions or feedback, or need help? Book a time during our office hours [here](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or shoot us an email at solutions@fivetran.com.
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn how to orchestrate dbt transformations with Fivetran [here](https://fivetran.com/docs/transformations/dbt).
- Learn more about Fivetran overall [in our docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
