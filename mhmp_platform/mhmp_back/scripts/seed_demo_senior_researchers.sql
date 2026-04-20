-- 演示库补充高级研究员账号
SET @operator_id = COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), 1);
SET @seed_researcher_password = COALESCE(
    (SELECT password FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1),
    '123456'
);

INSERT INTO sys_user (
    username, password, nick_name, real_name, phone, email, gender, avatar_url, status,
    last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT
    'senior_researcher02', @seed_researcher_password, '青铜高级研究员', '沈岚', '13988050001', 'senior02@mhmp.local', '女', NULL, 'ENABLED',
    '2026-03-24 09:20:00', '批量生成的 senior_researcher 测试账号，负责青铜与金石类业务审批。', @operator_id, '2026-01-15 09:30:00', @operator_id, '2026-03-24 09:20:00', 0
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM sys_user WHERE username = 'senior_researcher02' AND deleted = 0
);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT
    u.id, r.id, @operator_id, '2026-01-15 09:30:00', @operator_id, '2026-01-15 09:30:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'senior_researcher' AND r.deleted = 0
WHERE u.username = 'senior_researcher02' AND u.deleted = 0
  AND NOT EXISTS (
      SELECT 1 FROM sys_user_role ur
      WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0
  );

INSERT INTO sys_user (
    username, password, nick_name, real_name, phone, email, gender, avatar_url, status,
    last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT
    'senior_researcher03', @seed_researcher_password, '陶瓷高级研究员', '许川', '13988050002', 'senior03@mhmp.local', '男', NULL, 'ENABLED',
    '2026-03-25 10:20:00', '批量生成的 senior_researcher 测试账号，负责陶瓷与出入库业务审批。', @operator_id, '2026-01-16 10:30:00', @operator_id, '2026-03-25 10:20:00', 0
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM sys_user WHERE username = 'senior_researcher03' AND deleted = 0
);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT
    u.id, r.id, @operator_id, '2026-01-16 10:30:00', @operator_id, '2026-01-16 10:30:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'senior_researcher' AND r.deleted = 0
WHERE u.username = 'senior_researcher03' AND u.deleted = 0
  AND NOT EXISTS (
      SELECT 1 FROM sys_user_role ur
      WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0
  );

INSERT INTO sys_user (
    username, password, nick_name, real_name, phone, email, gender, avatar_url, status,
    last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT
    'senior_researcher04', @seed_researcher_password, '书画高级研究员', '顾遥', '13988050003', 'senior04@mhmp.local', '女', NULL, 'ENABLED',
    '2026-03-26 11:20:00', '批量生成的 senior_researcher 测试账号，负责书画修复审批与验收。', @operator_id, '2026-01-17 11:30:00', @operator_id, '2026-03-26 11:20:00', 0
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM sys_user WHERE username = 'senior_researcher04' AND deleted = 0
);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT
    u.id, r.id, @operator_id, '2026-01-17 11:30:00', @operator_id, '2026-01-17 11:30:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'senior_researcher' AND r.deleted = 0
WHERE u.username = 'senior_researcher04' AND u.deleted = 0
  AND NOT EXISTS (
      SELECT 1 FROM sys_user_role ur
      WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0
  );
