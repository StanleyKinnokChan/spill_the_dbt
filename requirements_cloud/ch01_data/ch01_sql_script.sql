WITH UNIQUE_PARTS AS (
    SELECT 
        P.part_num
    FROM {{ source('lego', 'parts') }} AS P
    INNER JOIN {{ source('lego', 'inventory_parts') }} AS IP ON P.part_num = IP.part_num
    INNER JOIN {{ source('lego', 'inventories') }} AS I ON I.id = IP.inventory_id
    INNER JOIN {{ source('lego', 'sets') }} AS S ON S.set_num = I.set_num
    GROUP BY P.part_num
    HAVING COUNT(*) = 1
)
SELECT 
    T.name AS theme_name,
    S.name AS set_name,
    S.year AS set_year,
    CASE 
        WHEN UP.part_num IS NULL THEN 'Not Unique' 
        ELSE 'Unique' 
    END AS unique_part,
    COUNT(P.part_num) AS parts
FROM {{ source('lego', 'parts') }} AS P
LEFT JOIN UNIQUE_PARTS AS UP ON P.part_num = UP.part_num
INNER JOIN {{ source('lego', 'inventory_parts') }} AS IP ON P.part_num = IP.part_num
INNER JOIN {{ source('lego', 'inventories') }} AS I ON I.id = IP.inventory_id
INNER JOIN {{ source('lego', 'sets') }} AS S ON S.set_num = I.set_num
INNER JOIN {{ source('lego', 'themes') }} AS T ON T.id = S.theme_id
GROUP BY 1, 2, 3, 4
