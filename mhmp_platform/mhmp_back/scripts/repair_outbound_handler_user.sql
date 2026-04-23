SET NAMES utf8mb4;
START TRANSACTION;

SET @operator_id = COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), 1);

SET @has_handler_user_id = (
    SELECT COUNT(*)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'relic_outbound_order'
      AND COLUMN_NAME = 'handler_user_id'
);

SET @ddl_sql = IF(
    @has_handler_user_id = 0,
    'ALTER TABLE relic_outbound_order ADD COLUMN handler_user_id BIGINT NULL COMMENT ''经手人用户ID'' AFTER destination',
    'SELECT 1'
);
PREPARE stmt FROM @ddl_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @has_handler_index = (
    SELECT COUNT(*)
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'relic_outbound_order'
      AND INDEX_NAME = 'idx_relic_outbound_order_handler_user_id'
);

SET @index_sql = IF(
    @has_handler_index = 0,
    'CREATE INDEX idx_relic_outbound_order_handler_user_id ON relic_outbound_order (handler_user_id)',
    'SELECT 1'
);
PREPARE stmt FROM @index_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

UPDATE relic_outbound_order o
LEFT JOIN sys_user matched_user
    ON matched_user.deleted = 0
   AND (
        matched_user.real_name = o.handler_name
        OR matched_user.nick_name = o.handler_name
        OR matched_user.username = o.handler_name
   )
LEFT JOIN sys_user apply_user
    ON apply_user.id = o.apply_user_id
   AND apply_user.deleted = 0
SET o.handler_user_id = COALESCE(o.handler_user_id, matched_user.id, apply_user.id),
    o.handler_name = CASE
        WHEN matched_user.id IS NOT NULL THEN COALESCE(NULLIF(matched_user.real_name, ''), NULLIF(matched_user.nick_name, ''), matched_user.username, o.handler_name)
        WHEN o.handler_user_id IS NULL AND apply_user.id IS NOT NULL THEN COALESCE(NULLIF(apply_user.real_name, ''), NULLIF(apply_user.nick_name, ''), apply_user.username, o.handler_name)
        ELSE o.handler_name
    END,
    o.update_by = @operator_id,
    o.update_time = NOW()
WHERE o.deleted = 0;

COMMIT;
