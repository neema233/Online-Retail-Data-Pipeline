WITH customer_cte AS (
    SELECT DISTINCT
        {{ dbt_utils.generate_surrogate_key(['customer_id', 'country']) }} AS customer_id,
        country
    FROM {{ ref('cleaned_data') }}
    WHERE customer_id IS NOT NULL
)

SELECT *
FROM customer_cte
