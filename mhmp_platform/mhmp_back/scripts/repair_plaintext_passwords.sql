SET NAMES utf8mb4;
START TRANSACTION;

-- 演示环境取消 BCrypt 后，将现有哈希密码统一回写为默认明文密码。
UPDATE sys_user
SET password = '123456'
WHERE deleted = 0
  AND (
    password LIKE '$2a$%'
    OR password LIKE '$2b$%'
    OR password LIKE '$2y$%'
  );

COMMIT;
