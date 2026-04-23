SET NAMES utf8mb4;
START TRANSACTION;

SET @operator_id = COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), 1);

UPDATE relic
SET category_code = CASE category_code
    WHEN 'BRONZE_WARE' THEN 'BRONZE'
    WHEN 'PAINTING_CALLIGRAPHY' THEN 'PAINTING'
    WHEN 'JADE_ARTIFACT' THEN 'JADE'
    ELSE category_code
END,
    update_by = @operator_id,
    update_time = NOW()
WHERE deleted = 0
  AND category_code IN ('BRONZE_WARE', 'PAINTING_CALLIGRAPHY', 'JADE_ARTIFACT');

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

COMMIT;
