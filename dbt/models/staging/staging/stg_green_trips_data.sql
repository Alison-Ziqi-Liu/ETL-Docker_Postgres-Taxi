{{
    config(
        materialized='view'
    )
}}

with tripdata as (
    select *,
    row_number() over(partition by vendorid,lpep_pickup_datetime) as rn
    from {{ source('staging', 'green_trips_data') }}
    where venforid is not null
)


select
    {{dbt_utils.generate_surrogate_key(['vendorid','lpep_pickup_datetime'])}} as trip_id,
    vendorid,
    lpep_pickup_datetime,
    lpep_dropoff_datetime,
    store_and_fwd_flag,
    ratecodeid,
    pulocationid,
    dolocationid,
    passenger_count,
    trip_distance,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    cast(ehail_fee as numeric) as ehail_fee,
    improvement_surcharge,
    total_amount,
    {{get_payment_desc('payment_type')}} as payment_type,
    trip_type,
    congestion_surcharge

from green_trips_data
where rn=1

{% if var('is_test_run',default=true) %}
    limit 100
{% endif %}