SET NAMES utf8mb4;
START TRANSACTION;

CREATE TABLE IF NOT EXISTS `relic_transfer_task` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `task_no` VARCHAR(64) NOT NULL COMMENT '转存任务编号',
    `relic_id` BIGINT NOT NULL COMMENT '文物ID',
    `relic_no` VARCHAR(64) NULL COMMENT '文物编号快照',
    `relic_name` VARCHAR(200) NULL COMMENT '文物名称快照',
    `from_location_code` VARCHAR(64) NOT NULL COMMENT '原库位编码',
    `target_location_code` VARCHAR(64) NOT NULL COMMENT '目标库位编码',
    `task_status` VARCHAR(32) NOT NULL COMMENT '任务状态',
    `assign_user_id` BIGINT NULL COMMENT '派发人用户ID',
    `assign_user_name` VARCHAR(100) NULL COMMENT '派发人名称快照',
    `principal_user_id` BIGINT NOT NULL COMMENT '负责人用户ID',
    `principal_name` VARCHAR(100) NULL COMMENT '负责人名称快照',
    `assign_time` DATETIME NOT NULL COMMENT '派发时间',
    `complete_time` DATETIME NULL COMMENT '完成时间',
    `transfer_reason` VARCHAR(500) NULL COMMENT '转存原因',
    `confirm_remark` VARCHAR(500) NULL COMMENT '确认备注',
    `create_by` BIGINT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` BIGINT NULL COMMENT '更新人',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='馆内转存任务表';

SET @add_confirm_remark_sql = IF(
    EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = DATABASE()
          AND table_name = 'relic_transfer_task'
          AND column_name = 'confirm_remark'
    ),
    'SELECT 1',
    'ALTER TABLE relic_transfer_task ADD COLUMN confirm_remark VARCHAR(500) NULL COMMENT ''确认备注'' AFTER transfer_reason'
);
PREPARE stmt FROM @add_confirm_remark_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @drop_confirm_image_name_sql = IF(
    EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = DATABASE()
          AND table_name = 'relic_transfer_task'
          AND column_name = 'confirm_image_name'
    ),
    'ALTER TABLE relic_transfer_task DROP COLUMN confirm_image_name',
    'SELECT 1'
);
PREPARE stmt FROM @drop_confirm_image_name_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @drop_confirm_image_url_sql = IF(
    EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = DATABASE()
          AND table_name = 'relic_transfer_task'
          AND column_name = 'confirm_image_url'
    ),
    'ALTER TABLE relic_transfer_task DROP COLUMN confirm_image_url',
    'SELECT 1'
);
PREPARE stmt FROM @drop_confirm_image_url_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @create_task_no_index_sql = IF(
    EXISTS (
        SELECT 1
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = 'relic_transfer_task'
          AND index_name = 'uk_relic_transfer_task_task_no'
    ),
    'SELECT 1',
    'ALTER TABLE relic_transfer_task ADD UNIQUE INDEX uk_relic_transfer_task_task_no (task_no)'
);
PREPARE stmt FROM @create_task_no_index_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @create_relic_index_sql = IF(
    EXISTS (
        SELECT 1
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = 'relic_transfer_task'
          AND index_name = 'idx_relic_transfer_task_relic_id'
    ),
    'SELECT 1',
    'ALTER TABLE relic_transfer_task ADD INDEX idx_relic_transfer_task_relic_id (relic_id)'
);
PREPARE stmt FROM @create_relic_index_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @create_principal_index_sql = IF(
    EXISTS (
        SELECT 1
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = 'relic_transfer_task'
          AND index_name = 'idx_relic_transfer_task_principal_user_id'
    ),
    'SELECT 1',
    'ALTER TABLE relic_transfer_task ADD INDEX idx_relic_transfer_task_principal_user_id (principal_user_id)'
);
PREPARE stmt FROM @create_principal_index_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @create_status_index_sql = IF(
    EXISTS (
        SELECT 1
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = 'relic_transfer_task'
          AND index_name = 'idx_relic_transfer_task_status'
    ),
    'SELECT 1',
    'ALTER TABLE relic_transfer_task ADD INDEX idx_relic_transfer_task_status (task_status)'
);
PREPARE stmt FROM @create_status_index_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @create_assign_time_index_sql = IF(
    EXISTS (
        SELECT 1
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = 'relic_transfer_task'
          AND index_name = 'idx_relic_transfer_task_assign_time'
    ),
    'SELECT 1',
    'ALTER TABLE relic_transfer_task ADD INDEX idx_relic_transfer_task_assign_time (assign_time)'
);
PREPARE stmt FROM @create_assign_time_index_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

COMMIT;
