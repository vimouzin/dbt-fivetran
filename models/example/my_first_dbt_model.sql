{{ config(materialized='table') }}

with user_events_clean as (
    select
        id as event_id,
        user_id,
        event_type,
        event_time
    from FIVETRAN.POSTGRES_PUBLIC.USER_EVENTS
),

users_clean as (
    select
        id as user_id,
        name,
        email,
        created_at
    from FIVETRAN.POSTGRES_PUBLIC.USERS
),

products_clean as (
    select
        id as product_id,
        name as product_name,
        category,
        price,
        in_stock
    from FIVETRAN.POSTGRES_PUBLIC.PRODUCTS
),

orders_clean as (
    select
        id as order_id,
        user_id,
        product_id,
        quantity,
        order_date
    from FIVETRAN.POSTGRES_PUBLIC.ORDERS
)

select
    o.order_id,
    u.user_id,
    u.name as user_name,
    u.email as user_email,
    u.created_at as user_created_at,
    oe.event_id,
    oe.event_type,
    oe.event_time,
    o.quantity,
    o.order_date,
    p.product_id,
    p.product_name,
    p.category as product_category,
    p.price as product_price,
    p.in_stock
from user_events_clean oe
left join users_clean u on oe.user_id = u.user_id
left join orders_clean o on u.user_id = o.user_id
left join products_clean p on o.product_id = p.product_id
