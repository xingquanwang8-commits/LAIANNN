SET NAMES utf8mb4;
START TRANSACTION;

SET @operator_id = COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), 1);

SET @add_column_sql = IF(
    EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = DATABASE()
          AND table_name = 'inventory_task'
          AND column_name = 'principal_user_id'
    ),
    'SELECT 1',
    'ALTER TABLE inventory_task ADD COLUMN principal_user_id BIGINT NULL COMMENT ''负责人用户ID'' AFTER principal_name'
);
PREPARE stmt FROM @add_column_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @create_index_sql = IF(
    EXISTS (
        SELECT 1
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = 'inventory_task'
          AND index_name = 'idx_inventory_task_principal_user_id'
    ),
    'SELECT 1',
    'ALTER TABLE inventory_task ADD INDEX idx_inventory_task_principal_user_id (principal_user_id)'
);
PREPARE stmt FROM @create_index_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

UPDATE inventory_task t
SET t.principal_user_id = COALESCE(
    t.principal_user_id,
    (SELECT u.id
     FROM sys_user u
     WHERE u.real_name = t.principal_name
       AND u.deleted = 0
       AND u.status = 'ENABLED'
     ORDER BY u.id ASC
     LIMIT 1),
    (SELECT u.id
     FROM sys_user u
     WHERE u.nick_name = t.principal_name
       AND u.deleted = 0
       AND u.status = 'ENABLED'
     ORDER BY u.id ASC
     LIMIT 1),
    (SELECT u.id
     FROM sys_user u
     WHERE u.username = t.principal_name
       AND u.deleted = 0
       AND u.status = 'ENABLED'
     ORDER BY u.id ASC
     LIMIT 1)
)
WHERE t.deleted = 0
  AND (t.principal_user_id IS NULL OR t.principal_user_id = 0);

UPDATE inventory_task t
JOIN sys_user u ON u.id = t.create_by
SET t.principal_user_id = u.id
WHERE t.deleted = 0
  AND (t.principal_user_id IS NULL OR t.principal_user_id = 0)
  AND u.deleted = 0
  AND u.status = 'ENABLED'
  AND EXISTS (
      SELECT 1
      FROM sys_user_role ur
      JOIN sys_role r ON r.id = ur.role_id
      WHERE ur.user_id = u.id
        AND ur.deleted = 0
        AND r.deleted = 0
        AND r.role_code IN ('researcher', 'senior_researcher')
  );

UPDATE inventory_task t
JOIN sys_user u ON u.id = t.principal_user_id AND u.deleted = 0
SET t.principal_name = COALESCE(NULLIF(u.real_name, ''), NULLIF(u.nick_name, ''), u.username),
    t.update_by = @operator_id,
    t.update_time = NOW()
WHERE t.deleted = 0
  AND t.principal_user_id IS NOT NULL;

COMMIT;
