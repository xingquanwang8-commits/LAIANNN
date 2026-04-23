SET NAMES utf8mb4;
START TRANSACTION;

SET @operator_id = COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), 1);

DROP TEMPORARY TABLE IF EXISTS tmp_dict_type_seed;
CREATE TEMPORARY TABLE tmp_dict_type_seed (
    dict_name VARCHAR(100) NOT NULL,
    dict_type_code VARCHAR(100) NOT NULL PRIMARY KEY,
    status VARCHAR(20) NOT NULL,
    remark VARCHAR(500) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO tmp_dict_type_seed (dict_name, dict_type_code, status, remark) VALUES
    (CONVERT(0xE69687E789A9E7B1BBE588AB USING utf8mb4), 'relic_category', 'ENABLED', 'Base dictionary repair'),
    (CONVERT(0xE69687E789A9E69D90E8B4A8 USING utf8mb4), 'relic_material', 'ENABLED', 'Base dictionary repair'),
    (CONVERT(0xE8978FE59381E5BA93E4BD8D USING utf8mb4), 'storage_location', 'ENABLED', 'Base dictionary repair'),
    (CONVERT(0xE4BF9DE5AD98E78AB6E68081 USING utf8mb4), 'preservation_status', 'ENABLED', 'Base dictionary repair'),
    (CONVERT(0xE69687E789A9E78AB6E68081 USING utf8mb4), 'relic_status', 'ENABLED', 'Base dictionary repair'),
    (CONVERT(0xE587BAE5BA93E78AB6E68081 USING utf8mb4), 'outbound_status', 'ENABLED', 'Base dictionary repair'),
    (CONVERT(0xE79B98E782B9E4BBBBE58AA1E78AB6E68081 USING utf8mb4), 'inventory_task_status', 'ENABLED', 'Base dictionary repair'),
    (CONVERT(0xE4BFAEE5A48DE78AB6E68081 USING utf8mb4), 'repair_status', 'ENABLED', 'Base dictionary repair');

DROP TEMPORARY TABLE IF EXISTS tmp_dict_item_seed;
CREATE TEMPORARY TABLE tmp_dict_item_seed (
    dict_type_code VARCHAR(100) NOT NULL,
    item_label VARCHAR(100) NOT NULL,
    item_value VARCHAR(100) NOT NULL,
    item_sort INT NOT NULL,
    status VARCHAR(20) NOT NULL,
    remark VARCHAR(500) NULL,
    PRIMARY KEY (dict_type_code, item_value)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO tmp_dict_item_seed (
    dict_type_code, item_label, item_value, item_sort, status, remark
) VALUES
    ('inventory_task_status', CONVERT(0xE5B7B2E5889BE5BBBA USING utf8mb4), 'CREATED', 1, 'ENABLED', 'Base dictionary repair'),
    ('inventory_task_status', CONVERT(0xE79B98E782B9E4B8AD USING utf8mb4), 'IN_PROGRESS', 2, 'ENABLED', 'Base dictionary repair'),
    ('inventory_task_status', CONVERT(0xE5B7B2E5AE8CE68890 USING utf8mb4), 'COMPLETED', 3, 'ENABLED', 'Base dictionary repair'),

    ('outbound_status', CONVERT(0xE88D89E7A8BF USING utf8mb4), 'DRAFT', 1, 'ENABLED', 'Base dictionary repair'),
    ('outbound_status', CONVERT(0xE5BE85E5AEA1E689B9 USING utf8mb4), 'PENDING', 1, 'ENABLED', 'Base dictionary repair'),
    ('outbound_status', CONVERT(0xE5B7B2E5AEA1E689B9 USING utf8mb4), 'APPROVED', 2, 'ENABLED', 'Base dictionary repair'),
    ('outbound_status', CONVERT(0xE5B7B2E5BD92E8BF98 USING utf8mb4), 'RETURNED', 3, 'ENABLED', 'Base dictionary repair'),
    ('outbound_status', CONVERT(0xE5B7B2E9A9B3E59B9E USING utf8mb4), 'REJECTED', 4, 'ENABLED', 'Base dictionary repair'),

    ('preservation_status', CONVERT(0xE78AB6E586B5E889AFE5A5BD USING utf8mb4), 'GOOD', 1, 'DISABLED', 'Legacy compatibility dictionary item'),
    ('preservation_status', CONVERT(0xE5AE8CE695B4 USING utf8mb4), 'COMPLETE', 1, 'ENABLED', 'Base dictionary repair'),
    ('preservation_status', CONVERT(0xE8BDBBE5BEAEE7A0B4E68D9F USING utf8mb4), 'MINOR_DAMAGE', 2, 'DISABLED', 'Legacy compatibility dictionary item'),
    ('preservation_status', CONVERT(0xE8BDBBE5BAA6E79785E5AEB3 USING utf8mb4), 'DAMAGED', 2, 'DISABLED', 'Legacy compatibility dictionary item'),
    ('preservation_status', CONVERT(0xE59FBAE69CACE5AE8CE695B4 USING utf8mb4), 'BASIC_COMPLETE', 2, 'ENABLED', 'Base dictionary repair'),
    ('preservation_status', CONVERT(0xE5BE85E4BFAEE5A48D USING utf8mb4), 'PENDING_REPAIR', 3, 'DISABLED', 'Legacy compatibility dictionary item'),
    ('preservation_status', CONVERT(0xE5BE85E4BFAEE5A48D USING utf8mb4), 'TO_BE_REPAIRED', 3, 'DISABLED', 'Legacy compatibility dictionary item'),
    ('preservation_status', CONVERT(0xE6AE8BE7BCBA USING utf8mb4), 'INCOMPLETE', 3, 'ENABLED', 'Base dictionary repair'),
    ('preservation_status', CONVERT(0xE4B8A5E9878DE79785E5AEB3 USING utf8mb4), 'SEVERE_DAMAGE', 4, 'DISABLED', 'Legacy compatibility dictionary item'),
    ('preservation_status', CONVERT(0xE4B8A5E9878DE6AE8BE7BCBA USING utf8mb4), 'SEVERE_INCOMPLETE', 4, 'ENABLED', 'Base dictionary repair'),
    ('preservation_status', CONVERT(0xE4BFAEE5A48DE4B8AD USING utf8mb4), 'UNDER_REPAIR', 5, 'DISABLED', 'Legacy compatibility dictionary item'),
    ('preservation_status', CONVERT(0xE6AE8BE7A28E USING utf8mb4), 'FRAGMENTED', 5, 'ENABLED', 'Base dictionary repair'),
    ('preservation_status', CONVERT(0xE5B7B2E4BFAEE5A48D USING utf8mb4), 'RESTORED', 6, 'DISABLED', 'Legacy compatibility dictionary item'),
    ('preservation_status', CONVERT(0xE789A9E79086E69CBAE6A2B0E68D9FE4BCA4 USING utf8mb4), 'PHYSICAL_DAMAGE', 6, 'ENABLED', 'Base dictionary repair'),
    ('preservation_status', CONVERT(0xE99C80E9878DE782B9E585B3E6B3A8 USING utf8mb4), 'FRAGILE', 7, 'DISABLED', 'Legacy compatibility dictionary item'),
    ('preservation_status', CONVERT(0xE58C96E5ADA6E58AA3E58C96 USING utf8mb4), 'CHEMICAL_DEGRADATION', 7, 'ENABLED', 'Base dictionary repair'),
    ('preservation_status', CONVERT(0xE7949FE789A9E79785E5AEB3 USING utf8mb4), 'BIOLOGICAL_DISEASE', 8, 'ENABLED', 'Base dictionary repair'),

    ('relic_category', CONVERT(0xE99D92E9939CE599A8 USING utf8mb4), 'BRONZE', 1, 'ENABLED', 'Base dictionary repair'),
    ('relic_category', CONVERT(0xE999B6E793B7E599A8 USING utf8mb4), 'CERAMIC', 2, 'ENABLED', 'Base dictionary repair'),
    ('relic_category', CONVERT(0xE4B9A6E794BB USING utf8mb4), 'PAINTING', 3, 'ENABLED', 'Base dictionary repair'),
    ('relic_category', CONVERT(0xE79FB3E588BBE980A0E5838F USING utf8mb4), 'STONE', 4, 'ENABLED', 'Base dictionary repair'),
    ('relic_category', CONVERT(0xE98791E993B6E599A8 USING utf8mb4), 'GOLD_SILVER_WARE', 5, 'ENABLED', 'Legacy compatibility dictionary item'),
    ('relic_category', CONVERT(0xE78E89E599A8 USING utf8mb4), 'JADE', 5, 'ENABLED', 'Base dictionary repair'),
    ('relic_category', CONVERT(0xE69CA8E599A8 USING utf8mb4), 'WOOD_ARTIFACT', 6, 'ENABLED', 'Legacy compatibility dictionary item'),
    ('relic_category', CONVERT(0xE6BC86E599A8 USING utf8mb4), 'LACQUER', 6, 'ENABLED', 'Base dictionary repair'),
    ('relic_category', CONVERT(0xE999B6E4BF91 USING utf8mb4), 'POTTERY', 7, 'ENABLED', 'Base dictionary repair'),
    ('relic_category', CONVERT(0xE98791E599A8 USING utf8mb4), 'GOLD', 8, 'ENABLED', 'Base dictionary repair'),
    ('relic_category', CONVERT(0xE7AE80E7898D USING utf8mb4), 'BAMBOO', 9, 'ENABLED', 'Base dictionary repair'),
    ('relic_category', CONVERT(0xE69CA8E99B95 USING utf8mb4), 'WOOD', 10, 'ENABLED', 'Base dictionary repair'),

    ('relic_material', CONVERT(0xE99D92E9939C USING utf8mb4), 'BRONZE', 1, 'ENABLED', 'Base dictionary repair'),
    ('relic_material', CONVERT(0xE793B7 USING utf8mb4), 'PORCELAIN', 2, 'ENABLED', 'Base dictionary repair'),
    ('relic_material', CONVERT(0xE7BAB8E69CAC USING utf8mb4), 'PAPER', 3, 'ENABLED', 'Base dictionary repair'),
    ('relic_material', CONVERT(0xE7BBA2E69CAC USING utf8mb4), 'SILK', 3, 'ENABLED', 'Base dictionary repair'),
    ('relic_material', CONVERT(0xE79FB3E69D90 USING utf8mb4), 'STONE', 4, 'ENABLED', 'Base dictionary repair'),
    ('relic_material', CONVERT(0xE78E89E79FB3 USING utf8mb4), 'JADE', 5, 'ENABLED', 'Base dictionary repair'),
    ('relic_material', CONVERT(0xE993B6 USING utf8mb4), 'SILVER', 6, 'ENABLED', 'Base dictionary repair'),
    ('relic_material', CONVERT(0xE6BC86E69CA8 USING utf8mb4), 'LACQUER_WOOD', 6, 'ENABLED', 'Base dictionary repair'),
    ('relic_material', CONVERT(0xE999B6E59C9F USING utf8mb4), 'CLAY', 7, 'ENABLED', 'Base dictionary repair'),
    ('relic_material', CONVERT(0xE69CA8 USING utf8mb4), 'WOOD', 7, 'ENABLED', 'Base dictionary repair'),
    ('relic_material', CONVERT(0xE98791 USING utf8mb4), 'GOLD', 8, 'ENABLED', 'Base dictionary repair'),
    ('relic_material', CONVERT(0xE7ABB9E69CA8 USING utf8mb4), 'BAMBOO_WOOD', 9, 'ENABLED', 'Base dictionary repair'),

    ('relic_status', CONVERT(0xE5BE85E585A5E5BA93 USING utf8mb4), 'TO_BE_INBOUND', 1, 'ENABLED', 'Base dictionary repair'),
    ('relic_status', CONVERT(0xE59CA8E5BA93 USING utf8mb4), 'IN_STOCK', 2, 'ENABLED', 'Base dictionary repair'),
    ('relic_status', CONVERT(0xE585A5E5BA93E5BE85E5AEA1E689B9 USING utf8mb4), 'INBOUND_PENDING', 3, 'ENABLED', 'Base dictionary repair'),
    ('relic_status', CONVERT(0xE587BAE5BA93E5BE85E5AEA1E689B9 USING utf8mb4), 'OUTBOUND_PENDING', 4, 'ENABLED', 'Base dictionary repair'),
    ('relic_status', CONVERT(0xE5B7B2E587BAE5BA93 USING utf8mb4), 'OUT_STOCK', 5, 'ENABLED', 'Base dictionary repair'),
    ('relic_status', CONVERT(0xE4BFAEE5A48DE4B8AD USING utf8mb4), 'IN_REPAIR', 6, 'ENABLED', 'Base dictionary repair'),

    ('repair_status', CONVERT(0xE5B7B2E794B3E8AFB7 USING utf8mb4), 'APPLIED', 1, 'ENABLED', 'Base dictionary repair'),
    ('repair_status', CONVERT(0xE5B7B2E5AEA1E689B9 USING utf8mb4), 'APPROVED', 2, 'ENABLED', 'Base dictionary repair'),
    ('repair_status', CONVERT(0xE4BFAEE5A48DE4B8AD USING utf8mb4), 'IN_PROGRESS', 3, 'ENABLED', 'Base dictionary repair'),
    ('repair_status', CONVERT(0xE5B7B2E5AE8CE68890 USING utf8mb4), 'COMPLETED', 4, 'ENABLED', 'Base dictionary repair'),
    ('repair_status', CONVERT(0xE5B7B2E9AA8CE694B6 USING utf8mb4), 'ACCEPTED', 5, 'ENABLED', 'Base dictionary repair'),
    ('repair_status', CONVERT(0xE5B7B2E9A9B3E59B9E USING utf8mb4), 'REJECTED', 6, 'ENABLED', 'Base dictionary repair'),

    ('storage_location', CONVERT(0xE4B880E58FB7E5B195E58E85 USING utf8mb4), 'EXHIBIT_HALL_1', 1, 'ENABLED', 'Compatibility storage location'),
    ('storage_location', CONVERT(0xE4B880E58FB7E7BBBCE59088E5BA93 USING utf8mb4), 'LOC_A', 1, 'ENABLED', 'Base dictionary repair'),
    ('storage_location', CONVERT(0xE4BA8CE58FB7E5B195E58E85 USING utf8mb4), 'EXHIBIT_HALL_2', 2, 'ENABLED', 'Compatibility storage location'),
    ('storage_location', CONVERT(0xE4BA8CE58FB7E68192E6B8A9E5BA93 USING utf8mb4), 'LOC_B', 2, 'ENABLED', 'Base dictionary repair'),
    ('storage_location', CONVERT(0xE4B889E58FB7E5BA93E688BF USING utf8mb4), 'STORAGE_ROOM_3', 3, 'ENABLED', 'Compatibility storage location'),
    ('storage_location', CONVERT(0xE4B889E58FB7E7B2BEE59381E5BA93 USING utf8mb4), 'LOC_C', 3, 'ENABLED', 'Base dictionary repair'),
    ('storage_location', CONVERT(0xE4BFAEE5A48DE5AEA4 USING utf8mb4), 'RESTORATION_ROOM', 4, 'ENABLED', 'Compatibility storage location'),
    ('storage_location', CONVERT(0xE69687E4BF9DE4BFAEE5A48DE5BA93 USING utf8mb4), 'LOC_D', 4, 'ENABLED', 'Base dictionary repair'),
    ('storage_location', CONVERT(0xE69A82E5AD98E58CBA USING utf8mb4), 'TEMP_STORAGE', 5, 'ENABLED', 'Compatibility storage location'),
    ('storage_location', CONVERT(0xE78F8DE59381E4B893E69F9C USING utf8mb4), 'LOC_VIP', 5, 'ENABLED', 'Base dictionary repair');

DROP TEMPORARY TABLE IF EXISTS tmp_used_dict_item;
CREATE TEMPORARY TABLE tmp_used_dict_item (
    dict_type_code VARCHAR(100) NOT NULL,
    item_value VARCHAR(100) NOT NULL,
    PRIMARY KEY (dict_type_code, item_value)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

UPDATE relic
SET category_code = CASE category_code
    WHEN 'BRONZE_WARE' THEN 'BRONZE'
    WHEN 'PAINTING_CALLIGRAPHY' THEN 'PAINTING'
    WHEN 'JADE_ARTIFACT' THEN 'JADE'
    ELSE category_code
END
WHERE deleted = 0
  AND category_code IN ('BRONZE_WARE', 'PAINTING_CALLIGRAPHY', 'JADE_ARTIFACT');

INSERT IGNORE INTO tmp_used_dict_item (dict_type_code, item_value)
SELECT 'relic_category', category_code
FROM relic
WHERE deleted = 0 AND category_code IS NOT NULL AND category_code <> ''
GROUP BY category_code;

INSERT IGNORE INTO tmp_used_dict_item (dict_type_code, item_value)
SELECT 'relic_material', material_code
FROM relic
WHERE deleted = 0 AND material_code IS NOT NULL AND material_code <> ''
GROUP BY material_code;

INSERT IGNORE INTO tmp_used_dict_item (dict_type_code, item_value)
SELECT 'storage_location', storage_location_code
FROM relic
WHERE deleted = 0 AND storage_location_code IS NOT NULL AND storage_location_code <> ''
GROUP BY storage_location_code;

INSERT IGNORE INTO tmp_used_dict_item (dict_type_code, item_value)
SELECT 'preservation_status', preservation_status_code
FROM relic
WHERE deleted = 0 AND preservation_status_code IS NOT NULL AND preservation_status_code <> ''
GROUP BY preservation_status_code;

INSERT IGNORE INTO tmp_used_dict_item (dict_type_code, item_value)
SELECT 'relic_status', current_status
FROM relic
WHERE deleted = 0 AND current_status IS NOT NULL AND current_status <> ''
GROUP BY current_status;

INSERT IGNORE INTO tmp_used_dict_item (dict_type_code, item_value)
SELECT 'outbound_status', approve_status
FROM relic_outbound_order
WHERE deleted = 0 AND approve_status IS NOT NULL AND approve_status <> ''
GROUP BY approve_status;

INSERT IGNORE INTO tmp_used_dict_item (dict_type_code, item_value)
SELECT 'inventory_task_status', task_status
FROM inventory_task
WHERE deleted = 0 AND task_status IS NOT NULL AND task_status <> ''
GROUP BY task_status;

INSERT IGNORE INTO tmp_used_dict_item (dict_type_code, item_value)
SELECT 'repair_status', task_status
FROM repair_task
WHERE deleted = 0 AND task_status IS NOT NULL AND task_status <> ''
GROUP BY task_status;

INSERT INTO sys_dict_type (
    dict_name, dict_type_code, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT
    s.dict_name, s.dict_type_code, s.status, s.remark, @operator_id, NOW(), @operator_id, NOW(), 0
FROM tmp_dict_type_seed s
LEFT JOIN sys_dict_type t ON t.dict_type_code = s.dict_type_code
WHERE t.id IS NULL;

UPDATE sys_dict_type t
JOIN tmp_dict_type_seed s ON s.dict_type_code = t.dict_type_code
SET t.dict_name = s.dict_name,
    t.status = s.status,
    t.remark = s.remark,
    t.update_by = @operator_id,
    t.update_time = NOW(),
    t.deleted = 0;

INSERT INTO sys_dict_item (
    dict_type_code, item_label, item_value, item_sort, status, css_class, remark,
    create_by, create_time, update_by, update_time, deleted
)
SELECT
    s.dict_type_code, s.item_label, s.item_value, s.item_sort, s.status, NULL, s.remark,
    @operator_id, NOW(), @operator_id, NOW(), 0
FROM tmp_dict_item_seed s
LEFT JOIN sys_dict_item i
    ON i.dict_type_code = s.dict_type_code
   AND i.item_value = s.item_value
WHERE i.id IS NULL;

UPDATE sys_dict_item i
JOIN tmp_dict_item_seed s
    ON s.dict_type_code = i.dict_type_code
   AND s.item_value = i.item_value
SET i.item_label = s.item_label,
    i.item_sort = s.item_sort,
    i.status = s.status,
    i.remark = s.remark,
    i.update_by = @operator_id,
    i.update_time = NOW(),
    i.deleted = 0;

INSERT INTO sys_dict_item (
    dict_type_code, item_label, item_value, item_sort, status, css_class, remark,
    create_by, create_time, update_by, update_time, deleted
)
SELECT
    u.dict_type_code, u.item_value, u.item_value, 999, 'ENABLED', NULL, 'Recovered from business data',
    @operator_id, NOW(), @operator_id, NOW(), 0
FROM tmp_used_dict_item u
LEFT JOIN sys_dict_item i
    ON i.dict_type_code = u.dict_type_code
   AND i.item_value = u.item_value
WHERE i.id IS NULL;

UPDATE sys_dict_item i
JOIN tmp_used_dict_item u
    ON u.dict_type_code = i.dict_type_code
   AND u.item_value = i.item_value
SET i.item_label = CASE
        WHEN i.item_label IS NULL OR i.item_label = '' THEN i.item_value
        ELSE i.item_label
    END,
    i.status = 'ENABLED',
    i.update_by = @operator_id,
    i.update_time = NOW(),
    i.deleted = 0;

UPDATE sys_dict_type t
JOIN (
    SELECT id
    FROM (
        SELECT
            id,
            ROW_NUMBER() OVER (PARTITION BY dict_type_code ORDER BY deleted ASC, id ASC) AS rn
        FROM sys_dict_type
    ) ranked_type
    WHERE rn > 1
) duplicated_type ON duplicated_type.id = t.id
SET t.deleted = 1,
    t.update_by = @operator_id,
    t.update_time = NOW();

UPDATE sys_dict_item i
JOIN (
    SELECT id
    FROM (
        SELECT
            id,
            ROW_NUMBER() OVER (
                PARTITION BY dict_type_code, item_value
                ORDER BY deleted ASC, id ASC
            ) AS rn
        FROM sys_dict_item
    ) ranked_item
    WHERE rn > 1
) duplicated_item ON duplicated_item.id = i.id
SET i.deleted = 1,
    i.update_by = @operator_id,
    i.update_time = NOW();

UPDATE sys_dict_item
SET status = 'DISABLED',
    deleted = 1,
    update_by = @operator_id,
    update_time = NOW()
WHERE dict_type_code = 'relic_category'
  AND item_value IN ('BRONZE_WARE', 'PAINTING_CALLIGRAPHY', 'JADE_ARTIFACT');

UPDATE sys_dict_item
SET status = 'ENABLED',
    deleted = 0,
    update_by = @operator_id,
    update_time = NOW()
WHERE dict_type_code = 'relic_category'
  AND item_value IN ('BRONZE', 'PAINTING', 'JADE');

DROP TEMPORARY TABLE IF EXISTS tmp_used_dict_item;
DROP TEMPORARY TABLE IF EXISTS tmp_dict_item_seed;
DROP TEMPORARY TABLE IF EXISTS tmp_dict_type_seed;

COMMIT;
