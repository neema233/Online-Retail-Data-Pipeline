-- fct_invoices.sql

-- Create the fact table by joining the relevant keys from dimension table
WITH fct_invoices_cte AS (
    SELECT
        invoice_no,
        CAST(invoice_date as timestamp) AS datetime_id,
        {{ dbt_utils.generate_surrogate_key(['stock_code', 'description', 'unit_price']) }} as product_id,
        {{ dbt_utils.generate_surrogate_key(['customer_id', 'country']) }} as customer_id,
        quantity,
        quantity * unit_price AS total
    FROM {{ ref ('cleaned_data') }}
    WHERE Quantity > 0
)
SELECT
    invoice_no,
    dt.datetime_id,
    dp.product_id,
    dc.customer_id,
    quantity,
    total
FROM fct_invoices_cte fi
INNER JOIN {{ ref('dim_datetime') }} dt ON fi.datetime_id = dt.datetime_id
INNER JOIN {{ ref('dim_product') }} dp ON fi.product_id = dp.product_id
INNER JOIN {{ ref('dim_customer') }} dc ON fi.customer_id = dc.customer_id