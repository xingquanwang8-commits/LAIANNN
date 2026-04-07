-- 博物馆文物综合管理平台批量测试数据 SQL
-- 生成时间: 2026-04-08
-- 导入方式: 使用 Navicat 打开本文件后直接执行

SET NAMES utf8mb4;
START TRANSACTION;
SET @seed_admin_hash = COALESCE((SELECT password FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), '$2y$10$CHHfXNbJcqtXHp32oZjtVuRzV33SygS0Fk2WAENwh3oma0vlfW5om');
SET @seed_researcher_hash = COALESCE((SELECT password FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), '$2y$10$3zq.H2DXJWc5OwLT7wApWeXx2zaWizO3M/49Bt5eHgGF8RSnsjIv.');
SET @seed_docent_hash = COALESCE((SELECT password FROM sys_user WHERE username = 'docent' AND deleted = 0 LIMIT 1), '$2y$10$MjM/t.BlshSizvSU2lq48OkA1y/1IFnZP2HPBGjnh7bB2MN3LieQ6');
SET @seed_admin_id = COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), 1);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'admin02', @seed_admin_hash, '馆务平台主管', '赵楠', '13988020001', 'admin02@mhmp.local', '女',
  NULL, 'ENABLED', '2026-03-19 08:20:00', '批量生成的admin测试账号。分管馆务统筹与跨部门协同。', @seed_admin_id, '2026-01-08 10:15:00', @seed_admin_id, '2026-03-19 08:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'admin02' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-08 10:15:00', @seed_admin_id, '2026-01-08 10:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'admin' AND r.deleted = 0
WHERE u.username = 'admin02' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'admin03', @seed_admin_hash, '藏品安全主管', '陈昊', '13988020002', 'admin03@mhmp.local', '男',
  NULL, 'ENABLED', '2026-03-20 09:20:00', '批量生成的admin测试账号。分管安全巡检、库房调度与外借审核。', @seed_admin_id, '2026-01-09 11:15:00', @seed_admin_id, '2026-03-20 09:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'admin03' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-09 11:15:00', @seed_admin_id, '2026-01-09 11:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'admin' AND r.deleted = 0
WHERE u.username = 'admin03' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'admin04', @seed_admin_hash, '系统运维主管', '许薇', '13988020003', 'admin04@mhmp.local', '女',
  NULL, 'ENABLED', '2026-03-21 10:20:00', '批量生成的admin测试账号。负责系统巡检、账号协同与异常处理。', @seed_admin_id, '2026-01-10 12:15:00', @seed_admin_id, '2026-03-21 10:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'admin04' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-10 12:15:00', @seed_admin_id, '2026-01-10 12:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'admin' AND r.deleted = 0
WHERE u.username = 'admin04' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'admin05', @seed_admin_hash, '业务协同主管', '刘舟', '13988020004', 'admin05@mhmp.local', '男',
  NULL, 'ENABLED', '2026-03-22 08:20:00', '批量生成的admin测试账号。负责流程复核、馆际交流与台账抽查。', @seed_admin_id, '2026-01-11 13:15:00', @seed_admin_id, '2026-03-22 08:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'admin05' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-11 13:15:00', @seed_admin_id, '2026-01-11 13:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'admin' AND r.deleted = 0
WHERE u.username = 'admin05' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'researcher02', @seed_researcher_hash, '青铜研究员', '王蕾', '13988030001', 'researcher02@mhmp.local', '女',
  NULL, 'ENABLED', '2026-03-23 09:20:00', '批量生成的researcher测试账号。负责青铜器建档与病害研判。', @seed_admin_id, '2026-01-12 10:15:00', @seed_admin_id, '2026-03-23 09:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'researcher02' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-12 10:15:00', @seed_admin_id, '2026-01-12 10:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'researcher' AND r.deleted = 0
WHERE u.username = 'researcher02' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'researcher03', @seed_researcher_hash, '陶瓷研究员', '周洋', '13988030002', 'researcher03@mhmp.local', '男',
  NULL, 'ENABLED', '2026-03-24 10:20:00', '批量生成的researcher测试账号。负责陶瓷器分类与外借复核。', @seed_admin_id, '2026-01-13 11:15:00', @seed_admin_id, '2026-03-24 10:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'researcher03' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-13 11:15:00', @seed_admin_id, '2026-01-13 11:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'researcher' AND r.deleted = 0
WHERE u.username = 'researcher03' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'researcher04', @seed_researcher_hash, '书画研究员', '林清', '13988030003', 'researcher04@mhmp.local', '女',
  NULL, 'ENABLED', '2026-03-25 08:20:00', '批量生成的researcher测试账号。负责书画类文物建档与修复申请。', @seed_admin_id, '2026-01-14 12:15:00', @seed_admin_id, '2026-03-25 08:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'researcher04' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-14 12:15:00', @seed_admin_id, '2026-01-14 12:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'researcher' AND r.deleted = 0
WHERE u.username = 'researcher04' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'researcher05', @seed_researcher_hash, '玉器研究员', '何远', '13988030004', 'researcher05@mhmp.local', '男',
  NULL, 'ENABLED', '2026-03-19 09:20:00', '批量生成的researcher测试账号。负责玉器状态评估与调拨复核。', @seed_admin_id, '2026-01-15 13:15:00', @seed_admin_id, '2026-03-19 09:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'researcher05' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-15 13:15:00', @seed_admin_id, '2026-01-15 13:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'researcher' AND r.deleted = 0
WHERE u.username = 'researcher05' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'researcher06', @seed_researcher_hash, '金银器研究员', '苏瑶', '13988030005', 'researcher06@mhmp.local', '女',
  NULL, 'ENABLED', '2026-03-20 10:20:00', '批量生成的researcher测试账号。负责金银器病害观察与展陈准备。', @seed_admin_id, '2026-01-16 10:15:00', @seed_admin_id, '2026-03-20 10:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'researcher06' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-16 10:15:00', @seed_admin_id, '2026-01-16 10:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'researcher' AND r.deleted = 0
WHERE u.username = 'researcher06' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'researcher07', @seed_researcher_hash, '木器研究员', '郑川', '13988030006', 'researcher07@mhmp.local', '男',
  NULL, 'ENABLED', '2026-03-21 08:20:00', '批量生成的researcher测试账号。负责木器与竹木器类建档复核。', @seed_admin_id, '2026-01-17 11:15:00', @seed_admin_id, '2026-03-21 08:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'researcher07' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-17 11:15:00', @seed_admin_id, '2026-01-17 11:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'researcher' AND r.deleted = 0
WHERE u.username = 'researcher07' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'researcher08', @seed_researcher_hash, '漆器研究员', '宋宁', '13988030007', 'researcher08@mhmp.local', '女',
  NULL, 'ENABLED', '2026-03-22 09:20:00', '批量生成的researcher测试账号。负责漆器病害复核与修复跟踪。', @seed_admin_id, '2026-01-18 12:15:00', @seed_admin_id, '2026-03-22 09:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'researcher08' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-18 12:15:00', @seed_admin_id, '2026-01-18 12:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'researcher' AND r.deleted = 0
WHERE u.username = 'researcher08' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'researcher09', @seed_researcher_hash, '石刻研究员', '魏安', '13988030008', 'researcher09@mhmp.local', '男',
  NULL, 'ENABLED', '2026-03-23 10:20:00', '批量生成的researcher测试账号。负责石刻与造像类文物台账整理。', @seed_admin_id, '2026-01-19 13:15:00', @seed_admin_id, '2026-03-23 10:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'researcher09' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-19 13:15:00', @seed_admin_id, '2026-01-19 13:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'researcher' AND r.deleted = 0
WHERE u.username = 'researcher09' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'researcher10', @seed_researcher_hash, '保管研究员', '唐蕾', '13988030009', 'researcher10@mhmp.local', '女',
  NULL, 'ENABLED', '2026-03-24 08:20:00', '批量生成的researcher测试账号。负责库位复核与盘点任务执行。', @seed_admin_id, '2026-01-20 10:15:00', @seed_admin_id, '2026-03-24 08:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'researcher10' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-20 10:15:00', @seed_admin_id, '2026-01-20 10:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'researcher' AND r.deleted = 0
WHERE u.username = 'researcher10' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'researcher11', @seed_researcher_hash, '修复研究员', '韩卓', '13988030010', 'researcher11@mhmp.local', '男',
  NULL, 'ENABLED', '2026-03-25 09:20:00', '批量生成的researcher测试账号。负责修复方案编制与工序记录。', @seed_admin_id, '2026-01-21 11:15:00', @seed_admin_id, '2026-03-25 09:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'researcher11' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-21 11:15:00', @seed_admin_id, '2026-01-21 11:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'researcher' AND r.deleted = 0
WHERE u.username = 'researcher11' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'researcher12', @seed_researcher_hash, '陈列研究员', '顾琳', '13988030011', 'researcher12@mhmp.local', '女',
  NULL, 'ENABLED', '2026-03-19 10:20:00', '批量生成的researcher测试账号。负责展陈借展与回库复核。', @seed_admin_id, '2026-01-22 12:15:00', @seed_admin_id, '2026-03-19 10:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'researcher12' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-22 12:15:00', @seed_admin_id, '2026-01-22 12:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'researcher' AND r.deleted = 0
WHERE u.username = 'researcher12' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'researcher13', @seed_researcher_hash, '档案研究员', '罗宁', '13988030012', 'researcher13@mhmp.local', '男',
  NULL, 'ENABLED', '2026-03-20 08:20:00', '批量生成的researcher测试账号。负责档案补录与附件整理。', @seed_admin_id, '2026-01-23 13:15:00', @seed_admin_id, '2026-03-20 08:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'researcher13' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-23 13:15:00', @seed_admin_id, '2026-01-23 13:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'researcher' AND r.deleted = 0
WHERE u.username = 'researcher13' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'researcher14', @seed_researcher_hash, '馆藏研究员', '姚菲', '13988030013', 'researcher14@mhmp.local', '女',
  NULL, 'ENABLED', '2026-03-21 09:20:00', '批量生成的researcher测试账号。负责综合建档与业务联调。', @seed_admin_id, '2026-01-24 10:15:00', @seed_admin_id, '2026-03-21 09:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'researcher14' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-24 10:15:00', @seed_admin_id, '2026-01-24 10:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'researcher' AND r.deleted = 0
WHERE u.username = 'researcher14' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'docent02', @seed_docent_hash, '资深讲解员', '王倩', '13988040001', 'docent02@mhmp.local', '女',
  NULL, 'ENABLED', '2026-03-22 10:20:00', '批量生成的docent测试账号。负责固定陈列讲解与公众咨询。', @seed_admin_id, '2026-01-25 11:15:00', @seed_admin_id, '2026-03-22 10:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'docent02' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-25 11:15:00', @seed_admin_id, '2026-01-25 11:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'docent' AND r.deleted = 0
WHERE u.username = 'docent02' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'docent03', @seed_docent_hash, '展厅讲解员', '沈越', '13988040002', 'docent03@mhmp.local', '男',
  NULL, 'ENABLED', '2026-03-23 08:20:00', '批量生成的docent测试账号。负责青铜与陶瓷展区讲解。', @seed_admin_id, '2026-01-26 12:15:00', @seed_admin_id, '2026-03-23 08:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'docent03' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-26 12:15:00', @seed_admin_id, '2026-01-26 12:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'docent' AND r.deleted = 0
WHERE u.username = 'docent03' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'docent04', @seed_docent_hash, '社教专员', '夏妍', '13988040003', 'docent04@mhmp.local', '女',
  NULL, 'ENABLED', '2026-03-24 09:20:00', '批量生成的docent测试账号。负责公众教育与活动协助。', @seed_admin_id, '2026-01-27 13:15:00', @seed_admin_id, '2026-03-24 09:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'docent04' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-27 13:15:00', @seed_admin_id, '2026-01-27 13:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'docent' AND r.deleted = 0
WHERE u.username = 'docent04' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'docent05', @seed_docent_hash, '临展讲解员', '蒋晨', '13988040004', 'docent05@mhmp.local', '男',
  NULL, 'ENABLED', '2026-03-25 10:20:00', '批量生成的docent测试账号。负责临展接待与借展辅助。', @seed_admin_id, '2026-01-28 10:15:00', @seed_admin_id, '2026-03-25 10:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'docent05' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-28 10:15:00', @seed_admin_id, '2026-01-28 10:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'docent' AND r.deleted = 0
WHERE u.username = 'docent05' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'docent06', @seed_docent_hash, '讲解助理', '傅泽', '13988040005', 'docent06@mhmp.local', '男',
  NULL, 'ENABLED', '2026-03-19 08:20:00', '批量生成的docent测试账号。负责讲解排班与参观导引。', @seed_admin_id, '2026-01-29 11:15:00', @seed_admin_id, '2026-03-19 08:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'docent06' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-29 11:15:00', @seed_admin_id, '2026-01-29 11:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'docent' AND r.deleted = 0
WHERE u.username = 'docent06' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'docent07', @seed_docent_hash, '公众服务专员', '梁悦', '13988040006', 'docent07@mhmp.local', '女',
  NULL, 'ENABLED', '2026-03-20 09:20:00', '批量生成的docent测试账号。负责展厅秩序与观众问询。', @seed_admin_id, '2026-01-30 12:15:00', @seed_admin_id, '2026-03-20 09:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'docent07' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-30 12:15:00', @seed_admin_id, '2026-01-30 12:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'docent' AND r.deleted = 0
WHERE u.username = 'docent07' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'docent08', @seed_docent_hash, '展陈讲解员', '高杉', '13988040007', 'docent08@mhmp.local', '男',
  NULL, 'ENABLED', '2026-03-21 10:20:00', '批量生成的docent测试账号。负责专题展讲解与观众接待。', @seed_admin_id, '2026-01-31 13:15:00', @seed_admin_id, '2026-03-21 10:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'docent08' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-01-31 13:15:00', @seed_admin_id, '2026-01-31 13:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'docent' AND r.deleted = 0
WHERE u.username = 'docent08' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'docent09', @seed_docent_hash, '社教讲解员', '袁青', '13988040008', 'docent09@mhmp.local', '女',
  NULL, 'ENABLED', '2026-03-22 08:20:00', '批量生成的docent测试账号。负责馆校合作讲解服务。', @seed_admin_id, '2026-02-01 10:15:00', @seed_admin_id, '2026-03-22 08:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'docent09' AND deleted = 0);

INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, '2026-02-01 10:15:00', @seed_admin_id, '2026-02-01 10:15:00', 0
FROM sys_user u
JOIN sys_role r ON r.role_code = 'docent' AND r.deleted = 0
WHERE u.username = 'docent09' AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0001', '春秋错金银壶', 'BRONZE_WARE', 'BRONZE', '春秋', '旧藏整理',
  'STORAGE_ROOM_3', 'INCOMPLETE', 'IN_STOCK', '二级', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-09 10:07:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-09 11:37:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0001' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '春秋错金银壶-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-07-09 12:07:00', @seed_admin_id, '2024-07-09 12:07:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0001' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '春秋错金银壶-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '春秋错金银壶-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-07-09 12:12:00', @seed_admin_id, '2024-07-09 12:12:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0001' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '春秋错金银壶-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '春秋错金银壶-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-07-09 12:17:00', @seed_admin_id, '2024-07-09 12:17:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0001' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '春秋错金银壶-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0002', '明代印花罐', 'CERAMIC', 'CLAY', '明代', '征集购藏',
  'LOC_B', 'INCOMPLETE', 'IN_STOCK', '一般', '低震动环境保存，配合缓冲支撑，防止胎体继续开裂。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-11 11:14:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-11 12:44:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0002' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代印花罐-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-07-11 13:14:00', @seed_admin_id, '2024-07-11 13:14:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0002' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代印花罐-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代印花罐-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-07-11 13:19:00', @seed_admin_id, '2024-07-11 13:19:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0002' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代印花罐-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0003', '明代楷书扇面', 'PAINTING_CALLIGRAPHY', 'SILK', '明代', '旧藏移交',
  'LOC_C', 'INCOMPLETE', 'IN_STOCK', '二级', '平铺或悬挂缓释支撑，避光防尘，控制湿度波动。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-13 12:21:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-13 13:51:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0003' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代楷书扇面-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-07-13 14:21:00', @seed_admin_id, '2024-07-13 14:21:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0003' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代楷书扇面-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代楷书扇面-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-07-13 14:26:00', @seed_admin_id, '2024-07-13 14:26:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0003' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代楷书扇面-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0004', '汉代谷纹玉圭', 'JADE_ARTIFACT', 'JADE', '汉代', '考古发掘入藏',
  'LOC_B', 'COMPLETE', 'IN_STOCK', '二级', '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-15 13:28:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-15 14:58:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0004' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '汉代谷纹玉圭-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-07-15 15:28:00', @seed_admin_id, '2024-07-15 15:28:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0004' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '汉代谷纹玉圭-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '汉代谷纹玉圭-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-07-15 15:33:00', @seed_admin_id, '2024-07-15 15:33:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0004' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '汉代谷纹玉圭-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '汉代谷纹玉圭-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-07-15 15:38:00', @seed_admin_id, '2024-07-15 15:38:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0004' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '汉代谷纹玉圭-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0005', '唐代累丝带扣', 'GOLD_SILVER_WARE', 'SILVER', '唐代', '社会捐赠',
  'LOC_A', 'COMPLETE', 'IN_STOCK', '一级', '干燥密闭保存，配合防氧化材料，减少表面发黑。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-17 14:35:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-17 16:05:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0005' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '唐代累丝带扣-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-07-17 16:35:00', @seed_admin_id, '2024-07-17 16:35:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0005' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '唐代累丝带扣-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '唐代累丝带扣-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-07-17 16:40:00', @seed_admin_id, '2024-07-17 16:40:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0005' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '唐代累丝带扣-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0006', '清代楠木透雕屏风', 'WOOD', 'BAMBOO_WOOD', '清代', '社会捐赠',
  'LOC_VIP', 'INCOMPLETE', 'IN_STOCK', '一般', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-19 15:42:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-19 17:12:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0006' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代楠木透雕屏风-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-07-19 17:42:00', @seed_admin_id, '2024-07-19 17:42:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0006' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代楠木透雕屏风-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代楠木透雕屏风-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-07-19 17:47:00', @seed_admin_id, '2024-07-19 17:47:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0006' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代楠木透雕屏风-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0007', '明代戗金漆壶', 'LACQUER', 'LACQUER_WOOD', '明代', '社会捐赠',
  'EXHIBIT_HALL_2', 'BASIC_COMPLETE', 'IN_STOCK', '一级', '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-21 09:49:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-21 11:19:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0007' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代戗金漆壶-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-07-21 11:49:00', @seed_admin_id, '2024-07-21 11:49:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0007' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代戗金漆壶-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代戗金漆壶-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-07-21 11:54:00', @seed_admin_id, '2024-07-21 11:54:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0007' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代戗金漆壶-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '明代戗金漆壶-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-07-21 11:59:00', @seed_admin_id, '2024-07-21 11:59:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0007' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '明代戗金漆壶-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0008', '北齐莲花座立像', 'STONE', 'STONE', '北齐', '馆际移交',
  'EXHIBIT_HALL_2', 'COMPLETE', 'IN_STOCK', '三级', '独立底座承托，控制展柜粉尘和局部潮气。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-23 10:56:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-23 12:26:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0008' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '北齐莲花座立像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-07-23 12:56:00', @seed_admin_id, '2024-07-23 12:56:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0008' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '北齐莲花座立像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '北齐莲花座立像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-07-23 13:01:00', @seed_admin_id, '2024-07-23 13:01:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0008' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '北齐莲花座立像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0009', '宋代墨书册页', 'BAMBOO', 'BAMBOO_WOOD', '宋代', '馆际征集',
  'LOC_VIP', 'COMPLETE', 'IN_STOCK', '二级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-25 11:03:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-25 12:33:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0009' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '宋代墨书册页-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-07-25 13:03:00', @seed_admin_id, '2024-07-25 13:03:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0009' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '宋代墨书册页-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '宋代墨书册页-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-07-25 13:08:00', @seed_admin_id, '2024-07-25 13:08:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0009' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '宋代墨书册页-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0010', '汉代云雷纹镜', 'BRONZE_WARE', 'BRONZE', '汉代', '考古发掘入藏',
  'LOC_A', 'BASIC_COMPLETE', 'IN_STOCK', '三级', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-27 12:10:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-27 13:40:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0010' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '汉代云雷纹镜-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-07-27 14:10:00', @seed_admin_id, '2024-07-27 14:10:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0010' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '汉代云雷纹镜-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '汉代云雷纹镜-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-07-27 14:15:00', @seed_admin_id, '2024-07-27 14:15:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0010' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '汉代云雷纹镜-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '汉代云雷纹镜-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-07-27 14:20:00', @seed_admin_id, '2024-07-27 14:20:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0010' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '汉代云雷纹镜-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0011', '民国粉彩梅瓶', 'CERAMIC', 'PORCELAIN', '民国', '社会捐赠',
  'LOC_VIP', 'COMPLETE', 'IN_STOCK', '一般', '防震托架单件存放，避免温差突变与硬物碰撞。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-29 13:17:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-29 14:47:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0011' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '民国粉彩梅瓶-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-07-29 15:17:00', @seed_admin_id, '2024-07-29 15:17:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0011' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '民国粉彩梅瓶-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '民国粉彩梅瓶-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-07-29 15:22:00', @seed_admin_id, '2024-07-29 15:22:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0011' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '民国粉彩梅瓶-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0012', '清代花鸟手卷', 'PAINTING_CALLIGRAPHY', 'SILK', '清代', '社会捐赠',
  'EXHIBIT_HALL_1', 'COMPLETE', 'IN_STOCK', '三级', '平铺或悬挂缓释支撑，避光防尘，控制湿度波动。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-31 14:24:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-31 15:54:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0012' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代花鸟手卷-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-07-31 16:24:00', @seed_admin_id, '2024-07-31 16:24:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0012' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代花鸟手卷-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代花鸟手卷-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-07-31 16:29:00', @seed_admin_id, '2024-07-31 16:29:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0012' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代花鸟手卷-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0013', '战国谷纹玉璧', 'JADE_ARTIFACT', 'JADE', '战国', '考古发掘入藏',
  'EXHIBIT_HALL_2', 'BASIC_COMPLETE', 'IN_STOCK', '三级', '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-02 15:31:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-02 17:01:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0013' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '战国谷纹玉璧-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-08-02 17:31:00', @seed_admin_id, '2024-08-02 17:31:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0013' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '战国谷纹玉璧-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '战国谷纹玉璧-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-08-02 17:36:00', @seed_admin_id, '2024-08-02 17:36:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0013' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '战国谷纹玉璧-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '战国谷纹玉璧-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-08-02 17:41:00', @seed_admin_id, '2024-08-02 17:41:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0013' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '战国谷纹玉璧-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0014', '唐代錾刻带扣', 'GOLD_SILVER_WARE', 'SILVER', '唐代', '旧藏整理',
  'EXHIBIT_HALL_1', 'INCOMPLETE', 'IN_STOCK', '二级', '干燥密闭保存，配合防氧化材料，减少表面发黑。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-04 09:38:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-04 11:08:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0014' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '唐代錾刻带扣-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-08-04 11:38:00', @seed_admin_id, '2024-08-04 11:38:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0014' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '唐代錾刻带扣-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '唐代錾刻带扣-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-08-04 11:43:00', @seed_admin_id, '2024-08-04 11:43:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0014' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '唐代錾刻带扣-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0015', '民国柏木髹漆供案', 'WOOD', 'WOOD', '民国', '寺院征集',
  'EXHIBIT_HALL_2', 'BASIC_COMPLETE', 'IN_STOCK', '三级', '恒温恒湿环境保存，避免直射光和虫蛀滋生。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-06 10:45:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-06 12:15:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0015' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '民国柏木髹漆供案-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-08-06 12:45:00', @seed_admin_id, '2024-08-06 12:45:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0015' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '民国柏木髹漆供案-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '民国柏木髹漆供案-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-08-06 12:50:00', @seed_admin_id, '2024-08-06 12:50:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0015' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '民国柏木髹漆供案-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0016', '明代朱漆漆奁', 'LACQUER', 'LACQUER_WOOD', '明代', '旧藏移交',
  'STORAGE_ROOM_3', 'BASIC_COMPLETE', 'IN_STOCK', '一级', '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-08 11:52:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-08 13:22:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0016' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代朱漆漆奁-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-08-08 13:52:00', @seed_admin_id, '2024-08-08 13:52:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0016' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代朱漆漆奁-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代朱漆漆奁-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-08-08 13:57:00', @seed_admin_id, '2024-08-08 13:57:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0016' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代朱漆漆奁-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '明代朱漆漆奁-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-08-08 14:02:00', @seed_admin_id, '2024-08-08 14:02:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0016' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '明代朱漆漆奁-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0017', '宋代经幢供养人像', 'STONE', 'STONE', '宋代', '馆际移交',
  'EXHIBIT_HALL_1', 'BASIC_COMPLETE', 'IN_STOCK', '三级', '独立底座承托，控制展柜粉尘和局部潮气。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-10 12:59:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-10 14:29:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0017' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '宋代经幢供养人像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-08-10 14:59:00', @seed_admin_id, '2024-08-10 14:59:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0017' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '宋代经幢供养人像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '宋代经幢供养人像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-08-10 15:04:00', @seed_admin_id, '2024-08-10 15:04:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0017' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '宋代经幢供养人像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0018', '汉代题记册页', 'BAMBOO', 'BAMBOO_WOOD', '汉代', '馆际征集',
  'LOC_A', 'BASIC_COMPLETE', 'IN_STOCK', '一级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-12 13:06:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-12 14:36:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0018' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '汉代题记册页-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-08-12 15:06:00', @seed_admin_id, '2024-08-12 15:06:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0018' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '汉代题记册页-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '汉代题记册页-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-08-12 15:11:00', @seed_admin_id, '2024-08-12 15:11:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0018' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '汉代题记册页-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0019', '战国蟠螭纹镜', 'BRONZE_WARE', 'BRONZE', '战国', '馆际征集',
  'EXHIBIT_HALL_1', 'INCOMPLETE', 'IN_STOCK', '二级', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-14 14:13:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-14 15:43:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0019' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '战国蟠螭纹镜-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-08-14 16:13:00', @seed_admin_id, '2024-08-14 16:13:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0019' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '战国蟠螭纹镜-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '战国蟠螭纹镜-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-08-14 16:18:00', @seed_admin_id, '2024-08-14 16:18:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0019' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '战国蟠螭纹镜-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '战国蟠螭纹镜-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-08-14 16:23:00', @seed_admin_id, '2024-08-14 16:23:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0019' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '战国蟠螭纹镜-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0020', '宋代刻花盘', 'CERAMIC', 'CLAY', '宋代', '社会捐赠',
  'LOC_VIP', 'INCOMPLETE', 'IN_STOCK', '一般', '低震动环境保存，配合缓冲支撑，防止胎体继续开裂。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-16 15:20:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-16 16:50:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0020' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '宋代刻花盘-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-08-16 17:20:00', @seed_admin_id, '2024-08-16 17:20:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0020' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '宋代刻花盘-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '宋代刻花盘-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-08-16 17:25:00', @seed_admin_id, '2024-08-16 17:25:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0020' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '宋代刻花盘-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0021', '清代楷书立轴', 'PAINTING_CALLIGRAPHY', 'PAPER', '清代', '社会捐赠',
  'EXHIBIT_HALL_1', 'INCOMPLETE', 'IN_STOCK', '一级', '避光平放，温度18至20度，相对湿度50%至55%，减少酸化风险。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-18 09:27:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-18 10:57:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0021' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代楷书立轴-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-08-18 11:27:00', @seed_admin_id, '2024-08-18 11:27:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0021' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代楷书立轴-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代楷书立轴-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-08-18 11:32:00', @seed_admin_id, '2024-08-18 11:32:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0021' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代楷书立轴-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0022', '商代素面带钩', 'JADE_ARTIFACT', 'JADE', '商代', '馆际调拨',
  'LOC_A', 'COMPLETE', 'IN_STOCK', '二级', '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-20 10:34:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-20 12:04:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0022' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '商代素面带钩-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-08-20 12:34:00', @seed_admin_id, '2024-08-20 12:34:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0022' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '商代素面带钩-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '商代素面带钩-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-08-20 12:39:00', @seed_admin_id, '2024-08-20 12:39:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0022' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '商代素面带钩-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '商代素面带钩-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-08-20 12:44:00', @seed_admin_id, '2024-08-20 12:44:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0022' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '商代素面带钩-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0023', '清代掐丝冠饰', 'GOLD_SILVER_WARE', 'GOLD', '清代', '馆际征集',
  'LOC_B', 'INCOMPLETE', 'IN_STOCK', '三级', '恒温低湿保存，避免与含硫物质长期接触。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-22 11:41:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-22 13:11:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0023' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代掐丝冠饰-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-08-22 13:41:00', @seed_admin_id, '2024-08-22 13:41:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0023' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代掐丝冠饰-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代掐丝冠饰-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-08-22 13:46:00', @seed_admin_id, '2024-08-22 13:46:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0023' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代掐丝冠饰-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0024', '清代柏木髹漆香几', 'WOOD', 'WOOD', '清代', '寺院征集',
  'LOC_B', 'BASIC_COMPLETE', 'IN_STOCK', '一般', '恒温恒湿环境保存，避免直射光和虫蛀滋生。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-24 12:48:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-24 14:18:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0024' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代柏木髹漆香几-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-08-24 14:48:00', @seed_admin_id, '2024-08-24 14:48:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0024' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代柏木髹漆香几-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代柏木髹漆香几-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-08-24 14:53:00', @seed_admin_id, '2024-08-24 14:53:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0024' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代柏木髹漆香几-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0025', '汉代描金漆盘', 'LACQUER', 'LACQUER_WOOD', '汉代', '社会捐赠',
  'LOC_A', 'BASIC_COMPLETE', 'IN_STOCK', '三级', '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-26 13:55:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-26 15:25:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0025' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '汉代描金漆盘-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-08-26 15:55:00', @seed_admin_id, '2024-08-26 15:55:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0025' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '汉代描金漆盘-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '汉代描金漆盘-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-08-26 16:00:00', @seed_admin_id, '2024-08-26 16:00:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0025' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '汉代描金漆盘-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '汉代描金漆盘-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-08-26 16:05:00', @seed_admin_id, '2024-08-26 16:05:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0025' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '汉代描金漆盘-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0026', '北魏经幢供养人像', 'STONE', 'STONE', '北魏', '寺院征集',
  'STORAGE_ROOM_3', 'BASIC_COMPLETE', 'IN_STOCK', '一级', '独立底座承托，控制展柜粉尘和局部潮气。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-28 14:02:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-28 15:32:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0026' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '北魏经幢供养人像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-08-28 16:02:00', @seed_admin_id, '2024-08-28 16:02:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0026' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '北魏经幢供养人像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '北魏经幢供养人像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-08-28 16:07:00', @seed_admin_id, '2024-08-28 16:07:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0026' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '北魏经幢供养人像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0027', '宋代编联卷册', 'BAMBOO', 'BAMBOO_WOOD', '宋代', '学术移交',
  'EXHIBIT_HALL_1', 'COMPLETE', 'IN_STOCK', '二级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-30 15:09:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-30 16:39:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0027' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '宋代编联卷册-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-08-30 17:09:00', @seed_admin_id, '2024-08-30 17:09:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0027' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '宋代编联卷册-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '宋代编联卷册-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-08-30 17:14:00', @seed_admin_id, '2024-08-30 17:14:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0027' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '宋代编联卷册-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0028', '西周兽面纹簋', 'BRONZE_WARE', 'BRONZE', '西周', '考古发掘入藏',
  'EXHIBIT_HALL_1', 'INCOMPLETE', 'IN_STOCK', '三级', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-01 09:16:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-01 10:46:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0028' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '西周兽面纹簋-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-09-01 11:16:00', @seed_admin_id, '2024-09-01 11:16:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0028' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '西周兽面纹簋-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '西周兽面纹簋-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-09-01 11:21:00', @seed_admin_id, '2024-09-01 11:21:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0028' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '西周兽面纹簋-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '西周兽面纹簋-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-09-01 11:26:00', @seed_admin_id, '2024-09-01 11:26:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0028' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '西周兽面纹簋-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0029', '清代影青碗', 'CERAMIC', 'CLAY', '清代', '征集购藏',
  'STORAGE_ROOM_3', 'INCOMPLETE', 'IN_STOCK', '一般', '低震动环境保存，配合缓冲支撑，防止胎体继续开裂。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-03 10:23:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-03 11:53:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0029' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代影青碗-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-09-03 12:23:00', @seed_admin_id, '2024-09-03 12:23:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0029' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代影青碗-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代影青碗-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-09-03 12:28:00', @seed_admin_id, '2024-09-03 12:28:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0029' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代影青碗-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0030', '明代花鸟扇面', 'PAINTING_CALLIGRAPHY', 'PAPER', '明代', '社会捐赠',
  'EXHIBIT_HALL_2', 'BASIC_COMPLETE', 'IN_STOCK', '一般', '避光平放，温度18至20度，相对湿度50%至55%，减少酸化风险。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-05 11:30:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-05 13:00:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0030' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代花鸟扇面-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-09-05 13:30:00', @seed_admin_id, '2024-09-05 13:30:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0030' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代花鸟扇面-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代花鸟扇面-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-09-05 13:35:00', @seed_admin_id, '2024-09-05 13:35:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0030' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代花鸟扇面-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0031', '战国素面带钩', 'JADE_ARTIFACT', 'JADE', '战国', '考古发掘入藏',
  'LOC_VIP', 'COMPLETE', 'IN_STOCK', '一般', '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-07 12:37:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-07 14:07:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0031' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '战国素面带钩-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-09-07 14:37:00', @seed_admin_id, '2024-09-07 14:37:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0031' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '战国素面带钩-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '战国素面带钩-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-09-07 14:42:00', @seed_admin_id, '2024-09-07 14:42:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0031' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '战国素面带钩-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '战国素面带钩-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-09-07 14:47:00', @seed_admin_id, '2024-09-07 14:47:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0031' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '战国素面带钩-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0032', '清代錾刻冠饰', 'GOLD_SILVER_WARE', 'SILVER', '清代', '旧藏整理',
  'EXHIBIT_HALL_2', 'BASIC_COMPLETE', 'IN_STOCK', '二级', '干燥密闭保存，配合防氧化材料，减少表面发黑。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-09 13:44:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-09 15:14:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0032' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代錾刻冠饰-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-09-09 15:44:00', @seed_admin_id, '2024-09-09 15:44:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0032' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代錾刻冠饰-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代錾刻冠饰-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-09-09 15:49:00', @seed_admin_id, '2024-09-09 15:49:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0032' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代錾刻冠饰-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0033', '民国楠木透雕佛像', 'WOOD', 'WOOD', '民国', '馆际调拨',
  'EXHIBIT_HALL_2', 'BASIC_COMPLETE', 'IN_STOCK', '一般', '恒温恒湿环境保存，避免直射光和虫蛀滋生。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-11 14:51:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-11 16:21:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0033' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '民国楠木透雕佛像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-09-11 16:51:00', @seed_admin_id, '2024-09-11 16:51:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0033' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '民国楠木透雕佛像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '民国楠木透雕佛像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-09-11 16:56:00', @seed_admin_id, '2024-09-11 16:56:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0033' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '民国楠木透雕佛像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0034', '民国描金漆壶', 'LACQUER', 'LACQUER_WOOD', '民国', '旧藏移交',
  'EXHIBIT_HALL_2', 'COMPLETE', 'IN_STOCK', '二级', '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-13 15:58:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-13 17:28:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0034' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '民国描金漆壶-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-09-13 17:58:00', @seed_admin_id, '2024-09-13 17:58:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0034' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '民国描金漆壶-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '民国描金漆壶-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-09-13 18:03:00', @seed_admin_id, '2024-09-13 18:03:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0034' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '民国描金漆壶-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '民国描金漆壶-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-09-13 18:08:00', @seed_admin_id, '2024-09-13 18:08:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0034' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '民国描金漆壶-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0035', '唐代莲花座供养人像', 'STONE', 'STONE', '唐代', '寺院征集',
  'EXHIBIT_HALL_1', 'COMPLETE', 'IN_STOCK', '二级', '独立底座承托，控制展柜粉尘和局部潮气。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-15 09:05:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-15 10:35:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0035' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '唐代莲花座供养人像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-09-15 11:05:00', @seed_admin_id, '2024-09-15 11:05:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0035' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '唐代莲花座供养人像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '唐代莲花座供养人像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-09-15 11:10:00', @seed_admin_id, '2024-09-15 11:10:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0035' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '唐代莲花座供养人像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0036', '明代题记竹简', 'BAMBOO', 'BAMBOO_WOOD', '明代', '学术移交',
  'EXHIBIT_HALL_2', 'COMPLETE', 'IN_STOCK', '二级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-17 10:12:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-17 11:42:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0036' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代题记竹简-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-09-17 12:12:00', @seed_admin_id, '2024-09-17 12:12:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0036' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代题记竹简-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代题记竹简-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-09-17 12:17:00', @seed_admin_id, '2024-09-17 12:17:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0036' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代题记竹简-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0037', '春秋错金银簋', 'BRONZE_WARE', 'BRONZE', '春秋', '馆际征集',
  'LOC_B', 'INCOMPLETE', 'IN_STOCK', '一级', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-19 11:19:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-19 12:49:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0037' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '春秋错金银簋-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-09-19 13:19:00', @seed_admin_id, '2024-09-19 13:19:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0037' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '春秋错金银簋-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '春秋错金银簋-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-09-19 13:24:00', @seed_admin_id, '2024-09-19 13:24:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0037' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '春秋错金银簋-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '春秋错金银簋-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-09-19 13:29:00', @seed_admin_id, '2024-09-19 13:29:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0037' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '春秋错金银簋-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0038', '明代白釉盘', 'CERAMIC', 'PORCELAIN', '明代', '征集购藏',
  'EXHIBIT_HALL_2', 'COMPLETE', 'IN_STOCK', '二级', '防震托架单件存放，避免温差突变与硬物碰撞。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-21 12:26:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-21 13:56:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0038' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代白釉盘-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-09-21 14:26:00', @seed_admin_id, '2024-09-21 14:26:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0038' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代白釉盘-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代白釉盘-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-09-21 14:31:00', @seed_admin_id, '2024-09-21 14:31:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0038' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代白釉盘-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0039', '民国行书扇面', 'PAINTING_CALLIGRAPHY', 'PAPER', '民国', '馆际征集',
  'LOC_B', 'COMPLETE', 'IN_STOCK', '一般', '避光平放，温度18至20度，相对湿度50%至55%，减少酸化风险。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-23 13:33:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-23 15:03:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0039' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '民国行书扇面-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-09-23 15:33:00', @seed_admin_id, '2024-09-23 15:33:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0039' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '民国行书扇面-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '民国行书扇面-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-09-23 15:38:00', @seed_admin_id, '2024-09-23 15:38:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0039' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '民国行书扇面-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0040', '新石器时代云龙纹玉琮', 'JADE_ARTIFACT', 'JADE', '新石器时代', '馆际调拨',
  'LOC_A', 'INCOMPLETE', 'IN_STOCK', '三级', '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-25 14:40:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-25 16:10:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0040' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '新石器时代云龙纹玉琮-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-09-25 16:40:00', @seed_admin_id, '2024-09-25 16:40:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0040' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '新石器时代云龙纹玉琮-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '新石器时代云龙纹玉琮-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-09-25 16:45:00', @seed_admin_id, '2024-09-25 16:45:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0040' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '新石器时代云龙纹玉琮-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '新石器时代云龙纹玉琮-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-09-25 16:50:00', @seed_admin_id, '2024-09-25 16:50:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0040' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '新石器时代云龙纹玉琮-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0041', '宋代掐丝银盘', 'GOLD_SILVER_WARE', 'GOLD', '宋代', '馆际征集',
  'LOC_VIP', 'INCOMPLETE', 'IN_STOCK', '一级', '恒温低湿保存，避免与含硫物质长期接触。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-27 15:47:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-27 17:17:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0041' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '宋代掐丝银盘-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-09-27 17:47:00', @seed_admin_id, '2024-09-27 17:47:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0041' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '宋代掐丝银盘-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '宋代掐丝银盘-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-09-27 17:52:00', @seed_admin_id, '2024-09-27 17:52:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0041' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '宋代掐丝银盘-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0042', '民国黄花梨经匣', 'WOOD', 'BAMBOO_WOOD', '民国', '社会捐赠',
  'STORAGE_ROOM_3', 'BASIC_COMPLETE', 'IN_STOCK', '三级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-29 09:54:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-29 11:24:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0042' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '民国黄花梨经匣-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-09-29 11:54:00', @seed_admin_id, '2024-09-29 11:54:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0042' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '民国黄花梨经匣-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '民国黄花梨经匣-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-09-29 11:59:00', @seed_admin_id, '2024-09-29 11:59:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0042' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '民国黄花梨经匣-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0043', '汉代戗金漆盘', 'LACQUER', 'LACQUER_WOOD', '汉代', '社会捐赠',
  'EXHIBIT_HALL_1', 'COMPLETE', 'IN_STOCK', '一般', '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-01 10:01:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-01 11:31:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0043' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '汉代戗金漆盘-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-10-01 12:01:00', @seed_admin_id, '2024-10-01 12:01:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0043' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '汉代戗金漆盘-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '汉代戗金漆盘-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-10-01 12:06:00', @seed_admin_id, '2024-10-01 12:06:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0043' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '汉代戗金漆盘-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '汉代戗金漆盘-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-10-01 12:11:00', @seed_admin_id, '2024-10-01 12:11:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0043' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '汉代戗金漆盘-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0044', '宋代造像碑立像', 'STONE', 'STONE', '宋代', '馆际移交',
  'LOC_C', 'BASIC_COMPLETE', 'IN_STOCK', '一级', '独立底座承托，控制展柜粉尘和局部潮气。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-03 11:08:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-03 12:38:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0044' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '宋代造像碑立像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-10-03 13:08:00', @seed_admin_id, '2024-10-03 13:08:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0044' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '宋代造像碑立像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '宋代造像碑立像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-10-03 13:13:00', @seed_admin_id, '2024-10-03 13:13:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0044' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '宋代造像碑立像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0045', '汉代编联木牍', 'BAMBOO', 'BAMBOO_WOOD', '汉代', '学术移交',
  'LOC_VIP', 'BASIC_COMPLETE', 'IN_STOCK', '一般', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-05 12:15:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-05 13:45:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0045' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '汉代编联木牍-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-10-05 14:15:00', @seed_admin_id, '2024-10-05 14:15:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0045' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '汉代编联木牍-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '汉代编联木牍-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-10-05 14:20:00', @seed_admin_id, '2024-10-05 14:20:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0045' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '汉代编联木牍-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0046', '唐代蟠螭纹带钩', 'BRONZE_WARE', 'BRONZE', '唐代', '馆际征集',
  'LOC_C', 'BASIC_COMPLETE', 'IN_STOCK', '一般', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-07 13:22:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-07 14:52:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0046' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '唐代蟠螭纹带钩-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-10-07 15:22:00', @seed_admin_id, '2024-10-07 15:22:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0046' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '唐代蟠螭纹带钩-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '唐代蟠螭纹带钩-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-10-07 15:27:00', @seed_admin_id, '2024-10-07 15:27:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0046' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '唐代蟠螭纹带钩-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '唐代蟠螭纹带钩-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-10-07 15:32:00', @seed_admin_id, '2024-10-07 15:32:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0046' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '唐代蟠螭纹带钩-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0047', '宋代影青罐', 'CERAMIC', 'CLAY', '宋代', '征集购藏',
  'EXHIBIT_HALL_1', 'BASIC_COMPLETE', 'IN_STOCK', '一级', '低震动环境保存，配合缓冲支撑，防止胎体继续开裂。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-09 14:29:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-09 15:59:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0047' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '宋代影青罐-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-10-09 16:29:00', @seed_admin_id, '2024-10-09 16:29:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0047' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '宋代影青罐-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '宋代影青罐-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-10-09 16:34:00', @seed_admin_id, '2024-10-09 16:34:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0047' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '宋代影青罐-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0048', '元代花鸟扇面', 'PAINTING_CALLIGRAPHY', 'SILK', '元代', '社会捐赠',
  'LOC_B', 'BASIC_COMPLETE', 'IN_STOCK', '二级', '平铺或悬挂缓释支撑，避光防尘，控制湿度波动。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-11 15:36:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-11 17:06:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0048' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '元代花鸟扇面-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-10-11 17:36:00', @seed_admin_id, '2024-10-11 17:36:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0048' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '元代花鸟扇面-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '元代花鸟扇面-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-10-11 17:41:00', @seed_admin_id, '2024-10-11 17:41:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0048' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '元代花鸟扇面-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0049', '新石器时代谷纹玉圭', 'JADE_ARTIFACT', 'JADE', '新石器时代', '社会捐赠',
  'LOC_B', 'INCOMPLETE', 'IN_STOCK', '三级', '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-13 09:43:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-13 11:13:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0049' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '新石器时代谷纹玉圭-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-10-13 11:43:00', @seed_admin_id, '2024-10-13 11:43:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0049' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '新石器时代谷纹玉圭-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '新石器时代谷纹玉圭-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-10-13 11:48:00', @seed_admin_id, '2024-10-13 11:48:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0049' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '新石器时代谷纹玉圭-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '新石器时代谷纹玉圭-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-10-13 11:53:00', @seed_admin_id, '2024-10-13 11:53:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0049' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '新石器时代谷纹玉圭-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0050', '清代累丝执壶', 'GOLD_SILVER_WARE', 'GOLD', '清代', '社会捐赠',
  'LOC_A', 'BASIC_COMPLETE', 'IN_STOCK', '二级', '恒温低湿保存，避免与含硫物质长期接触。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-15 10:50:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-15 12:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0050' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代累丝执壶-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-10-15 12:50:00', @seed_admin_id, '2024-10-15 12:50:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0050' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代累丝执壶-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代累丝执壶-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-10-15 12:55:00', @seed_admin_id, '2024-10-15 12:55:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0050' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代累丝执壶-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0051', '明代黄花梨经匣', 'WOOD', 'WOOD', '明代', '社会捐赠',
  'LOC_B', 'BASIC_COMPLETE', 'IN_STOCK', '一级', '恒温恒湿环境保存，避免直射光和虫蛀滋生。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-17 11:57:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-17 13:27:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0051' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代黄花梨经匣-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-10-17 13:57:00', @seed_admin_id, '2024-10-17 13:57:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0051' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代黄花梨经匣-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代黄花梨经匣-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-10-17 14:02:00', @seed_admin_id, '2024-10-17 14:02:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0051' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代黄花梨经匣-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0052', '清代朱漆漆壶', 'LACQUER', 'LACQUER_WOOD', '清代', '征集购藏',
  'LOC_C', 'BASIC_COMPLETE', 'IN_STOCK', '一级', '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-19 12:04:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-19 13:34:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0052' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代朱漆漆壶-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-10-19 14:04:00', @seed_admin_id, '2024-10-19 14:04:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0052' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代朱漆漆壶-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代朱漆漆壶-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-10-19 14:09:00', @seed_admin_id, '2024-10-19 14:09:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0052' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代朱漆漆壶-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '清代朱漆漆壶-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-10-19 14:14:00', @seed_admin_id, '2024-10-19 14:14:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0052' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '清代朱漆漆壶-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0053', '唐代造像碑坐像', 'STONE', 'STONE', '唐代', '考古发掘入藏',
  'LOC_B', 'BASIC_COMPLETE', 'IN_STOCK', '二级', '独立底座承托，控制展柜粉尘和局部潮气。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-21 13:11:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-21 14:41:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0053' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '唐代造像碑坐像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-10-21 15:11:00', @seed_admin_id, '2024-10-21 15:11:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0053' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '唐代造像碑坐像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '唐代造像碑坐像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-10-21 15:16:00', @seed_admin_id, '2024-10-21 15:16:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0053' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '唐代造像碑坐像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0054', '明代简牍册页', 'BAMBOO', 'BAMBOO_WOOD', '明代', '考古发掘入藏',
  'STORAGE_ROOM_3', 'COMPLETE', 'IN_STOCK', '二级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-23 14:18:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-23 15:48:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0054' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代简牍册页-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-10-23 16:18:00', @seed_admin_id, '2024-10-23 16:18:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0054' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代简牍册页-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代简牍册页-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-10-23 16:23:00', @seed_admin_id, '2024-10-23 16:23:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0054' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代简牍册页-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0055', '唐代兽面纹壶', 'BRONZE_WARE', 'BRONZE', '唐代', '旧藏整理',
  'LOC_C', 'BASIC_COMPLETE', 'IN_STOCK', '一般', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-25 15:25:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-25 16:55:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0055' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '唐代兽面纹壶-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-10-25 17:25:00', @seed_admin_id, '2024-10-25 17:25:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0055' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '唐代兽面纹壶-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '唐代兽面纹壶-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-10-25 17:30:00', @seed_admin_id, '2024-10-25 17:30:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0055' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '唐代兽面纹壶-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '唐代兽面纹壶-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-10-25 17:35:00', @seed_admin_id, '2024-10-25 17:35:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0055' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '唐代兽面纹壶-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0056', '清代白釉碗', 'CERAMIC', 'CLAY', '清代', '考古发掘入藏',
  'LOC_B', 'BASIC_COMPLETE', 'IN_STOCK', '三级', '低震动环境保存，配合缓冲支撑，防止胎体继续开裂。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-27 09:32:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-27 11:02:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0056' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代白釉碗-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-10-27 11:32:00', @seed_admin_id, '2024-10-27 11:32:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0056' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代白釉碗-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代白釉碗-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-10-27 11:37:00', @seed_admin_id, '2024-10-27 11:37:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0056' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代白釉碗-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0057', '民国仕女立轴', 'PAINTING_CALLIGRAPHY', 'PAPER', '民国', '馆际征集',
  'LOC_B', 'COMPLETE', 'IN_STOCK', '一般', '避光平放，温度18至20度，相对湿度50%至55%，减少酸化风险。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-29 10:39:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-29 12:09:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0057' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '民国仕女立轴-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-10-29 12:39:00', @seed_admin_id, '2024-10-29 12:39:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0057' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '民国仕女立轴-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '民国仕女立轴-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-10-29 12:44:00', @seed_admin_id, '2024-10-29 12:44:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0057' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '民国仕女立轴-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0058', '新石器时代素面带钩', 'JADE_ARTIFACT', 'JADE', '新石器时代', '考古发掘入藏',
  'LOC_B', 'INCOMPLETE', 'IN_STOCK', '一级', '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-31 11:46:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-31 13:16:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0058' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '新石器时代素面带钩-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-10-31 13:46:00', @seed_admin_id, '2024-10-31 13:46:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0058' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '新石器时代素面带钩-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '新石器时代素面带钩-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-10-31 13:51:00', @seed_admin_id, '2024-10-31 13:51:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0058' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '新石器时代素面带钩-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '新石器时代素面带钩-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-10-31 13:56:00', @seed_admin_id, '2024-10-31 13:56:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0058' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '新石器时代素面带钩-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0059', '明代鎏金执壶', 'GOLD_SILVER_WARE', 'SILVER', '明代', '旧藏整理',
  'LOC_B', 'BASIC_COMPLETE', 'IN_STOCK', '三级', '干燥密闭保存，配合防氧化材料，减少表面发黑。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-02 12:53:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-02 14:23:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0059' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代鎏金执壶-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-11-02 14:53:00', @seed_admin_id, '2024-11-02 14:53:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0059' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代鎏金执壶-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代鎏金执壶-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-11-02 14:58:00', @seed_admin_id, '2024-11-02 14:58:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0059' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代鎏金执壶-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0060', '清代黄花梨佛像', 'WOOD', 'BAMBOO_WOOD', '清代', '社会捐赠',
  'LOC_A', 'COMPLETE', 'IN_STOCK', '一级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-04 13:00:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-04 14:30:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0060' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代黄花梨佛像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-11-04 15:00:00', @seed_admin_id, '2024-11-04 15:00:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0060' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代黄花梨佛像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代黄花梨佛像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-11-04 15:05:00', @seed_admin_id, '2024-11-04 15:05:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0060' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代黄花梨佛像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0061', '明代黑漆漆奁', 'LACQUER', 'LACQUER_WOOD', '明代', '征集购藏',
  'LOC_A', 'INCOMPLETE', 'IN_STOCK', '二级', '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-06 14:07:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-06 15:37:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0061' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代黑漆漆奁-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-11-06 16:07:00', @seed_admin_id, '2024-11-06 16:07:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0061' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代黑漆漆奁-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代黑漆漆奁-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-11-06 16:12:00', @seed_admin_id, '2024-11-06 16:12:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0061' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代黑漆漆奁-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '明代黑漆漆奁-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-11-06 16:17:00', @seed_admin_id, '2024-11-06 16:17:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0061' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '明代黑漆漆奁-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0062', '北魏经幢坐像', 'STONE', 'STONE', '北魏', '寺院征集',
  'STORAGE_ROOM_3', 'COMPLETE', 'IN_STOCK', '三级', '独立底座承托，控制展柜粉尘和局部潮气。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-08 15:14:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-08 16:44:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0062' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '北魏经幢坐像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-11-08 17:14:00', @seed_admin_id, '2024-11-08 17:14:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0062' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '北魏经幢坐像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '北魏经幢坐像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-11-08 17:19:00', @seed_admin_id, '2024-11-08 17:19:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0062' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '北魏经幢坐像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0063', '宋代题记木牍', 'BAMBOO', 'BAMBOO_WOOD', '宋代', '考古发掘入藏',
  'STORAGE_ROOM_3', 'COMPLETE', 'IN_STOCK', '三级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-10 09:21:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-10 10:51:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0063' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '宋代题记木牍-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-11-10 11:21:00', @seed_admin_id, '2024-11-10 11:21:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0063' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '宋代题记木牍-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '宋代题记木牍-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-11-10 11:26:00', @seed_admin_id, '2024-11-10 11:26:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0063' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '宋代题记木牍-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0064', '春秋兽面纹鼎', 'BRONZE_WARE', 'BRONZE', '春秋', '馆际征集',
  'LOC_B', 'COMPLETE', 'IN_STOCK', '二级', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-12 10:28:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-12 11:58:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0064' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '春秋兽面纹鼎-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-11-12 12:28:00', @seed_admin_id, '2024-11-12 12:28:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0064' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '春秋兽面纹鼎-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '春秋兽面纹鼎-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-11-12 12:33:00', @seed_admin_id, '2024-11-12 12:33:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0064' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '春秋兽面纹鼎-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '春秋兽面纹鼎-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-11-12 12:38:00', @seed_admin_id, '2024-11-12 12:38:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0064' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '春秋兽面纹鼎-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0065', '唐代粉彩罐', 'CERAMIC', 'PORCELAIN', '唐代', '社会捐赠',
  'LOC_C', 'BASIC_COMPLETE', 'IN_STOCK', '一般', '防震托架单件存放，避免温差突变与硬物碰撞。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-14 11:35:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-14 13:05:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0065' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '唐代粉彩罐-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-11-14 13:35:00', @seed_admin_id, '2024-11-14 13:35:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0065' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '唐代粉彩罐-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '唐代粉彩罐-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-11-14 13:40:00', @seed_admin_id, '2024-11-14 13:40:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0065' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '唐代粉彩罐-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0066', '民国山水扇面', 'PAINTING_CALLIGRAPHY', 'SILK', '民国', '馆际征集',
  'STORAGE_ROOM_3', 'BASIC_COMPLETE', 'IN_STOCK', '二级', '平铺或悬挂缓释支撑，避光防尘，控制湿度波动。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-16 12:42:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-16 14:12:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0066' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '民国山水扇面-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-11-16 14:42:00', @seed_admin_id, '2024-11-16 14:42:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0066' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '民国山水扇面-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '民国山水扇面-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-11-16 14:47:00', @seed_admin_id, '2024-11-16 14:47:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0066' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '民国山水扇面-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0067', '战国凤鸟纹玉璧', 'JADE_ARTIFACT', 'JADE', '战国', '馆际调拨',
  'LOC_VIP', 'INCOMPLETE', 'IN_STOCK', '一般', '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-18 13:49:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-18 15:19:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0067' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '战国凤鸟纹玉璧-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-11-18 15:49:00', @seed_admin_id, '2024-11-18 15:49:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0067' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '战国凤鸟纹玉璧-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '战国凤鸟纹玉璧-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-11-18 15:54:00', @seed_admin_id, '2024-11-18 15:54:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0067' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '战国凤鸟纹玉璧-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '战国凤鸟纹玉璧-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-11-18 15:59:00', @seed_admin_id, '2024-11-18 15:59:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0067' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '战国凤鸟纹玉璧-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0068', '明代掐丝执壶', 'GOLD_SILVER_WARE', 'SILVER', '明代', '馆际征集',
  'EXHIBIT_HALL_2', 'BASIC_COMPLETE', 'IN_STOCK', '二级', '干燥密闭保存，配合防氧化材料，减少表面发黑。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-20 14:56:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-20 16:26:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0068' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代掐丝执壶-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-11-20 16:56:00', @seed_admin_id, '2024-11-20 16:56:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0068' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代掐丝执壶-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代掐丝执壶-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-11-20 17:01:00', @seed_admin_id, '2024-11-20 17:01:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0068' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代掐丝执壶-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0069', '民国柏木髹漆经匣', 'WOOD', 'WOOD', '民国', '馆际调拨',
  'EXHIBIT_HALL_2', 'COMPLETE', 'IN_STOCK', '一般', '恒温恒湿环境保存，避免直射光和虫蛀滋生。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-22 15:03:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-22 16:33:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0069' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '民国柏木髹漆经匣-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-11-22 17:03:00', @seed_admin_id, '2024-11-22 17:03:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0069' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '民国柏木髹漆经匣-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '民国柏木髹漆经匣-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-11-22 17:08:00', @seed_admin_id, '2024-11-22 17:08:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0069' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '民国柏木髹漆经匣-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0070', '明代描金漆奁', 'LACQUER', 'LACQUER_WOOD', '明代', '旧藏移交',
  'STORAGE_ROOM_3', 'BASIC_COMPLETE', 'IN_STOCK', '一级', '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-24 09:10:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-24 10:40:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0070' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代描金漆奁-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-11-24 11:10:00', @seed_admin_id, '2024-11-24 11:10:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0070' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代描金漆奁-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代描金漆奁-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-11-24 11:15:00', @seed_admin_id, '2024-11-24 11:15:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0070' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代描金漆奁-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '明代描金漆奁-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-11-24 11:20:00', @seed_admin_id, '2024-11-24 11:20:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0070' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '明代描金漆奁-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0071', '北魏经幢立像', 'STONE', 'STONE', '北魏', '考古发掘入藏',
  'LOC_VIP', 'BASIC_COMPLETE', 'IN_STOCK', '一级', '独立底座承托，控制展柜粉尘和局部潮气。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-26 10:17:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-26 11:47:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0071' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '北魏经幢立像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-11-26 12:17:00', @seed_admin_id, '2024-11-26 12:17:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0071' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '北魏经幢立像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '北魏经幢立像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-11-26 12:22:00', @seed_admin_id, '2024-11-26 12:22:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0071' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '北魏经幢立像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0072', '战国编联木牍', 'BAMBOO', 'BAMBOO_WOOD', '战国', '考古发掘入藏',
  'LOC_C', 'INCOMPLETE', 'IN_STOCK', '一般', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-28 11:24:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-28 12:54:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0072' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '战国编联木牍-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-11-28 13:24:00', @seed_admin_id, '2024-11-28 13:24:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0072' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '战国编联木牍-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '战国编联木牍-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-11-28 13:29:00', @seed_admin_id, '2024-11-28 13:29:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0072' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '战国编联木牍-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0073', '春秋铭文壶', 'BRONZE_WARE', 'BRONZE', '春秋', '旧藏整理',
  'LOC_VIP', 'COMPLETE', 'IN_STOCK', '一级', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-30 12:31:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-30 14:01:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0073' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '春秋铭文壶-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-11-30 14:31:00', @seed_admin_id, '2024-11-30 14:31:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0073' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '春秋铭文壶-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '春秋铭文壶-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-11-30 14:36:00', @seed_admin_id, '2024-11-30 14:36:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0073' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '春秋铭文壶-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '春秋铭文壶-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-11-30 14:41:00', @seed_admin_id, '2024-11-30 14:41:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0073' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '春秋铭文壶-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0074', '元代刻花罐', 'CERAMIC', 'CLAY', '元代', '征集购藏',
  'EXHIBIT_HALL_1', 'INCOMPLETE', 'IN_STOCK', '二级', '低震动环境保存，配合缓冲支撑，防止胎体继续开裂。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-02 13:38:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-02 15:08:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0074' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '元代刻花罐-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-12-02 15:38:00', @seed_admin_id, '2024-12-02 15:38:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0074' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '元代刻花罐-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '元代刻花罐-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-12-02 15:43:00', @seed_admin_id, '2024-12-02 15:43:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0074' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '元代刻花罐-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0075', '民国仕女册页', 'PAINTING_CALLIGRAPHY', 'SILK', '民国', '旧藏移交',
  'LOC_A', 'BASIC_COMPLETE', 'IN_STOCK', '二级', '平铺或悬挂缓释支撑，避光防尘，控制湿度波动。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-04 14:45:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-04 16:15:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0075' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '民国仕女册页-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-12-04 16:45:00', @seed_admin_id, '2024-12-04 16:45:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0075' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '民国仕女册页-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '民国仕女册页-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-12-04 16:50:00', @seed_admin_id, '2024-12-04 16:50:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0075' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '民国仕女册页-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0076', '清代云龙纹玉璧', 'JADE_ARTIFACT', 'JADE', '清代', '考古发掘入藏',
  'LOC_B', 'INCOMPLETE', 'IN_STOCK', '一级', '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-06 15:52:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-06 17:22:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0076' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代云龙纹玉璧-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-12-06 17:52:00', @seed_admin_id, '2024-12-06 17:52:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0076' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代云龙纹玉璧-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代云龙纹玉璧-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-12-06 17:57:00', @seed_admin_id, '2024-12-06 17:57:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0076' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代云龙纹玉璧-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '清代云龙纹玉璧-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-12-06 18:02:00', @seed_admin_id, '2024-12-06 18:02:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0076' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '清代云龙纹玉璧-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0077', '宋代累丝执壶', 'GOLD_SILVER_WARE', 'SILVER', '宋代', '社会捐赠',
  'LOC_VIP', 'INCOMPLETE', 'IN_STOCK', '一般', '干燥密闭保存，配合防氧化材料，减少表面发黑。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-08 09:59:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-08 11:29:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0077' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '宋代累丝执壶-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-12-08 11:59:00', @seed_admin_id, '2024-12-08 11:59:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0077' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '宋代累丝执壶-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '宋代累丝执壶-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-12-08 12:04:00', @seed_admin_id, '2024-12-08 12:04:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0077' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '宋代累丝执壶-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0078', '清代描金经匣', 'WOOD', 'BAMBOO_WOOD', '清代', '寺院征集',
  'LOC_A', 'INCOMPLETE', 'IN_STOCK', '一般', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-10 10:06:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-10 11:36:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0078' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代描金经匣-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-12-10 12:06:00', @seed_admin_id, '2024-12-10 12:06:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0078' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代描金经匣-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代描金经匣-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-12-10 12:11:00', @seed_admin_id, '2024-12-10 12:11:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0078' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代描金经匣-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0079', '战国戗金漆盒', 'LACQUER', 'LACQUER_WOOD', '战国', '征集购藏',
  'LOC_C', 'COMPLETE', 'IN_STOCK', '一级', '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-12 11:13:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-12 12:43:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0079' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '战国戗金漆盒-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-12-12 13:13:00', @seed_admin_id, '2024-12-12 13:13:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0079' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '战国戗金漆盒-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '战国戗金漆盒-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-12-12 13:18:00', @seed_admin_id, '2024-12-12 13:18:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0079' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '战国戗金漆盒-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '战国戗金漆盒-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-12-12 13:23:00', @seed_admin_id, '2024-12-12 13:23:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0079' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '战国戗金漆盒-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0080', '北魏莲花座坐像', 'STONE', 'STONE', '北魏', '考古发掘入藏',
  'EXHIBIT_HALL_2', 'INCOMPLETE', 'IN_STOCK', '三级', '独立底座承托，控制展柜粉尘和局部潮气。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-14 12:20:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-14 13:50:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0080' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '北魏莲花座坐像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-12-14 14:20:00', @seed_admin_id, '2024-12-14 14:20:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0080' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '北魏莲花座坐像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '北魏莲花座坐像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-12-14 14:25:00', @seed_admin_id, '2024-12-14 14:25:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0080' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '北魏莲花座坐像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0081', '战国墨书木牍', 'BAMBOO', 'BAMBOO_WOOD', '战国', '考古发掘入藏',
  'LOC_A', 'INCOMPLETE', 'IN_STOCK', '三级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-16 13:27:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-16 14:57:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0081' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '战国墨书木牍-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-12-16 15:27:00', @seed_admin_id, '2024-12-16 15:27:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0081' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '战国墨书木牍-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '战国墨书木牍-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-12-16 15:32:00', @seed_admin_id, '2024-12-16 15:32:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0081' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '战国墨书木牍-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0082', '春秋云雷纹镜', 'BRONZE_WARE', 'BRONZE', '春秋', '馆际征集',
  'STORAGE_ROOM_3', 'COMPLETE', 'IN_STOCK', '二级', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-18 14:34:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-18 16:04:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0082' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '春秋云雷纹镜-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-12-18 16:34:00', @seed_admin_id, '2024-12-18 16:34:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0082' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '春秋云雷纹镜-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '春秋云雷纹镜-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-12-18 16:39:00', @seed_admin_id, '2024-12-18 16:39:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0082' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '春秋云雷纹镜-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '春秋云雷纹镜-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-12-18 16:44:00', @seed_admin_id, '2024-12-18 16:44:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0082' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '春秋云雷纹镜-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0083', '元代影青盘口壶', 'CERAMIC', 'CLAY', '元代', '征集购藏',
  'LOC_A', 'INCOMPLETE', 'IN_STOCK', '三级', '低震动环境保存，配合缓冲支撑，防止胎体继续开裂。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-20 15:41:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-20 17:11:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0083' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '元代影青盘口壶-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-12-20 17:41:00', @seed_admin_id, '2024-12-20 17:41:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0083' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '元代影青盘口壶-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '元代影青盘口壶-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-12-20 17:46:00', @seed_admin_id, '2024-12-20 17:46:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0083' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '元代影青盘口壶-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0084', '清代山水立轴', 'PAINTING_CALLIGRAPHY', 'PAPER', '清代', '社会捐赠',
  'LOC_C', 'COMPLETE', 'IN_STOCK', '三级', '避光平放，温度18至20度，相对湿度50%至55%，减少酸化风险。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-22 09:48:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-22 11:18:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0084' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代山水立轴-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-12-22 11:48:00', @seed_admin_id, '2024-12-22 11:48:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0084' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代山水立轴-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代山水立轴-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-12-22 11:53:00', @seed_admin_id, '2024-12-22 11:53:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0084' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代山水立轴-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0085', '清代谷纹带钩', 'JADE_ARTIFACT', 'JADE', '清代', '考古发掘入藏',
  'EXHIBIT_HALL_1', 'BASIC_COMPLETE', 'IN_STOCK', '一般', '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-24 10:55:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-24 12:25:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0085' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代谷纹带钩-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-12-24 12:55:00', @seed_admin_id, '2024-12-24 12:55:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0085' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代谷纹带钩-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代谷纹带钩-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-12-24 13:00:00', @seed_admin_id, '2024-12-24 13:00:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0085' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代谷纹带钩-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '清代谷纹带钩-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-12-24 13:05:00', @seed_admin_id, '2024-12-24 13:05:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0085' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '清代谷纹带钩-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0086', '唐代累丝带扣', 'GOLD_SILVER_WARE', 'SILVER', '唐代', '旧藏整理',
  'STORAGE_ROOM_3', 'BASIC_COMPLETE', 'IN_STOCK', '二级', '干燥密闭保存，配合防氧化材料，减少表面发黑。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-26 11:02:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-26 12:32:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0086' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '唐代累丝带扣-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-12-26 13:02:00', @seed_admin_id, '2024-12-26 13:02:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0086' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '唐代累丝带扣-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '唐代累丝带扣-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-12-26 13:07:00', @seed_admin_id, '2024-12-26 13:07:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0086' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '唐代累丝带扣-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0087', '民国描金经匣', 'WOOD', 'BAMBOO_WOOD', '民国', '社会捐赠',
  'EXHIBIT_HALL_1', 'BASIC_COMPLETE', 'IN_STOCK', '一级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-28 12:09:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-28 13:39:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0087' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '民国描金经匣-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-12-28 14:09:00', @seed_admin_id, '2024-12-28 14:09:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0087' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '民国描金经匣-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '民国描金经匣-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-12-28 14:14:00', @seed_admin_id, '2024-12-28 14:14:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0087' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '民国描金经匣-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0088', '战国剔红漆奁', 'LACQUER', 'LACQUER_WOOD', '战国', '社会捐赠',
  'LOC_VIP', 'BASIC_COMPLETE', 'IN_STOCK', '一般', '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-30 13:16:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-30 14:46:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0088' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '战国剔红漆奁-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2024-12-30 15:16:00', @seed_admin_id, '2024-12-30 15:16:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0088' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '战国剔红漆奁-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '战国剔红漆奁-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2024-12-30 15:21:00', @seed_admin_id, '2024-12-30 15:21:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0088' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '战国剔红漆奁-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '战国剔红漆奁-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2024-12-30 15:26:00', @seed_admin_id, '2024-12-30 15:26:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0088' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '战国剔红漆奁-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0089', '唐代菩萨坐像', 'STONE', 'STONE', '唐代', '考古发掘入藏',
  'LOC_B', 'COMPLETE', 'IN_STOCK', '一般', '独立底座承托，控制展柜粉尘和局部潮气。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-01 14:23:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-01 15:53:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0089' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '唐代菩萨坐像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-01-01 16:23:00', @seed_admin_id, '2025-01-01 16:23:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0089' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '唐代菩萨坐像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '唐代菩萨坐像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-01-01 16:28:00', @seed_admin_id, '2025-01-01 16:28:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0089' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '唐代菩萨坐像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0090', '宋代编联竹简', 'BAMBOO', 'BAMBOO_WOOD', '宋代', '学术移交',
  'STORAGE_ROOM_3', 'BASIC_COMPLETE', 'IN_STOCK', '二级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-03 15:30:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-03 17:00:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0090' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '宋代编联竹简-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-01-03 17:30:00', @seed_admin_id, '2025-01-03 17:30:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0090' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '宋代编联竹简-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '宋代编联竹简-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-01-03 17:35:00', @seed_admin_id, '2025-01-03 17:35:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0090' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '宋代编联竹简-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0091', '战国蟠螭纹壶', 'BRONZE_WARE', 'BRONZE', '战国', '考古发掘入藏',
  'STORAGE_ROOM_3', 'BASIC_COMPLETE', 'IN_STOCK', '三级', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-05 09:37:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-05 11:07:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0091' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '战国蟠螭纹壶-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-01-05 11:37:00', @seed_admin_id, '2025-01-05 11:37:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0091' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '战国蟠螭纹壶-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '战国蟠螭纹壶-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-01-05 11:42:00', @seed_admin_id, '2025-01-05 11:42:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0091' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '战国蟠螭纹壶-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '战国蟠螭纹壶-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-01-05 11:47:00', @seed_admin_id, '2025-01-05 11:47:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0091' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '战国蟠螭纹壶-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0092', '清代白釉盘', 'CERAMIC', 'CLAY', '清代', '考古发掘入藏',
  'EXHIBIT_HALL_1', 'INCOMPLETE', 'IN_STOCK', '二级', '低震动环境保存，配合缓冲支撑，防止胎体继续开裂。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-07 10:44:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-07 12:14:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0092' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代白釉盘-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-01-07 12:44:00', @seed_admin_id, '2025-01-07 12:44:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0092' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代白釉盘-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代白釉盘-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-01-07 12:49:00', @seed_admin_id, '2025-01-07 12:49:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0092' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代白釉盘-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0093', '元代行书扇面', 'PAINTING_CALLIGRAPHY', 'PAPER', '元代', '旧藏移交',
  'EXHIBIT_HALL_2', 'BASIC_COMPLETE', 'IN_STOCK', '二级', '避光平放，温度18至20度，相对湿度50%至55%，减少酸化风险。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-09 11:51:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-09 13:21:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0093' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '元代行书扇面-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-01-09 13:51:00', @seed_admin_id, '2025-01-09 13:51:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0093' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '元代行书扇面-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '元代行书扇面-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-01-09 13:56:00', @seed_admin_id, '2025-01-09 13:56:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0093' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '元代行书扇面-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0094', '战国云龙纹玉璧', 'JADE_ARTIFACT', 'JADE', '战国', '社会捐赠',
  'EXHIBIT_HALL_2', 'INCOMPLETE', 'IN_STOCK', '二级', '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-11 12:58:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-11 14:28:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0094' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '战国云龙纹玉璧-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-01-11 14:58:00', @seed_admin_id, '2025-01-11 14:58:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0094' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '战国云龙纹玉璧-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '战国云龙纹玉璧-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-01-11 15:03:00', @seed_admin_id, '2025-01-11 15:03:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0094' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '战国云龙纹玉璧-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '战国云龙纹玉璧-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-01-11 15:08:00', @seed_admin_id, '2025-01-11 15:08:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0094' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '战国云龙纹玉璧-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0095', '清代鎏金带扣', 'GOLD_SILVER_WARE', 'GOLD', '清代', '旧藏整理',
  'EXHIBIT_HALL_2', 'COMPLETE', 'IN_STOCK', '一级', '恒温低湿保存，避免与含硫物质长期接触。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-13 13:05:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-13 14:35:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0095' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代鎏金带扣-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-01-13 15:05:00', @seed_admin_id, '2025-01-13 15:05:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0095' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代鎏金带扣-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代鎏金带扣-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-01-13 15:10:00', @seed_admin_id, '2025-01-13 15:10:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0095' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代鎏金带扣-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0096', '民国柏木髹漆经匣', 'WOOD', 'BAMBOO_WOOD', '民国', '社会捐赠',
  'LOC_VIP', 'INCOMPLETE', 'IN_STOCK', '二级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-15 14:12:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-15 15:42:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0096' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '民国柏木髹漆经匣-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-01-15 16:12:00', @seed_admin_id, '2025-01-15 16:12:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0096' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '民国柏木髹漆经匣-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '民国柏木髹漆经匣-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-01-15 16:17:00', @seed_admin_id, '2025-01-15 16:17:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0096' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '民国柏木髹漆经匣-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0097', '明代戗金漆盘', 'LACQUER', 'LACQUER_WOOD', '明代', '旧藏移交',
  'LOC_A', 'COMPLETE', 'IN_STOCK', '三级', '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-17 15:19:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-17 16:49:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0097' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代戗金漆盘-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-01-17 17:19:00', @seed_admin_id, '2025-01-17 17:19:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0097' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代戗金漆盘-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代戗金漆盘-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-01-17 17:24:00', @seed_admin_id, '2025-01-17 17:24:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0097' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代戗金漆盘-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '明代戗金漆盘-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-01-17 17:29:00', @seed_admin_id, '2025-01-17 17:29:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0097' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '明代戗金漆盘-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0098', '唐代莲花座石刻残件', 'STONE', 'STONE', '唐代', '馆际移交',
  'LOC_C', 'INCOMPLETE', 'IN_STOCK', '一般', '独立底座承托，控制展柜粉尘和局部潮气。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-19 09:26:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-19 10:56:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0098' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '唐代莲花座石刻残件-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-01-19 11:26:00', @seed_admin_id, '2025-01-19 11:26:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0098' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '唐代莲花座石刻残件-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '唐代莲花座石刻残件-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-01-19 11:31:00', @seed_admin_id, '2025-01-19 11:31:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0098' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '唐代莲花座石刻残件-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0099', '明代墨书竹简', 'BAMBOO', 'BAMBOO_WOOD', '明代', '学术移交',
  'LOC_B', 'INCOMPLETE', 'IN_STOCK', '一级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-21 10:33:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-21 12:03:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0099' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代墨书竹简-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-01-21 12:33:00', @seed_admin_id, '2025-01-21 12:33:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0099' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代墨书竹简-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代墨书竹简-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-01-21 12:38:00', @seed_admin_id, '2025-01-21 12:38:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0099' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代墨书竹简-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0100', '唐代云雷纹鼎', 'BRONZE_WARE', 'BRONZE', '唐代', '馆际征集',
  'LOC_VIP', 'INCOMPLETE', 'IN_STOCK', '一般', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-23 11:40:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-23 13:10:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0100' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '唐代云雷纹鼎-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-01-23 13:40:00', @seed_admin_id, '2025-01-23 13:40:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0100' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '唐代云雷纹鼎-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '唐代云雷纹鼎-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-01-23 13:45:00', @seed_admin_id, '2025-01-23 13:45:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0100' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '唐代云雷纹鼎-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '唐代云雷纹鼎-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-01-23 13:50:00', @seed_admin_id, '2025-01-23 13:50:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0100' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '唐代云雷纹鼎-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0101', '元代粉彩罐', 'CERAMIC', 'CLAY', '元代', '社会捐赠',
  'LOC_A', 'COMPLETE', 'OUTBOUND_PENDING', '一级', '低震动环境保存，配合缓冲支撑，防止胎体继续开裂。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-25 12:47:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-25 14:17:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0101' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '元代粉彩罐-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-01-25 14:47:00', @seed_admin_id, '2025-01-25 14:47:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0101' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '元代粉彩罐-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '元代粉彩罐-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-01-25 14:52:00', @seed_admin_id, '2025-01-25 14:52:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0101' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '元代粉彩罐-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0102', '明代花鸟册页', 'PAINTING_CALLIGRAPHY', 'SILK', '明代', '社会捐赠',
  'EXHIBIT_HALL_1', 'COMPLETE', 'OUTBOUND_PENDING', '一般', '平铺或悬挂缓释支撑，避光防尘，控制湿度波动。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-27 13:54:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-27 15:24:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0102' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代花鸟册页-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-01-27 15:54:00', @seed_admin_id, '2025-01-27 15:54:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0102' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代花鸟册页-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代花鸟册页-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-01-27 15:59:00', @seed_admin_id, '2025-01-27 15:59:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0102' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代花鸟册页-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0103', '汉代素面玉璧', 'JADE_ARTIFACT', 'JADE', '汉代', '馆际调拨',
  'LOC_B', 'COMPLETE', 'OUTBOUND_PENDING', '一般', '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-29 14:01:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-29 15:31:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0103' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '汉代素面玉璧-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-01-29 16:01:00', @seed_admin_id, '2025-01-29 16:01:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0103' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '汉代素面玉璧-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '汉代素面玉璧-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-01-29 16:06:00', @seed_admin_id, '2025-01-29 16:06:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0103' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '汉代素面玉璧-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '汉代素面玉璧-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-01-29 16:11:00', @seed_admin_id, '2025-01-29 16:11:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0103' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '汉代素面玉璧-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0104', '清代鎏金冠饰', 'GOLD_SILVER_WARE', 'SILVER', '清代', '馆际征集',
  'TEMP_STORAGE', 'COMPLETE', 'OUTBOUND_PENDING', '一级', '干燥密闭保存，配合防氧化材料，减少表面发黑。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-31 15:08:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-31 16:38:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0104' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代鎏金冠饰-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-01-31 17:08:00', @seed_admin_id, '2025-01-31 17:08:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0104' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代鎏金冠饰-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代鎏金冠饰-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-01-31 17:13:00', @seed_admin_id, '2025-01-31 17:13:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0104' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代鎏金冠饰-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0105', '明代紫檀雕花佛像', 'WOOD', 'WOOD', '明代', '社会捐赠',
  'LOC_B', 'COMPLETE', 'OUTBOUND_PENDING', '二级', '恒温恒湿环境保存，避免直射光和虫蛀滋生。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-02 09:15:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-02 10:45:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0105' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代紫檀雕花佛像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-02-02 11:15:00', @seed_admin_id, '2025-02-02 11:15:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0105' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代紫檀雕花佛像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代紫檀雕花佛像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-02-02 11:20:00', @seed_admin_id, '2025-02-02 11:20:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0105' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代紫檀雕花佛像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0106', '民国描金漆盘', 'LACQUER', 'LACQUER_WOOD', '民国', '旧藏移交',
  'TEMP_STORAGE', 'COMPLETE', 'OUTBOUND_PENDING', '二级', '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-04 10:22:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-04 11:52:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0106' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '民国描金漆盘-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-02-04 12:22:00', @seed_admin_id, '2025-02-04 12:22:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0106' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '民国描金漆盘-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '民国描金漆盘-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-02-04 12:27:00', @seed_admin_id, '2025-02-04 12:27:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0106' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '民国描金漆盘-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '民国描金漆盘-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-02-04 12:32:00', @seed_admin_id, '2025-02-04 12:32:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0106' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '民国描金漆盘-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0107', '北魏造像碑立像', 'STONE', 'STONE', '北魏', '寺院征集',
  'EXHIBIT_HALL_1', 'BASIC_COMPLETE', 'OUTBOUND_PENDING', '一级', '独立底座承托，控制展柜粉尘和局部潮气。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-06 11:29:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-06 12:59:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0107' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '北魏造像碑立像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-02-06 13:29:00', @seed_admin_id, '2025-02-06 13:29:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0107' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '北魏造像碑立像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '北魏造像碑立像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-02-06 13:34:00', @seed_admin_id, '2025-02-06 13:34:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0107' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '北魏造像碑立像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0108', '战国简牍竹简', 'BAMBOO', 'BAMBOO_WOOD', '战国', '馆际征集',
  'EXHIBIT_HALL_1', 'COMPLETE', 'OUTBOUND_PENDING', '一般', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-08 12:36:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-08 14:06:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0108' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '战国简牍竹简-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-02-08 14:36:00', @seed_admin_id, '2025-02-08 14:36:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0108' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '战国简牍竹简-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '战国简牍竹简-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-02-08 14:41:00', @seed_admin_id, '2025-02-08 14:41:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0108' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '战国简牍竹简-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0109', '战国兽面纹镜', 'BRONZE_WARE', 'BRONZE', '战国', '考古发掘入藏',
  'LOC_B', 'COMPLETE', 'OUTBOUND_PENDING', '一级', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-10 13:43:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-10 15:13:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0109' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '战国兽面纹镜-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-02-10 15:43:00', @seed_admin_id, '2025-02-10 15:43:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0109' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '战国兽面纹镜-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '战国兽面纹镜-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-02-10 15:48:00', @seed_admin_id, '2025-02-10 15:48:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0109' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '战国兽面纹镜-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '战国兽面纹镜-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-02-10 15:53:00', @seed_admin_id, '2025-02-10 15:53:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0109' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '战国兽面纹镜-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0110', '民国白釉罐', 'CERAMIC', 'PORCELAIN', '民国', '考古发掘入藏',
  'LOC_A', 'COMPLETE', 'OUTBOUND_PENDING', '二级', '防震托架单件存放，避免温差突变与硬物碰撞。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-12 14:50:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-12 16:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0110' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '民国白釉罐-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-02-12 16:50:00', @seed_admin_id, '2025-02-12 16:50:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0110' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '民国白釉罐-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '民国白釉罐-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-02-12 16:55:00', @seed_admin_id, '2025-02-12 16:55:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0110' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '民国白釉罐-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0111', '清代行书扇面', 'PAINTING_CALLIGRAPHY', 'SILK', '清代', '馆际征集',
  'EXHIBIT_HALL_1', 'BASIC_COMPLETE', 'OUTBOUND_PENDING', '一般', '平铺或悬挂缓释支撑，避光防尘，控制湿度波动。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-14 15:57:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-14 17:27:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0111' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代行书扇面-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-02-14 17:57:00', @seed_admin_id, '2025-02-14 17:57:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0111' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代行书扇面-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代行书扇面-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-02-14 18:02:00', @seed_admin_id, '2025-02-14 18:02:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0111' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代行书扇面-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0112', '商代素面玉圭', 'JADE_ARTIFACT', 'JADE', '商代', '馆际调拨',
  'EXHIBIT_HALL_2', 'COMPLETE', 'OUTBOUND_PENDING', '一级', '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-16 09:04:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-16 10:34:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0112' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '商代素面玉圭-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-02-16 11:04:00', @seed_admin_id, '2025-02-16 11:04:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0112' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '商代素面玉圭-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '商代素面玉圭-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-02-16 11:09:00', @seed_admin_id, '2025-02-16 11:09:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0112' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '商代素面玉圭-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '商代素面玉圭-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-02-16 11:14:00', @seed_admin_id, '2025-02-16 11:14:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0112' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '商代素面玉圭-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0113', '宋代鎏金带扣', 'GOLD_SILVER_WARE', 'GOLD', '宋代', '旧藏整理',
  'EXHIBIT_HALL_2', 'COMPLETE', 'OUTBOUND_PENDING', '二级', '恒温低湿保存，避免与含硫物质长期接触。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-18 10:11:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-18 11:41:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0113' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '宋代鎏金带扣-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-02-18 12:11:00', @seed_admin_id, '2025-02-18 12:11:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0113' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '宋代鎏金带扣-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '宋代鎏金带扣-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-02-18 12:16:00', @seed_admin_id, '2025-02-18 12:16:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0113' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '宋代鎏金带扣-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0114', '明代描金香几', 'WOOD', 'BAMBOO_WOOD', '明代', '寺院征集',
  'LOC_B', 'COMPLETE', 'OUTBOUND_PENDING', '二级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-20 11:18:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-20 12:48:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0114' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代描金香几-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-02-20 13:18:00', @seed_admin_id, '2025-02-20 13:18:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0114' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代描金香几-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代描金香几-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-02-20 13:23:00', @seed_admin_id, '2025-02-20 13:23:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0114' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代描金香几-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0115', '战国描金漆壶', 'LACQUER', 'LACQUER_WOOD', '战国', '社会捐赠',
  'EXHIBIT_HALL_1', 'BASIC_COMPLETE', 'OUTBOUND_PENDING', '三级', '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-22 12:25:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-22 13:55:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0115' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '战国描金漆壶-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-02-22 14:25:00', @seed_admin_id, '2025-02-22 14:25:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0115' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '战国描金漆壶-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '战国描金漆壶-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-02-22 14:30:00', @seed_admin_id, '2025-02-22 14:30:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0115' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '战国描金漆壶-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '战国描金漆壶-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-02-22 14:35:00', @seed_admin_id, '2025-02-22 14:35:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0115' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '战国描金漆壶-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0116', '北魏经幢坐像', 'STONE', 'STONE', '北魏', '馆际移交',
  'TEMP_STORAGE', 'COMPLETE', 'OUTBOUND_PENDING', '一级', '独立底座承托，控制展柜粉尘和局部潮气。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-24 13:32:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-24 15:02:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0116' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '北魏经幢坐像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-02-24 15:32:00', @seed_admin_id, '2025-02-24 15:32:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0116' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '北魏经幢坐像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '北魏经幢坐像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-02-24 15:37:00', @seed_admin_id, '2025-02-24 15:37:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0116' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '北魏经幢坐像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0117', '战国题记册页', 'BAMBOO', 'BAMBOO_WOOD', '战国', '考古发掘入藏',
  'EXHIBIT_HALL_2', 'COMPLETE', 'OUTBOUND_PENDING', '二级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-26 14:39:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-26 16:09:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0117' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '战国题记册页-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-02-26 16:39:00', @seed_admin_id, '2025-02-26 16:39:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0117' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '战国题记册页-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '战国题记册页-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-02-26 16:44:00', @seed_admin_id, '2025-02-26 16:44:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0117' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '战国题记册页-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0118', '春秋错金银带钩', 'BRONZE_WARE', 'BRONZE', '春秋', '馆际征集',
  'TEMP_STORAGE', 'BASIC_COMPLETE', 'OUTBOUND_PENDING', '一般', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-28 15:46:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-28 17:16:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0118' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '春秋错金银带钩-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-02-28 17:46:00', @seed_admin_id, '2025-02-28 17:46:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0118' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '春秋错金银带钩-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '春秋错金银带钩-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-02-28 17:51:00', @seed_admin_id, '2025-02-28 17:51:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0118' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '春秋错金银带钩-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '春秋错金银带钩-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-02-28 17:56:00', @seed_admin_id, '2025-02-28 17:56:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0118' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '春秋错金银带钩-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0119', '元代影青碗', 'CERAMIC', 'PORCELAIN', '元代', '征集购藏',
  'LOC_A', 'COMPLETE', 'OUTBOUND_PENDING', '二级', '防震托架单件存放，避免温差突变与硬物碰撞。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-02 09:53:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-02 11:23:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0119' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '元代影青碗-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-03-02 11:53:00', @seed_admin_id, '2025-03-02 11:53:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0119' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '元代影青碗-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '元代影青碗-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-03-02 11:58:00', @seed_admin_id, '2025-03-02 11:58:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0119' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '元代影青碗-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0120', '清代花鸟手卷', 'PAINTING_CALLIGRAPHY', 'SILK', '清代', '馆际征集',
  'LOC_B', 'COMPLETE', 'OUTBOUND_PENDING', '三级', '平铺或悬挂缓释支撑，避光防尘，控制湿度波动。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-04 10:00:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-04 11:30:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0120' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代花鸟手卷-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-03-04 12:00:00', @seed_admin_id, '2025-03-04 12:00:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0120' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代花鸟手卷-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代花鸟手卷-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-03-04 12:05:00', @seed_admin_id, '2025-03-04 12:05:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0120' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代花鸟手卷-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0121', '汉代素面带钩', 'JADE_ARTIFACT', 'JADE', '汉代', '社会捐赠',
  'LOC_B', 'BASIC_COMPLETE', 'OUT_STOCK', '三级', '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-06 11:07:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-06 12:37:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0121' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '汉代素面带钩-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-03-06 13:07:00', @seed_admin_id, '2025-03-06 13:07:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0121' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '汉代素面带钩-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '汉代素面带钩-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-03-06 13:12:00', @seed_admin_id, '2025-03-06 13:12:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0121' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '汉代素面带钩-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '汉代素面带钩-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-03-06 13:17:00', @seed_admin_id, '2025-03-06 13:17:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0121' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '汉代素面带钩-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0122', '清代掐丝带扣', 'GOLD_SILVER_WARE', 'SILVER', '清代', '旧藏整理',
  'EXHIBIT_HALL_1', 'COMPLETE', 'OUT_STOCK', '一级', '干燥密闭保存，配合防氧化材料，减少表面发黑。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-08 12:14:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-08 13:44:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0122' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代掐丝带扣-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-03-08 14:14:00', @seed_admin_id, '2025-03-08 14:14:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0122' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代掐丝带扣-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代掐丝带扣-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-03-08 14:19:00', @seed_admin_id, '2025-03-08 14:19:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0122' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代掐丝带扣-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0123', '清代描金香几', 'WOOD', 'BAMBOO_WOOD', '清代', '馆际调拨',
  'LOC_B', 'COMPLETE', 'OUT_STOCK', '二级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-10 13:21:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-10 14:51:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0123' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代描金香几-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-03-10 15:21:00', @seed_admin_id, '2025-03-10 15:21:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0123' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代描金香几-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代描金香几-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-03-10 15:26:00', @seed_admin_id, '2025-03-10 15:26:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0123' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代描金香几-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0124', '明代戗金漆盒', 'LACQUER', 'LACQUER_WOOD', '明代', '社会捐赠',
  'LOC_B', 'BASIC_COMPLETE', 'OUT_STOCK', '一级', '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-12 14:28:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-12 15:58:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0124' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代戗金漆盒-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-03-12 16:28:00', @seed_admin_id, '2025-03-12 16:28:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0124' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代戗金漆盒-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代戗金漆盒-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-03-12 16:33:00', @seed_admin_id, '2025-03-12 16:33:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0124' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代戗金漆盒-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '明代戗金漆盒-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-03-12 16:38:00', @seed_admin_id, '2025-03-12 16:38:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0124' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '明代戗金漆盒-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0125', '北魏莲花座坐像', 'STONE', 'STONE', '北魏', '寺院征集',
  'EXHIBIT_HALL_1', 'BASIC_COMPLETE', 'OUT_STOCK', '一级', '独立底座承托，控制展柜粉尘和局部潮气。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-14 15:35:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-14 17:05:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0125' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '北魏莲花座坐像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-03-14 17:35:00', @seed_admin_id, '2025-03-14 17:35:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0125' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '北魏莲花座坐像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '北魏莲花座坐像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-03-14 17:40:00', @seed_admin_id, '2025-03-14 17:40:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0125' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '北魏莲花座坐像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0126', '宋代编联卷册', 'BAMBOO', 'BAMBOO_WOOD', '宋代', '馆际征集',
  'LOC_A', 'BASIC_COMPLETE', 'OUT_STOCK', '二级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-16 09:42:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-16 11:12:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0126' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '宋代编联卷册-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-03-16 11:42:00', @seed_admin_id, '2025-03-16 11:42:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0126' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '宋代编联卷册-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '宋代编联卷册-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-03-16 11:47:00', @seed_admin_id, '2025-03-16 11:47:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0126' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '宋代编联卷册-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0127', '春秋铭文带钩', 'BRONZE_WARE', 'BRONZE', '春秋', '馆际征集',
  'LOC_B', 'COMPLETE', 'OUT_STOCK', '三级', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-18 10:49:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-18 12:19:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0127' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '春秋铭文带钩-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-03-18 12:49:00', @seed_admin_id, '2025-03-18 12:49:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0127' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '春秋铭文带钩-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '春秋铭文带钩-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-03-18 12:54:00', @seed_admin_id, '2025-03-18 12:54:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0127' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '春秋铭文带钩-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '春秋铭文带钩-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-03-18 12:59:00', @seed_admin_id, '2025-03-18 12:59:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0127' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '春秋铭文带钩-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0128', '宋代印花香炉', 'CERAMIC', 'CLAY', '宋代', '征集购藏',
  'LOC_A', 'BASIC_COMPLETE', 'OUT_STOCK', '一般', '低震动环境保存，配合缓冲支撑，防止胎体继续开裂。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-20 11:56:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-20 13:26:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0128' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '宋代印花香炉-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-03-20 13:56:00', @seed_admin_id, '2025-03-20 13:56:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0128' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '宋代印花香炉-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '宋代印花香炉-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-03-20 14:01:00', @seed_admin_id, '2025-03-20 14:01:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0128' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '宋代印花香炉-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0129', '元代行书手卷', 'PAINTING_CALLIGRAPHY', 'PAPER', '元代', '社会捐赠',
  'LOC_C', 'COMPLETE', 'OUT_STOCK', '二级', '避光平放，温度18至20度，相对湿度50%至55%，减少酸化风险。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-22 12:03:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-22 13:33:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0129' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '元代行书手卷-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-03-22 14:03:00', @seed_admin_id, '2025-03-22 14:03:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0129' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '元代行书手卷-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '元代行书手卷-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-03-22 14:08:00', @seed_admin_id, '2025-03-22 14:08:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0129' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '元代行书手卷-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0130', '新石器时代云龙纹玉佩', 'JADE_ARTIFACT', 'JADE', '新石器时代', '馆际调拨',
  'LOC_B', 'COMPLETE', 'OUT_STOCK', '一级', '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-24 13:10:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-24 14:40:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0130' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '新石器时代云龙纹玉佩-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-03-24 15:10:00', @seed_admin_id, '2025-03-24 15:10:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0130' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '新石器时代云龙纹玉佩-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '新石器时代云龙纹玉佩-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-03-24 15:15:00', @seed_admin_id, '2025-03-24 15:15:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0130' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '新石器时代云龙纹玉佩-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '新石器时代云龙纹玉佩-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-03-24 15:20:00', @seed_admin_id, '2025-03-24 15:20:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0130' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '新石器时代云龙纹玉佩-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0131', '唐代掐丝冠饰', 'GOLD_SILVER_WARE', 'SILVER', '唐代', '旧藏整理',
  'LOC_C', 'COMPLETE', 'OUT_STOCK', '一级', '干燥密闭保存，配合防氧化材料，减少表面发黑。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-26 14:17:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-26 15:47:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0131' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '唐代掐丝冠饰-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-03-26 16:17:00', @seed_admin_id, '2025-03-26 16:17:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0131' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '唐代掐丝冠饰-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '唐代掐丝冠饰-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-03-26 16:22:00', @seed_admin_id, '2025-03-26 16:22:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0131' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '唐代掐丝冠饰-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0132', '明代描金供案', 'WOOD', 'BAMBOO_WOOD', '明代', '社会捐赠',
  'LOC_C', 'COMPLETE', 'OUT_STOCK', '三级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-28 15:24:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-28 16:54:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0132' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代描金供案-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-03-28 17:24:00', @seed_admin_id, '2025-03-28 17:24:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0132' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代描金供案-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代描金供案-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-03-28 17:29:00', @seed_admin_id, '2025-03-28 17:29:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0132' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代描金供案-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0133', '战国戗金漆盘', 'LACQUER', 'LACQUER_WOOD', '战国', '社会捐赠',
  'LOC_C', 'BASIC_COMPLETE', 'OUT_STOCK', '一般', '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-30 09:31:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-30 11:01:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0133' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '战国戗金漆盘-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-03-30 11:31:00', @seed_admin_id, '2025-03-30 11:31:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0133' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '战国戗金漆盘-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '战国戗金漆盘-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-03-30 11:36:00', @seed_admin_id, '2025-03-30 11:36:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0133' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '战国戗金漆盘-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '战国戗金漆盘-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-03-30 11:41:00', @seed_admin_id, '2025-03-30 11:41:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0133' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '战国戗金漆盘-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0134', '唐代菩萨立像', 'STONE', 'STONE', '唐代', '考古发掘入藏',
  'LOC_C', 'COMPLETE', 'OUT_STOCK', '三级', '独立底座承托，控制展柜粉尘和局部潮气。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-01 10:38:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-01 12:08:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0134' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '唐代菩萨立像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-04-01 12:38:00', @seed_admin_id, '2025-04-01 12:38:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0134' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '唐代菩萨立像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '唐代菩萨立像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-04-01 12:43:00', @seed_admin_id, '2025-04-01 12:43:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0134' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '唐代菩萨立像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0135', '汉代墨书册页', 'BAMBOO', 'BAMBOO_WOOD', '汉代', '学术移交',
  'LOC_B', 'COMPLETE', 'OUT_STOCK', '一级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-03 11:45:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-03 13:15:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0135' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '汉代墨书册页-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-04-03 13:45:00', @seed_admin_id, '2025-04-03 13:45:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0135' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '汉代墨书册页-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '汉代墨书册页-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-04-03 13:50:00', @seed_admin_id, '2025-04-03 13:50:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0135' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '汉代墨书册页-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0136', '战国云雷纹带钩', 'BRONZE_WARE', 'BRONZE', '战国', '考古发掘入藏',
  'LOC_D', 'BIOLOGICAL_DISEASE', 'IN_REPAIR', '一般', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '注意霉斑、虫蛀等病害复发，需定期检查。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-05 12:52:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-05 14:22:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0136' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '战国云雷纹带钩-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-04-05 14:52:00', @seed_admin_id, '2025-04-05 14:52:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0136' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '战国云雷纹带钩-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '战国云雷纹带钩-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-04-05 14:57:00', @seed_admin_id, '2025-04-05 14:57:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0136' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '战国云雷纹带钩-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '战国云雷纹带钩-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-04-05 15:02:00', @seed_admin_id, '2025-04-05 15:02:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0136' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '战国云雷纹带钩-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0137', '元代粉彩香炉', 'CERAMIC', 'CLAY', '元代', '考古发掘入藏',
  'LOC_D', 'PHYSICAL_DAMAGE', 'IN_REPAIR', '二级', '低震动环境保存，配合缓冲支撑，防止胎体继续开裂。',
  '存在裂缝或断口，禁止直接陈列与频繁移动。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-07 13:59:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-07 15:29:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0137' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '元代粉彩香炉-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-04-07 15:59:00', @seed_admin_id, '2025-04-07 15:59:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0137' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '元代粉彩香炉-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '元代粉彩香炉-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-04-07 16:04:00', @seed_admin_id, '2025-04-07 16:04:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0137' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '元代粉彩香炉-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0138', '清代墨竹册页', 'PAINTING_CALLIGRAPHY', 'PAPER', '清代', '社会捐赠',
  'RESTORATION_ROOM', 'BIOLOGICAL_DISEASE', 'IN_REPAIR', '三级', '避光平放，温度18至20度，相对湿度50%至55%，减少酸化风险。',
  '注意霉斑、虫蛀等病害复发，需定期检查。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-09 14:06:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-09 15:36:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0138' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代墨竹册页-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-04-09 16:06:00', @seed_admin_id, '2025-04-09 16:06:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0138' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代墨竹册页-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代墨竹册页-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-04-09 16:11:00', @seed_admin_id, '2025-04-09 16:11:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0138' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代墨竹册页-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0139', '新石器时代云龙纹玉圭', 'JADE_ARTIFACT', 'JADE', '新石器时代', '考古发掘入藏',
  'RESTORATION_ROOM', 'INCOMPLETE', 'IN_REPAIR', '三级', '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-11 15:13:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-11 16:43:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0139' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '新石器时代云龙纹玉圭-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-04-11 17:13:00', @seed_admin_id, '2025-04-11 17:13:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0139' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '新石器时代云龙纹玉圭-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '新石器时代云龙纹玉圭-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-04-11 17:18:00', @seed_admin_id, '2025-04-11 17:18:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0139' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '新石器时代云龙纹玉圭-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '新石器时代云龙纹玉圭-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-04-11 17:23:00', @seed_admin_id, '2025-04-11 17:23:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0139' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '新石器时代云龙纹玉圭-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0140', '唐代錾花银盘', 'GOLD_SILVER_WARE', 'GOLD', '唐代', '馆际征集',
  'RESTORATION_ROOM', 'FRAGMENTED', 'IN_REPAIR', '二级', '恒温低湿保存，避免与含硫物质长期接触。',
  '残碎件较多，需分件编号和托盘存放。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-13 09:20:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-13 10:50:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0140' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '唐代錾花银盘-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-04-13 11:20:00', @seed_admin_id, '2025-04-13 11:20:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0140' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '唐代錾花银盘-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '唐代錾花银盘-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-04-13 11:25:00', @seed_admin_id, '2025-04-13 11:25:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0140' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '唐代錾花银盘-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0141', '民国黄花梨佛像', 'WOOD', 'WOOD', '民国', '社会捐赠',
  'RESTORATION_ROOM', 'INCOMPLETE', 'IN_REPAIR', '一级', '恒温恒湿环境保存，避免直射光和虫蛀滋生。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-15 10:27:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-15 11:57:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0141' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '民国黄花梨佛像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-04-15 12:27:00', @seed_admin_id, '2025-04-15 12:27:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0141' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '民国黄花梨佛像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '民国黄花梨佛像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-04-15 12:32:00', @seed_admin_id, '2025-04-15 12:32:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0141' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '民国黄花梨佛像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0142', '汉代黑漆漆壶', 'LACQUER', 'LACQUER_WOOD', '汉代', '征集购藏',
  'RESTORATION_ROOM', 'INCOMPLETE', 'IN_REPAIR', '三级', '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-17 11:34:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-17 13:04:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0142' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '汉代黑漆漆壶-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-04-17 13:34:00', @seed_admin_id, '2025-04-17 13:34:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0142' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '汉代黑漆漆壶-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '汉代黑漆漆壶-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-04-17 13:39:00', @seed_admin_id, '2025-04-17 13:39:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0142' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '汉代黑漆漆壶-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '汉代黑漆漆壶-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-04-17 13:44:00', @seed_admin_id, '2025-04-17 13:44:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0142' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '汉代黑漆漆壶-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0143', '北魏莲花座供养人像', 'STONE', 'STONE', '北魏', '考古发掘入藏',
  'RESTORATION_ROOM', 'FRAGMENTED', 'IN_REPAIR', '二级', '独立底座承托，控制展柜粉尘和局部潮气。',
  '残碎件较多，需分件编号和托盘存放。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-19 12:41:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-19 14:11:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0143' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '北魏莲花座供养人像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-04-19 14:41:00', @seed_admin_id, '2025-04-19 14:41:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0143' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '北魏莲花座供养人像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '北魏莲花座供养人像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-04-19 14:46:00', @seed_admin_id, '2025-04-19 14:46:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0143' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '北魏莲花座供养人像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0144', '战国漆书卷册', 'BAMBOO', 'BAMBOO_WOOD', '战国', '考古发掘入藏',
  'LOC_D', 'BIOLOGICAL_DISEASE', 'IN_REPAIR', '二级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '注意霉斑、虫蛀等病害复发，需定期检查。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-21 13:48:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-21 15:18:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0144' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '战国漆书卷册-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-04-21 15:48:00', @seed_admin_id, '2025-04-21 15:48:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0144' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '战国漆书卷册-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '战国漆书卷册-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-04-21 15:53:00', @seed_admin_id, '2025-04-21 15:53:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0144' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '战国漆书卷册-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0145', '战国蟠螭纹镜', 'BRONZE_WARE', 'BRONZE', '战国', '馆际征集',
  'LOC_D', 'SEVERE_INCOMPLETE', 'IN_REPAIR', '一级', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '结构脆弱，原则上仅允许修复评估与专项查看。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-23 14:55:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-23 16:25:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0145' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '战国蟠螭纹镜-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-04-23 16:55:00', @seed_admin_id, '2025-04-23 16:55:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0145' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '战国蟠螭纹镜-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '战国蟠螭纹镜-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-04-23 17:00:00', @seed_admin_id, '2025-04-23 17:00:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0145' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '战国蟠螭纹镜-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '战国蟠螭纹镜-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-04-23 17:05:00', @seed_admin_id, '2025-04-23 17:05:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0145' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '战国蟠螭纹镜-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0146', '明代刻花香炉', 'CERAMIC', 'CLAY', '明代', '社会捐赠',
  'RESTORATION_ROOM', 'BIOLOGICAL_DISEASE', 'IN_REPAIR', '二级', '低震动环境保存，配合缓冲支撑，防止胎体继续开裂。',
  '注意霉斑、虫蛀等病害复发，需定期检查。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-25 15:02:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-25 16:32:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0146' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代刻花香炉-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-04-25 17:02:00', @seed_admin_id, '2025-04-25 17:02:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0146' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代刻花香炉-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代刻花香炉-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-04-25 17:07:00', @seed_admin_id, '2025-04-25 17:07:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0146' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代刻花香炉-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0147', '宋代仕女册页', 'PAINTING_CALLIGRAPHY', 'PAPER', '宋代', '馆际征集',
  'RESTORATION_ROOM', 'PHYSICAL_DAMAGE', 'IN_REPAIR', '三级', '避光平放，温度18至20度，相对湿度50%至55%，减少酸化风险。',
  '存在裂缝或断口，禁止直接陈列与频繁移动。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-27 09:09:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-27 10:39:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0147' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '宋代仕女册页-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-04-27 11:09:00', @seed_admin_id, '2025-04-27 11:09:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0147' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '宋代仕女册页-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '宋代仕女册页-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-04-27 11:14:00', @seed_admin_id, '2025-04-27 11:14:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0147' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '宋代仕女册页-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0148', '战国凤鸟纹玉璧', 'JADE_ARTIFACT', 'JADE', '战国', '馆际调拨',
  'LOC_D', 'FRAGMENTED', 'IN_REPAIR', '二级', '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  '残碎件较多，需分件编号和托盘存放。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-29 10:16:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-29 11:46:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0148' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '战国凤鸟纹玉璧-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-04-29 12:16:00', @seed_admin_id, '2025-04-29 12:16:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0148' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '战国凤鸟纹玉璧-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '战国凤鸟纹玉璧-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-04-29 12:21:00', @seed_admin_id, '2025-04-29 12:21:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0148' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '战国凤鸟纹玉璧-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '战国凤鸟纹玉璧-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-04-29 12:26:00', @seed_admin_id, '2025-04-29 12:26:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0148' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '战国凤鸟纹玉璧-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0149', '宋代錾刻执壶', 'GOLD_SILVER_WARE', 'GOLD', '宋代', '社会捐赠',
  'RESTORATION_ROOM', 'FRAGMENTED', 'IN_REPAIR', '三级', '恒温低湿保存，避免与含硫物质长期接触。',
  '残碎件较多，需分件编号和托盘存放。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-01 11:23:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-01 12:53:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0149' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '宋代錾刻执壶-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-05-01 13:23:00', @seed_admin_id, '2025-05-01 13:23:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0149' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '宋代錾刻执壶-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '宋代錾刻执壶-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-05-01 13:28:00', @seed_admin_id, '2025-05-01 13:28:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0149' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '宋代錾刻执壶-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0150', '明代黄花梨经匣', 'WOOD', 'WOOD', '明代', '社会捐赠',
  'RESTORATION_ROOM', 'INCOMPLETE', 'IN_REPAIR', '三级', '恒温恒湿环境保存，避免直射光和虫蛀滋生。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-03 12:30:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-03 14:00:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0150' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代黄花梨经匣-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-05-03 14:30:00', @seed_admin_id, '2025-05-03 14:30:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0150' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代黄花梨经匣-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代黄花梨经匣-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-05-03 14:35:00', @seed_admin_id, '2025-05-03 14:35:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0150' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代黄花梨经匣-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0151', '明代黑漆漆壶', 'LACQUER', 'LACQUER_WOOD', '明代', '征集购藏',
  'LOC_D', 'INCOMPLETE', 'IN_REPAIR', '二级', '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-05 13:37:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-05 15:07:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0151' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代黑漆漆壶-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-05-05 15:37:00', @seed_admin_id, '2025-05-05 15:37:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0151' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代黑漆漆壶-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代黑漆漆壶-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-05-05 15:42:00', @seed_admin_id, '2025-05-05 15:42:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0151' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代黑漆漆壶-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '明代黑漆漆壶-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-05-05 15:47:00', @seed_admin_id, '2025-05-05 15:47:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0151' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '明代黑漆漆壶-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0152', '唐代造像碑立像', 'STONE', 'STONE', '唐代', '馆际移交',
  'LOC_D', 'BIOLOGICAL_DISEASE', 'IN_REPAIR', '二级', '独立底座承托，控制展柜粉尘和局部潮气。',
  '注意霉斑、虫蛀等病害复发，需定期检查。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-07 14:44:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-07 16:14:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0152' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '唐代造像碑立像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-05-07 16:44:00', @seed_admin_id, '2025-05-07 16:44:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0152' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '唐代造像碑立像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '唐代造像碑立像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-05-07 16:49:00', @seed_admin_id, '2025-05-07 16:49:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0152' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '唐代造像碑立像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0153', '汉代漆书卷册', 'BAMBOO', 'BAMBOO_WOOD', '汉代', '馆际征集',
  'LOC_D', 'BIOLOGICAL_DISEASE', 'IN_REPAIR', '一级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '注意霉斑、虫蛀等病害复发，需定期检查。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-09 15:51:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-09 17:21:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0153' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '汉代漆书卷册-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-05-09 17:51:00', @seed_admin_id, '2025-05-09 17:51:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0153' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '汉代漆书卷册-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '汉代漆书卷册-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-05-09 17:56:00', @seed_admin_id, '2025-05-09 17:56:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0153' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '汉代漆书卷册-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0154', '春秋蟠螭纹镜', 'BRONZE_WARE', 'BRONZE', '春秋', '旧藏整理',
  'LOC_C', 'BIOLOGICAL_DISEASE', 'IN_STOCK', '一般', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '注意霉斑、虫蛀等病害复发，需定期检查。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-11 09:58:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-11 11:28:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0154' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '春秋蟠螭纹镜-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-05-11 11:58:00', @seed_admin_id, '2025-05-11 11:58:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0154' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '春秋蟠螭纹镜-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '春秋蟠螭纹镜-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-05-11 12:03:00', @seed_admin_id, '2025-05-11 12:03:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0154' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '春秋蟠螭纹镜-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '春秋蟠螭纹镜-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-05-11 12:08:00', @seed_admin_id, '2025-05-11 12:08:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0154' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '春秋蟠螭纹镜-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0155', '民国青花罐', 'CERAMIC', 'CLAY', '民国', '考古发掘入藏',
  'STORAGE_ROOM_3', 'BIOLOGICAL_DISEASE', 'IN_STOCK', '一级', '低震动环境保存，配合缓冲支撑，防止胎体继续开裂。',
  '注意霉斑、虫蛀等病害复发，需定期检查。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-13 10:05:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-13 11:35:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0155' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '民国青花罐-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-05-13 12:05:00', @seed_admin_id, '2025-05-13 12:05:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0155' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '民国青花罐-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '民国青花罐-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-05-13 12:10:00', @seed_admin_id, '2025-05-13 12:10:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0155' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '民国青花罐-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0156', '元代墨竹立轴', 'PAINTING_CALLIGRAPHY', 'PAPER', '元代', '社会捐赠',
  'LOC_B', 'SEVERE_INCOMPLETE', 'IN_STOCK', '二级', '避光平放，温度18至20度，相对湿度50%至55%，减少酸化风险。',
  '结构脆弱，原则上仅允许修复评估与专项查看。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-15 11:12:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-15 12:42:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0156' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '元代墨竹立轴-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-05-15 13:12:00', @seed_admin_id, '2025-05-15 13:12:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0156' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '元代墨竹立轴-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '元代墨竹立轴-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-05-15 13:17:00', @seed_admin_id, '2025-05-15 13:17:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0156' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '元代墨竹立轴-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0157', '商代螭龙纹玉琮', 'JADE_ARTIFACT', 'JADE', '商代', '社会捐赠',
  'LOC_B', 'PHYSICAL_DAMAGE', 'IN_STOCK', '三级', '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  '存在裂缝或断口，禁止直接陈列与频繁移动。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-17 12:19:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-17 13:49:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0157' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '商代螭龙纹玉琮-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-05-17 14:19:00', @seed_admin_id, '2025-05-17 14:19:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0157' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '商代螭龙纹玉琮-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '商代螭龙纹玉琮-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-05-17 14:24:00', @seed_admin_id, '2025-05-17 14:24:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0157' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '商代螭龙纹玉琮-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '商代螭龙纹玉琮-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-05-17 14:29:00', @seed_admin_id, '2025-05-17 14:29:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0157' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '商代螭龙纹玉琮-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0158', '清代錾刻银盘', 'GOLD_SILVER_WARE', 'SILVER', '清代', '社会捐赠',
  'LOC_C', 'BIOLOGICAL_DISEASE', 'IN_STOCK', '三级', '干燥密闭保存，配合防氧化材料，减少表面发黑。',
  '注意霉斑、虫蛀等病害复发，需定期检查。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-19 13:26:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-19 14:56:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0158' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代錾刻银盘-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-05-19 15:26:00', @seed_admin_id, '2025-05-19 15:26:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0158' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代錾刻银盘-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代錾刻银盘-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-05-19 15:31:00', @seed_admin_id, '2025-05-19 15:31:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0158' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代錾刻银盘-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0159', '民国描金佛像', 'WOOD', 'BAMBOO_WOOD', '民国', '寺院征集',
  'LOC_D', 'PHYSICAL_DAMAGE', 'IN_STOCK', '一般', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '存在裂缝或断口，禁止直接陈列与频繁移动。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-21 14:33:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-21 16:03:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0159' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '民国描金佛像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-05-21 16:33:00', @seed_admin_id, '2025-05-21 16:33:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0159' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '民国描金佛像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '民国描金佛像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-05-21 16:38:00', @seed_admin_id, '2025-05-21 16:38:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0159' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '民国描金佛像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0160', '汉代黑漆漆壶', 'LACQUER', 'LACQUER_WOOD', '汉代', '征集购藏',
  'LOC_D', 'BIOLOGICAL_DISEASE', 'IN_STOCK', '三级', '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  '注意霉斑、虫蛀等病害复发，需定期检查。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-23 15:40:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-23 17:10:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0160' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '汉代黑漆漆壶-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-05-23 17:40:00', @seed_admin_id, '2025-05-23 17:40:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0160' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '汉代黑漆漆壶-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '汉代黑漆漆壶-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-05-23 17:45:00', @seed_admin_id, '2025-05-23 17:45:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0160' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '汉代黑漆漆壶-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '汉代黑漆漆壶-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-05-23 17:50:00', @seed_admin_id, '2025-05-23 17:50:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0160' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '汉代黑漆漆壶-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0161', '北魏佛首立像', 'STONE', 'STONE', '北魏', '考古发掘入藏',
  'LOC_D', 'CHEMICAL_DEGRADATION', 'IN_STOCK', '一般', '独立底座承托，控制展柜粉尘和局部潮气。',
  '需重点监测表面腐蚀、粉化或漆层脱落。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-25 09:47:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-25 11:17:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0161' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '北魏佛首立像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-05-25 11:47:00', @seed_admin_id, '2025-05-25 11:47:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0161' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '北魏佛首立像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '北魏佛首立像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-05-25 11:52:00', @seed_admin_id, '2025-05-25 11:52:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0161' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '北魏佛首立像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0162', '明代编联册页', 'BAMBOO', 'BAMBOO_WOOD', '明代', '馆际征集',
  'STORAGE_ROOM_3', 'FRAGMENTED', 'IN_STOCK', '三级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '残碎件较多，需分件编号和托盘存放。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-27 10:54:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-27 12:24:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0162' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代编联册页-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-05-27 12:54:00', @seed_admin_id, '2025-05-27 12:54:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0162' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代编联册页-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代编联册页-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-05-27 12:59:00', @seed_admin_id, '2025-05-27 12:59:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0162' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代编联册页-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0163', '战国错金银带钩', 'BRONZE_WARE', 'BRONZE', '战国', '考古发掘入藏',
  'STORAGE_ROOM_3', 'FRAGMENTED', 'IN_STOCK', '一级', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '残碎件较多，需分件编号和托盘存放。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-29 11:01:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-29 12:31:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0163' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '战国错金银带钩-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-05-29 13:01:00', @seed_admin_id, '2025-05-29 13:01:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0163' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '战国错金银带钩-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '战国错金银带钩-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-05-29 13:06:00', @seed_admin_id, '2025-05-29 13:06:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0163' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '战国错金银带钩-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '战国错金银带钩-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-05-29 13:11:00', @seed_admin_id, '2025-05-29 13:11:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0163' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '战国错金银带钩-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0164', '唐代刻花梅瓶', 'CERAMIC', 'PORCELAIN', '唐代', '社会捐赠',
  'LOC_B', 'PHYSICAL_DAMAGE', 'IN_STOCK', '一般', '防震托架单件存放，避免温差突变与硬物碰撞。',
  '存在裂缝或断口，禁止直接陈列与频繁移动。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-31 12:08:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-31 13:38:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0164' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '唐代刻花梅瓶-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-05-31 14:08:00', @seed_admin_id, '2025-05-31 14:08:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0164' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '唐代刻花梅瓶-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '唐代刻花梅瓶-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-05-31 14:13:00', @seed_admin_id, '2025-05-31 14:13:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0164' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '唐代刻花梅瓶-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0165', '清代仕女手卷', 'PAINTING_CALLIGRAPHY', 'PAPER', '清代', '社会捐赠',
  'LOC_B', 'PHYSICAL_DAMAGE', 'IN_STOCK', '一般', '避光平放，温度18至20度，相对湿度50%至55%，减少酸化风险。',
  '存在裂缝或断口，禁止直接陈列与频繁移动。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-02 13:15:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-02 14:45:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0165' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代仕女手卷-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-06-02 15:15:00', @seed_admin_id, '2025-06-02 15:15:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0165' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代仕女手卷-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代仕女手卷-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-06-02 15:20:00', @seed_admin_id, '2025-06-02 15:20:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0165' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代仕女手卷-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0166', '商代素面玉璧', 'JADE_ARTIFACT', 'JADE', '商代', '社会捐赠',
  'LOC_C', 'BIOLOGICAL_DISEASE', 'IN_STOCK', '一般', '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  '注意霉斑、虫蛀等病害复发，需定期检查。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-04 14:22:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-04 15:52:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0166' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '商代素面玉璧-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-06-04 16:22:00', @seed_admin_id, '2025-06-04 16:22:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0166' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '商代素面玉璧-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '商代素面玉璧-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-06-04 16:27:00', @seed_admin_id, '2025-06-04 16:27:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0166' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '商代素面玉璧-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '商代素面玉璧-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-06-04 16:32:00', @seed_admin_id, '2025-06-04 16:32:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0166' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '商代素面玉璧-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0167', '宋代錾刻带扣', 'GOLD_SILVER_WARE', 'SILVER', '宋代', '旧藏整理',
  'STORAGE_ROOM_3', 'CHEMICAL_DEGRADATION', 'IN_STOCK', '三级', '干燥密闭保存，配合防氧化材料，减少表面发黑。',
  '需重点监测表面腐蚀、粉化或漆层脱落。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-06 15:29:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-06 16:59:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0167' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '宋代錾刻带扣-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-06-06 17:29:00', @seed_admin_id, '2025-06-06 17:29:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0167' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '宋代錾刻带扣-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '宋代錾刻带扣-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-06-06 17:34:00', @seed_admin_id, '2025-06-06 17:34:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0167' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '宋代錾刻带扣-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0168', '清代描金佛像', 'WOOD', 'WOOD', '清代', '馆际调拨',
  'LOC_D', 'SEVERE_INCOMPLETE', 'IN_STOCK', '三级', '恒温恒湿环境保存，避免直射光和虫蛀滋生。',
  '结构脆弱，原则上仅允许修复评估与专项查看。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-08 09:36:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-08 11:06:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0168' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代描金佛像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-06-08 11:36:00', @seed_admin_id, '2025-06-08 11:36:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0168' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代描金佛像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代描金佛像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-06-08 11:41:00', @seed_admin_id, '2025-06-08 11:41:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0168' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代描金佛像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0169', '民国剔红漆盘', 'LACQUER', 'LACQUER_WOOD', '民国', '征集购藏',
  'LOC_B', 'INCOMPLETE', 'IN_STOCK', '一级', '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-10 10:43:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-10 12:13:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0169' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '民国剔红漆盘-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-06-10 12:43:00', @seed_admin_id, '2025-06-10 12:43:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0169' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '民国剔红漆盘-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '民国剔红漆盘-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-06-10 12:48:00', @seed_admin_id, '2025-06-10 12:48:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0169' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '民国剔红漆盘-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '民国剔红漆盘-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-06-10 12:53:00', @seed_admin_id, '2025-06-10 12:53:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0169' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '民国剔红漆盘-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0170', '北魏莲花座石刻残件', 'STONE', 'STONE', '北魏', '考古发掘入藏',
  'LOC_C', 'BIOLOGICAL_DISEASE', 'IN_STOCK', '二级', '独立底座承托，控制展柜粉尘和局部潮气。',
  '注意霉斑、虫蛀等病害复发，需定期检查。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-12 11:50:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-12 13:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0170' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '北魏莲花座石刻残件-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-06-12 13:50:00', @seed_admin_id, '2025-06-12 13:50:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0170' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '北魏莲花座石刻残件-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '北魏莲花座石刻残件-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-06-12 13:55:00', @seed_admin_id, '2025-06-12 13:55:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0170' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '北魏莲花座石刻残件-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0171', '宋代编联竹简', 'BAMBOO', 'BAMBOO_WOOD', '宋代', '馆际征集',
  'EXHIBIT_HALL_1', 'COMPLETE', 'IN_STOCK', '一般', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-14 12:57:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-14 14:27:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0171' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '宋代编联竹简-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-06-14 14:57:00', @seed_admin_id, '2025-06-14 14:57:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0171' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '宋代编联竹简-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '宋代编联竹简-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-06-14 15:02:00', @seed_admin_id, '2025-06-14 15:02:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0171' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '宋代编联竹简-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0172', '汉代云雷纹带钩', 'BRONZE_WARE', 'BRONZE', '汉代', '馆际征集',
  'LOC_A', 'BASIC_COMPLETE', 'IN_STOCK', '三级', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-16 13:04:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-16 14:34:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0172' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '汉代云雷纹带钩-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-06-16 15:04:00', @seed_admin_id, '2025-06-16 15:04:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0172' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '汉代云雷纹带钩-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '汉代云雷纹带钩-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-06-16 15:09:00', @seed_admin_id, '2025-06-16 15:09:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0172' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '汉代云雷纹带钩-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '汉代云雷纹带钩-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-06-16 15:14:00', @seed_admin_id, '2025-06-16 15:14:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0172' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '汉代云雷纹带钩-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0173', '元代粉彩香炉', 'CERAMIC', 'CLAY', '元代', '征集购藏',
  'EXHIBIT_HALL_1', 'BASIC_COMPLETE', 'IN_STOCK', '三级', '低震动环境保存，配合缓冲支撑，防止胎体继续开裂。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-18 14:11:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-18 15:41:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0173' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '元代粉彩香炉-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-06-18 16:11:00', @seed_admin_id, '2025-06-18 16:11:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0173' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '元代粉彩香炉-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '元代粉彩香炉-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-06-18 16:16:00', @seed_admin_id, '2025-06-18 16:16:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0173' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '元代粉彩香炉-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0174', '元代花鸟手卷', 'PAINTING_CALLIGRAPHY', 'SILK', '元代', '社会捐赠',
  'LOC_A', 'BASIC_COMPLETE', 'IN_STOCK', '一级', '平铺或悬挂缓释支撑，避光防尘，控制湿度波动。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-20 15:18:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-20 16:48:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0174' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '元代花鸟手卷-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-06-20 17:18:00', @seed_admin_id, '2025-06-20 17:18:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0174' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '元代花鸟手卷-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '元代花鸟手卷-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-06-20 17:23:00', @seed_admin_id, '2025-06-20 17:23:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0174' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '元代花鸟手卷-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0175', '商代谷纹带钩', 'JADE_ARTIFACT', 'JADE', '商代', '考古发掘入藏',
  'EXHIBIT_HALL_1', 'COMPLETE', 'IN_STOCK', '二级', '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-22 09:25:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-22 10:55:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0175' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '商代谷纹带钩-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-06-22 11:25:00', @seed_admin_id, '2025-06-22 11:25:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0175' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '商代谷纹带钩-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '商代谷纹带钩-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-06-22 11:30:00', @seed_admin_id, '2025-06-22 11:30:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0175' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '商代谷纹带钩-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '商代谷纹带钩-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-06-22 11:35:00', @seed_admin_id, '2025-06-22 11:35:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0175' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '商代谷纹带钩-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0176', '清代掐丝香囊', 'GOLD_SILVER_WARE', 'GOLD', '清代', '社会捐赠',
  'LOC_B', 'SEVERE_INCOMPLETE', 'IN_STOCK', '一般', '恒温低湿保存，避免与含硫物质长期接触。',
  '结构脆弱，原则上仅允许修复评估与专项查看。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-24 10:32:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-24 12:02:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0176' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '清代掐丝香囊-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-06-24 12:32:00', @seed_admin_id, '2025-06-24 12:32:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0176' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '清代掐丝香囊-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '清代掐丝香囊-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-06-24 12:37:00', @seed_admin_id, '2025-06-24 12:37:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0176' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '清代掐丝香囊-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0177', '民国描金香几', 'WOOD', 'BAMBOO_WOOD', '民国', '社会捐赠',
  'STORAGE_ROOM_3', 'CHEMICAL_DEGRADATION', 'IN_STOCK', '三级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '需重点监测表面腐蚀、粉化或漆层脱落。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-26 11:39:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-26 13:09:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0177' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '民国描金香几-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-06-26 13:39:00', @seed_admin_id, '2025-06-26 13:39:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0177' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '民国描金香几-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '民国描金香几-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-06-26 13:44:00', @seed_admin_id, '2025-06-26 13:44:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0177' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '民国描金香几-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0178', '汉代剔红漆盒', 'LACQUER', 'LACQUER_WOOD', '汉代', '社会捐赠',
  'STORAGE_ROOM_3', 'BIOLOGICAL_DISEASE', 'IN_STOCK', '二级', '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  '注意霉斑、虫蛀等病害复发，需定期检查。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-28 12:46:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-28 14:16:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0178' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '汉代剔红漆盒-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-06-28 14:46:00', @seed_admin_id, '2025-06-28 14:46:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0178' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '汉代剔红漆盒-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '汉代剔红漆盒-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-06-28 14:51:00', @seed_admin_id, '2025-06-28 14:51:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0178' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '汉代剔红漆盒-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '汉代剔红漆盒-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-06-28 14:56:00', @seed_admin_id, '2025-06-28 14:56:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0178' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '汉代剔红漆盒-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0179', '宋代造像碑供养人像', 'STONE', 'STONE', '宋代', '考古发掘入藏',
  'LOC_B', 'PHYSICAL_DAMAGE', 'IN_STOCK', '三级', '独立底座承托，控制展柜粉尘和局部潮气。',
  '存在裂缝或断口，禁止直接陈列与频繁移动。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-30 13:53:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-30 15:23:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0179' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '宋代造像碑供养人像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-06-30 15:53:00', @seed_admin_id, '2025-06-30 15:53:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0179' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '宋代造像碑供养人像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '宋代造像碑供养人像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-06-30 15:58:00', @seed_admin_id, '2025-06-30 15:58:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0179' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '宋代造像碑供养人像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0180', '明代编联竹简', 'BAMBOO', 'BAMBOO_WOOD', '明代', '学术移交',
  'STORAGE_ROOM_3', 'FRAGMENTED', 'IN_STOCK', '一般', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '残碎件较多，需分件编号和托盘存放。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-02 14:00:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-02 15:30:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0180' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代编联竹简-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-07-02 16:00:00', @seed_admin_id, '2025-07-02 16:00:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0180' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代编联竹简-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代编联竹简-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-07-02 16:05:00', @seed_admin_id, '2025-07-02 16:05:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0180' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代编联竹简-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0181', '西周错金银镜', 'BRONZE_WARE', 'BRONZE', '西周', '旧藏整理',
  'LOC_C', 'INCOMPLETE', 'IN_STOCK', '三级', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-04 15:07:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-04 16:37:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0181' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '西周错金银镜-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-07-04 17:07:00', @seed_admin_id, '2025-07-04 17:07:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0181' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '西周错金银镜-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '西周错金银镜-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-07-04 17:12:00', @seed_admin_id, '2025-07-04 17:12:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0181' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '西周错金银镜-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '西周错金银镜-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-07-04 17:17:00', @seed_admin_id, '2025-07-04 17:17:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0181' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '西周错金银镜-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0182', '唐代刻花盘口壶', 'CERAMIC', 'PORCELAIN', '唐代', '考古发掘入藏',
  'EXHIBIT_HALL_1', 'INCOMPLETE', 'IN_STOCK', '一般', '防震托架单件存放，避免温差突变与硬物碰撞。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-06 09:14:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-06 10:44:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0182' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '唐代刻花盘口壶-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-07-06 11:14:00', @seed_admin_id, '2025-07-06 11:14:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0182' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '唐代刻花盘口壶-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '唐代刻花盘口壶-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-07-06 11:19:00', @seed_admin_id, '2025-07-06 11:19:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0182' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '唐代刻花盘口壶-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0183', '宋代楷书立轴', 'PAINTING_CALLIGRAPHY', 'PAPER', '宋代', '旧藏移交',
  'LOC_C', 'BASIC_COMPLETE', 'IN_STOCK', '二级', '避光平放，温度18至20度，相对湿度50%至55%，减少酸化风险。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-08 10:21:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-08 11:51:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0183' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '宋代楷书立轴-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-07-08 12:21:00', @seed_admin_id, '2025-07-08 12:21:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0183' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '宋代楷书立轴-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '宋代楷书立轴-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-07-08 12:26:00', @seed_admin_id, '2025-07-08 12:26:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0183' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '宋代楷书立轴-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0184', '汉代凤鸟纹带钩', 'JADE_ARTIFACT', 'JADE', '汉代', '考古发掘入藏',
  'LOC_C', 'INCOMPLETE', 'IN_STOCK', '三级', '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-10 11:28:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-10 12:58:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0184' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '汉代凤鸟纹带钩-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-07-10 13:28:00', @seed_admin_id, '2025-07-10 13:28:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0184' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '汉代凤鸟纹带钩-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '汉代凤鸟纹带钩-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-07-10 13:33:00', @seed_admin_id, '2025-07-10 13:33:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0184' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '汉代凤鸟纹带钩-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '汉代凤鸟纹带钩-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-07-10 13:38:00', @seed_admin_id, '2025-07-10 13:38:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0184' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '汉代凤鸟纹带钩-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0185', '唐代錾花银盘', 'GOLD_SILVER_WARE', 'GOLD', '唐代', '社会捐赠',
  'EXHIBIT_HALL_1', 'INCOMPLETE', 'IN_STOCK', '一级', '恒温低湿保存，避免与含硫物质长期接触。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-12 12:35:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-12 14:05:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0185' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '唐代錾花银盘-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-07-12 14:35:00', @seed_admin_id, '2025-07-12 14:35:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0185' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '唐代錾花银盘-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '唐代錾花银盘-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-07-12 14:40:00', @seed_admin_id, '2025-07-12 14:40:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0185' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '唐代錾花银盘-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0186', '明代柏木髹漆佛像', 'WOOD', 'BAMBOO_WOOD', '明代', '社会捐赠',
  'LOC_B', 'COMPLETE', 'IN_STOCK', '一般', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-14 13:42:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-14 15:12:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0186' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代柏木髹漆佛像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-07-14 15:42:00', @seed_admin_id, '2025-07-14 15:42:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0186' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代柏木髹漆佛像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代柏木髹漆佛像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-07-14 15:47:00', @seed_admin_id, '2025-07-14 15:47:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0186' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代柏木髹漆佛像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0187', '战国黑漆漆壶', 'LACQUER', 'LACQUER_WOOD', '战国', '征集购藏',
  'LOC_VIP', 'COMPLETE', 'IN_STOCK', '三级', '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-16 14:49:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-16 16:19:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0187' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '战国黑漆漆壶-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-07-16 16:49:00', @seed_admin_id, '2025-07-16 16:49:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0187' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '战国黑漆漆壶-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '战国黑漆漆壶-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-07-16 16:54:00', @seed_admin_id, '2025-07-16 16:54:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0187' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '战国黑漆漆壶-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '战国黑漆漆壶-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-07-16 16:59:00', @seed_admin_id, '2025-07-16 16:59:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0187' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '战国黑漆漆壶-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0188', '北魏造像碑石刻残件', 'STONE', 'STONE', '北魏', '考古发掘入藏',
  'LOC_A', 'COMPLETE', 'IN_STOCK', '一般', '独立底座承托，控制展柜粉尘和局部潮气。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-18 15:56:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-18 17:26:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0188' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '北魏造像碑石刻残件-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-07-18 17:56:00', @seed_admin_id, '2025-07-18 17:56:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0188' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '北魏造像碑石刻残件-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '北魏造像碑石刻残件-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-07-18 18:01:00', @seed_admin_id, '2025-07-18 18:01:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0188' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '北魏造像碑石刻残件-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0189', '明代简牍竹简', 'BAMBOO', 'BAMBOO_WOOD', '明代', '考古发掘入藏',
  'LOC_VIP', 'INCOMPLETE', 'IN_STOCK', '二级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-20 09:03:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-20 10:33:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0189' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代简牍竹简-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-07-20 11:03:00', @seed_admin_id, '2025-07-20 11:03:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0189' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代简牍竹简-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代简牍竹简-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-07-20 11:08:00', @seed_admin_id, '2025-07-20 11:08:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0189' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代简牍竹简-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0190', '春秋蟠螭纹簋', 'BRONZE_WARE', 'BRONZE', '春秋', '馆际征集',
  'EXHIBIT_HALL_2', 'INCOMPLETE', 'IN_STOCK', '一般', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-22 10:10:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-22 11:40:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0190' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '春秋蟠螭纹簋-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-07-22 12:10:00', @seed_admin_id, '2025-07-22 12:10:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0190' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '春秋蟠螭纹簋-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '春秋蟠螭纹簋-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-07-22 12:15:00', @seed_admin_id, '2025-07-22 12:15:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0190' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '春秋蟠螭纹簋-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '春秋蟠螭纹簋-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-07-22 12:20:00', @seed_admin_id, '2025-07-22 12:20:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0190' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '春秋蟠螭纹簋-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0191', '明代粉彩香炉', 'CERAMIC', 'PORCELAIN', '明代', '社会捐赠',
  'LOC_B', 'INCOMPLETE', 'IN_STOCK', '三级', '防震托架单件存放，避免温差突变与硬物碰撞。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-24 11:17:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-24 12:47:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0191' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代粉彩香炉-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-07-24 13:17:00', @seed_admin_id, '2025-07-24 13:17:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0191' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代粉彩香炉-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代粉彩香炉-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-07-24 13:22:00', @seed_admin_id, '2025-07-24 13:22:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0191' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代粉彩香炉-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0192', '明代墨竹立轴', 'PAINTING_CALLIGRAPHY', 'PAPER', '明代', '馆际征集',
  'EXHIBIT_HALL_2', 'BASIC_COMPLETE', 'IN_STOCK', '二级', '避光平放，温度18至20度，相对湿度50%至55%，减少酸化风险。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-26 12:24:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-26 13:54:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0192' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代墨竹立轴-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-07-26 14:24:00', @seed_admin_id, '2025-07-26 14:24:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0192' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代墨竹立轴-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代墨竹立轴-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-07-26 14:29:00', @seed_admin_id, '2025-07-26 14:29:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0192' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代墨竹立轴-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0193', '商代凤鸟纹玉琮', 'JADE_ARTIFACT', 'JADE', '商代', '社会捐赠',
  'LOC_A', 'INCOMPLETE', 'IN_STOCK', '一级', '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  '局部残缺，调阅与搬运需双人复核。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-28 13:31:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-28 15:01:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0193' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '商代凤鸟纹玉琮-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-07-28 15:31:00', @seed_admin_id, '2025-07-28 15:31:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0193' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '商代凤鸟纹玉琮-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '商代凤鸟纹玉琮-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-07-28 15:36:00', @seed_admin_id, '2025-07-28 15:36:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0193' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '商代凤鸟纹玉琮-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '商代凤鸟纹玉琮-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-07-28 15:41:00', @seed_admin_id, '2025-07-28 15:41:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0193' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '商代凤鸟纹玉琮-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0194', '宋代錾花冠饰', 'GOLD_SILVER_WARE', 'GOLD', '宋代', '社会捐赠',
  'EXHIBIT_HALL_1', 'BASIC_COMPLETE', 'IN_STOCK', '二级', '恒温低湿保存，避免与含硫物质长期接触。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-30 14:38:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-30 16:08:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0194' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '宋代錾花冠饰-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-07-30 16:38:00', @seed_admin_id, '2025-07-30 16:38:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0194' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '宋代錾花冠饰-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '宋代錾花冠饰-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-07-30 16:43:00', @seed_admin_id, '2025-07-30 16:43:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0194' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '宋代錾花冠饰-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0195', '明代紫檀雕花佛像', 'WOOD', 'BAMBOO_WOOD', '明代', '馆际调拨',
  'LOC_B', 'COMPLETE', 'IN_STOCK', '三级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-01 15:45:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-01 17:15:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0195' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代紫檀雕花佛像-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-08-01 17:45:00', @seed_admin_id, '2025-08-01 17:45:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0195' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代紫檀雕花佛像-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代紫檀雕花佛像-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-08-01 17:50:00', @seed_admin_id, '2025-08-01 17:50:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0195' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代紫檀雕花佛像-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0196', '明代朱漆漆盒', 'LACQUER', 'LACQUER_WOOD', '明代', '征集购藏',
  'EXHIBIT_HALL_2', 'BASIC_COMPLETE', 'IN_STOCK', '三级', '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-03 09:52:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-03 11:22:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0196' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '明代朱漆漆盒-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-08-03 11:52:00', @seed_admin_id, '2025-08-03 11:52:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0196' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '明代朱漆漆盒-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '明代朱漆漆盒-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-08-03 11:57:00', @seed_admin_id, '2025-08-03 11:57:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0196' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '明代朱漆漆盒-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '明代朱漆漆盒-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-08-03 12:02:00', @seed_admin_id, '2025-08-03 12:02:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0196' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '明代朱漆漆盒-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0197', '宋代佛首石刻残件', 'STONE', 'STONE', '宋代', '寺院征集',
  'LOC_C', 'COMPLETE', 'IN_STOCK', '二级', '独立底座承托，控制展柜粉尘和局部潮气。',
  '常规巡检即可，适合常设展陈或常规库房管理。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-05 10:59:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-05 12:29:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0197' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '宋代佛首石刻残件-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-08-05 12:59:00', @seed_admin_id, '2025-08-05 12:59:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0197' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '宋代佛首石刻残件-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '宋代佛首石刻残件-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-08-05 13:04:00', @seed_admin_id, '2025-08-05 13:04:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0197' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '宋代佛首石刻残件-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0198', '战国题记木牍', 'BAMBOO', 'BAMBOO_WOOD', '战国', '学术移交',
  'LOC_VIP', 'BASIC_COMPLETE', 'IN_STOCK', '三级', '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-07 11:06:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-07 12:36:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0198' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '战国题记木牍-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-08-07 13:06:00', @seed_admin_id, '2025-08-07 13:06:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0198' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '战国题记木牍-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '战国题记木牍-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-08-07 13:11:00', @seed_admin_id, '2025-08-07 13:11:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0198' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '战国题记木牍-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0199', '春秋蟠螭纹尊', 'BRONZE_WARE', 'BRONZE', '春秋', '馆际征集',
  'LOC_A', 'BASIC_COMPLETE', 'IN_STOCK', '一般', '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-09 12:13:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-09 13:43:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0199' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '春秋蟠螭纹尊-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-08-09 14:13:00', @seed_admin_id, '2025-08-09 14:13:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0199' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '春秋蟠螭纹尊-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '春秋蟠螭纹尊-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-08-09 14:18:00', @seed_admin_id, '2025-08-09 14:18:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0199' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '春秋蟠螭纹尊-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'DOCUMENT', '春秋蟠螭纹尊-建档说明.txt', '/uploads/demo/reports/archive-note.txt', 24, 'txt', '批量生成的建档附件占位文件。', @seed_admin_id, '2025-08-09 14:23:00', @seed_admin_id, '2025-08-09 14:23:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0199' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'DOCUMENT' AND a.file_name = '春秋蟠螭纹尊-建档说明.txt' AND a.deleted = 0
  );

INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REL-DEMO-2026-0200', '元代印花香炉', 'CERAMIC', 'PORCELAIN', '元代', '社会捐赠',
  'LOC_B', 'BASIC_COMPLETE', 'IN_STOCK', '一级', '防震托架单件存放，避免温差突变与硬物碰撞。',
  '搬运时需加缓冲垫，避免高频流转。', '用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。', '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。', '/uploads/demo/images/relic-placeholder.png', '/uploads/demo/reports/appraisal-note.txt',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-11 13:20:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-11 14:50:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = 'REL-DEMO-2026-0200' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'IMAGE', '元代印花香炉-主图.jpg', '/uploads/demo/images/relic-placeholder.png', 68, 'jpg', '批量生成的主图占位图片。', @seed_admin_id, '2025-08-11 15:20:00', @seed_admin_id, '2025-08-11 15:20:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0200' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'IMAGE' AND a.file_name = '元代印花香炉-主图.jpg' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'APPRAISAL_REPORT', '元代印花香炉-鉴定说明.txt', '/uploads/demo/reports/appraisal-note.txt', 24, 'txt', '批量生成的鉴定附件占位文件。', @seed_admin_id, '2025-08-11 15:25:00', @seed_admin_id, '2025-08-11 15:25:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0200' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'APPRAISAL_REPORT' AND a.file_name = '元代印花香炉-鉴定说明.txt' AND a.deleted = 0
  );

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-001', 'BATCH-DEMO-2026-001', '旧藏整理建档', '李博', '2024-07-19 14:35:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-19 14:35:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-19 14:35:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-001' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0001', '春秋错金银壶', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-07-19 14:35:00', @seed_admin_id, '2024-07-19 14:35:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0001' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-001' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0002', '明代印花罐', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-07-19 14:35:00', @seed_admin_id, '2024-07-19 14:35:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0002' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-001' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0003', '明代楷书扇面', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-07-19 14:35:00', @seed_admin_id, '2024-07-19 14:35:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0003' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-001' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0004', '汉代谷纹玉圭', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-07-19 14:35:00', @seed_admin_id, '2024-07-19 14:35:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0004' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-001' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0005', '唐代累丝带扣', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-07-19 14:35:00', @seed_admin_id, '2024-07-19 14:35:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0005' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-001' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-002', 'BATCH-DEMO-2026-002', '考古发掘入藏', '王蕾', '2024-07-29 12:10:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-29 12:10:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-07-29 12:10:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-002' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0006', '清代楠木透雕屏风', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-07-29 12:10:00', @seed_admin_id, '2024-07-29 12:10:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0006' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-002' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0007', '明代戗金漆壶', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-07-29 12:10:00', @seed_admin_id, '2024-07-29 12:10:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0007' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-002' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0008', '北齐莲花座立像', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-07-29 12:10:00', @seed_admin_id, '2024-07-29 12:10:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0008' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-002' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0009', '宋代墨书册页', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-07-29 12:10:00', @seed_admin_id, '2024-07-29 12:10:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0009' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-002' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0010', '汉代云雷纹镜', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-07-29 12:10:00', @seed_admin_id, '2024-07-29 12:10:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0010' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-002' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-003', 'BATCH-DEMO-2026-003', '考古发掘入藏', '周洋', '2024-08-08 10:45:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-08 10:45:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-08 10:45:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-003' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0011', '民国粉彩梅瓶', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-08-08 10:45:00', @seed_admin_id, '2024-08-08 10:45:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0011' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-003' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0012', '清代花鸟手卷', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-08-08 10:45:00', @seed_admin_id, '2024-08-08 10:45:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0012' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-003' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0013', '战国谷纹玉璧', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-08-08 10:45:00', @seed_admin_id, '2024-08-08 10:45:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0013' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-003' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0014', '唐代錾刻带扣', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-08-08 10:45:00', @seed_admin_id, '2024-08-08 10:45:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0014' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-003' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0015', '民国柏木髹漆供案', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-08-08 10:45:00', @seed_admin_id, '2024-08-08 10:45:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0015' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-003' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-004', 'BATCH-DEMO-2026-004', '社会征集入藏', '林清', '2024-08-18 15:20:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-18 15:20:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-18 15:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-004' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0016', '明代朱漆漆奁', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-08-18 15:20:00', @seed_admin_id, '2024-08-18 15:20:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0016' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-004' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0017', '宋代经幢供养人像', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-08-18 15:20:00', @seed_admin_id, '2024-08-18 15:20:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0017' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-004' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0018', '汉代题记册页', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-08-18 15:20:00', @seed_admin_id, '2024-08-18 15:20:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0018' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-004' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0019', '战国蟠螭纹镜', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-08-18 15:20:00', @seed_admin_id, '2024-08-18 15:20:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0019' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-004' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0020', '宋代刻花盘', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-08-18 15:20:00', @seed_admin_id, '2024-08-18 15:20:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0020' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-004' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-005', 'BATCH-DEMO-2026-005', '旧藏整理建档', '何远', '2024-08-28 13:55:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-28 13:55:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-08-28 13:55:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-005' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0021', '清代楷书立轴', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-08-28 13:55:00', @seed_admin_id, '2024-08-28 13:55:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0021' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-005' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0022', '商代素面带钩', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-08-28 13:55:00', @seed_admin_id, '2024-08-28 13:55:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0022' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-005' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0023', '清代掐丝冠饰', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-08-28 13:55:00', @seed_admin_id, '2024-08-28 13:55:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0023' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-005' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0024', '清代柏木髹漆香几', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-08-28 13:55:00', @seed_admin_id, '2024-08-28 13:55:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0024' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-005' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0025', '汉代描金漆盘', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-08-28 13:55:00', @seed_admin_id, '2024-08-28 13:55:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0025' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-005' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-006', 'BATCH-DEMO-2026-006', '社会征集入藏', '苏瑶', '2024-09-07 11:30:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-07 11:30:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-07 11:30:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-006' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0026', '北魏经幢供养人像', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-09-07 11:30:00', @seed_admin_id, '2024-09-07 11:30:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0026' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-006' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0027', '宋代编联卷册', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-09-07 11:30:00', @seed_admin_id, '2024-09-07 11:30:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0027' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-006' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0028', '西周兽面纹簋', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-09-07 11:30:00', @seed_admin_id, '2024-09-07 11:30:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0028' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-006' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0029', '清代影青碗', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-09-07 11:30:00', @seed_admin_id, '2024-09-07 11:30:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0029' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-006' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0030', '明代花鸟扇面', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-09-07 11:30:00', @seed_admin_id, '2024-09-07 11:30:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0030' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-006' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-007', 'BATCH-DEMO-2026-007', '馆际调拨入藏', '郑川', '2024-09-17 09:05:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-17 09:05:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-17 09:05:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-007' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0031', '战国素面带钩', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-09-17 09:05:00', @seed_admin_id, '2024-09-17 09:05:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0031' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-007' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0032', '清代錾刻冠饰', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-09-17 09:05:00', @seed_admin_id, '2024-09-17 09:05:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0032' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-007' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0033', '民国楠木透雕佛像', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-09-17 09:05:00', @seed_admin_id, '2024-09-17 09:05:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0033' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-007' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0034', '民国描金漆壶', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-09-17 09:05:00', @seed_admin_id, '2024-09-17 09:05:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0034' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-007' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0035', '唐代莲花座供养人像', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-09-17 09:05:00', @seed_admin_id, '2024-09-17 09:05:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0035' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-007' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-008', 'BATCH-DEMO-2026-008', '考古发掘入藏', '宋宁', '2024-09-27 14:40:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-27 14:40:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-09-27 14:40:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-008' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0036', '明代题记竹简', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-09-27 14:40:00', @seed_admin_id, '2024-09-27 14:40:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0036' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-008' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0037', '春秋错金银簋', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-09-27 14:40:00', @seed_admin_id, '2024-09-27 14:40:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0037' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-008' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0038', '明代白釉盘', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-09-27 14:40:00', @seed_admin_id, '2024-09-27 14:40:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0038' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-008' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0039', '民国行书扇面', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-09-27 14:40:00', @seed_admin_id, '2024-09-27 14:40:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0039' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-008' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0040', '新石器时代云龙纹玉琮', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-09-27 14:40:00', @seed_admin_id, '2024-09-27 14:40:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0040' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-008' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-009', 'BATCH-DEMO-2026-009', '社会征集入藏', '魏安', '2024-10-07 12:15:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-07 12:15:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-07 12:15:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-009' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0041', '宋代掐丝银盘', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-10-07 12:15:00', @seed_admin_id, '2024-10-07 12:15:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0041' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-009' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0042', '民国黄花梨经匣', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-10-07 12:15:00', @seed_admin_id, '2024-10-07 12:15:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0042' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-009' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0043', '汉代戗金漆盘', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-10-07 12:15:00', @seed_admin_id, '2024-10-07 12:15:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0043' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-009' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0044', '宋代造像碑立像', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-10-07 12:15:00', @seed_admin_id, '2024-10-07 12:15:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0044' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-009' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0045', '汉代编联木牍', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-10-07 12:15:00', @seed_admin_id, '2024-10-07 12:15:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0045' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-009' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-010', 'BATCH-DEMO-2026-010', '社会征集入藏', '唐蕾', '2024-10-17 10:50:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-17 10:50:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-17 10:50:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-010' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0046', '唐代蟠螭纹带钩', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-10-17 10:50:00', @seed_admin_id, '2024-10-17 10:50:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0046' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-010' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0047', '宋代影青罐', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-10-17 10:50:00', @seed_admin_id, '2024-10-17 10:50:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0047' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-010' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0048', '元代花鸟扇面', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-10-17 10:50:00', @seed_admin_id, '2024-10-17 10:50:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0048' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-010' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0049', '新石器时代谷纹玉圭', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-10-17 10:50:00', @seed_admin_id, '2024-10-17 10:50:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0049' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-010' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0050', '清代累丝执壶', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-10-17 10:50:00', @seed_admin_id, '2024-10-17 10:50:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0050' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-010' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-011', 'BATCH-DEMO-2026-011', '专题征集入藏', '韩卓', '2024-10-27 15:25:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-27 15:25:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-10-27 15:25:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-011' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0051', '明代黄花梨经匣', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-10-27 15:25:00', @seed_admin_id, '2024-10-27 15:25:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0051' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-011' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0052', '清代朱漆漆壶', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-10-27 15:25:00', @seed_admin_id, '2024-10-27 15:25:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0052' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-011' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0053', '唐代造像碑坐像', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-10-27 15:25:00', @seed_admin_id, '2024-10-27 15:25:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0053' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-011' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0054', '明代简牍册页', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-10-27 15:25:00', @seed_admin_id, '2024-10-27 15:25:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0054' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-011' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0055', '唐代兽面纹壶', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-10-27 15:25:00', @seed_admin_id, '2024-10-27 15:25:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0055' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-011' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-012', 'BATCH-DEMO-2026-012', '社会征集入藏', '顾琳', '2024-11-06 13:00:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-06 13:00:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-06 13:00:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-012' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0056', '清代白釉碗', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-11-06 13:00:00', @seed_admin_id, '2024-11-06 13:00:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0056' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-012' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0057', '民国仕女立轴', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-11-06 13:00:00', @seed_admin_id, '2024-11-06 13:00:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0057' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-012' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0058', '新石器时代素面带钩', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-11-06 13:00:00', @seed_admin_id, '2024-11-06 13:00:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0058' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-012' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0059', '明代鎏金执壶', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-11-06 13:00:00', @seed_admin_id, '2024-11-06 13:00:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0059' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-012' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0060', '清代黄花梨佛像', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-11-06 13:00:00', @seed_admin_id, '2024-11-06 13:00:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0060' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-012' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-013', 'BATCH-DEMO-2026-013', '馆际调拨入藏', '罗宁', '2024-11-16 11:35:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-16 11:35:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-16 11:35:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-013' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0061', '明代黑漆漆奁', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-11-16 11:35:00', @seed_admin_id, '2024-11-16 11:35:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0061' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-013' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0062', '北魏经幢坐像', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-11-16 11:35:00', @seed_admin_id, '2024-11-16 11:35:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0062' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-013' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0063', '宋代题记木牍', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-11-16 11:35:00', @seed_admin_id, '2024-11-16 11:35:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0063' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-013' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0064', '春秋兽面纹鼎', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-11-16 11:35:00', @seed_admin_id, '2024-11-16 11:35:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0064' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-013' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0065', '唐代粉彩罐', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-11-16 11:35:00', @seed_admin_id, '2024-11-16 11:35:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0065' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-013' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-014', 'BATCH-DEMO-2026-014', '馆际调拨入藏', '姚菲', '2024-11-26 09:10:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-26 09:10:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-11-26 09:10:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-014' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0066', '民国山水扇面', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-11-26 09:10:00', @seed_admin_id, '2024-11-26 09:10:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0066' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-014' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0067', '战国凤鸟纹玉璧', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-11-26 09:10:00', @seed_admin_id, '2024-11-26 09:10:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0067' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-014' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0068', '明代掐丝执壶', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-11-26 09:10:00', @seed_admin_id, '2024-11-26 09:10:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0068' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-014' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0069', '民国柏木髹漆经匣', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-11-26 09:10:00', @seed_admin_id, '2024-11-26 09:10:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0069' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-014' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0070', '明代描金漆奁', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-11-26 09:10:00', @seed_admin_id, '2024-11-26 09:10:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0070' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-014' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-015', 'BATCH-DEMO-2026-015', '专题征集入藏', '李博', '2024-12-06 14:45:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-06 14:45:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-06 14:45:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-015' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0071', '北魏经幢立像', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-12-06 14:45:00', @seed_admin_id, '2024-12-06 14:45:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0071' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-015' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0072', '战国编联木牍', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-12-06 14:45:00', @seed_admin_id, '2024-12-06 14:45:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0072' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-015' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0073', '春秋铭文壶', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-12-06 14:45:00', @seed_admin_id, '2024-12-06 14:45:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0073' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-015' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0074', '元代刻花罐', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-12-06 14:45:00', @seed_admin_id, '2024-12-06 14:45:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0074' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-015' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0075', '民国仕女册页', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-12-06 14:45:00', @seed_admin_id, '2024-12-06 14:45:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0075' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-015' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-016', 'BATCH-DEMO-2026-016', '专题征集入藏', '王蕾', '2024-12-16 12:20:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-16 12:20:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-16 12:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-016' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0076', '清代云龙纹玉璧', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-12-16 12:20:00', @seed_admin_id, '2024-12-16 12:20:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0076' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-016' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0077', '宋代累丝执壶', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-12-16 12:20:00', @seed_admin_id, '2024-12-16 12:20:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0077' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-016' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0078', '清代描金经匣', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-12-16 12:20:00', @seed_admin_id, '2024-12-16 12:20:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0078' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-016' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0079', '战国戗金漆盒', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-12-16 12:20:00', @seed_admin_id, '2024-12-16 12:20:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0079' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-016' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0080', '北魏莲花座坐像', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-12-16 12:20:00', @seed_admin_id, '2024-12-16 12:20:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0080' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-016' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-017', 'BATCH-DEMO-2026-017', '社会征集入藏', '周洋', '2024-12-26 10:55:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-26 10:55:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2024-12-26 10:55:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-017' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0081', '战国墨书木牍', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-12-26 10:55:00', @seed_admin_id, '2024-12-26 10:55:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0081' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-017' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0082', '春秋云雷纹镜', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-12-26 10:55:00', @seed_admin_id, '2024-12-26 10:55:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0082' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-017' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0083', '元代影青盘口壶', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-12-26 10:55:00', @seed_admin_id, '2024-12-26 10:55:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0083' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-017' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0084', '清代山水立轴', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-12-26 10:55:00', @seed_admin_id, '2024-12-26 10:55:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0084' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-017' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0085', '清代谷纹带钩', 1, '模拟入藏建档明细。', @seed_admin_id, '2024-12-26 10:55:00', @seed_admin_id, '2024-12-26 10:55:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0085' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-017' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-018', 'BATCH-DEMO-2026-018', '考古发掘入藏', '林清', '2025-01-05 15:30:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-05 15:30:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-05 15:30:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-018' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0086', '唐代累丝带扣', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-01-05 15:30:00', @seed_admin_id, '2025-01-05 15:30:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0086' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-018' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0087', '民国描金经匣', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-01-05 15:30:00', @seed_admin_id, '2025-01-05 15:30:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0087' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-018' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0088', '战国剔红漆奁', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-01-05 15:30:00', @seed_admin_id, '2025-01-05 15:30:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0088' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-018' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0089', '唐代菩萨坐像', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-01-05 15:30:00', @seed_admin_id, '2025-01-05 15:30:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0089' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-018' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0090', '宋代编联竹简', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-01-05 15:30:00', @seed_admin_id, '2025-01-05 15:30:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0090' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-018' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-019', 'BATCH-DEMO-2026-019', '社会征集入藏', '何远', '2025-01-15 13:05:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-15 13:05:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-15 13:05:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-019' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0091', '战国蟠螭纹壶', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-01-15 13:05:00', @seed_admin_id, '2025-01-15 13:05:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0091' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-019' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0092', '清代白釉盘', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-01-15 13:05:00', @seed_admin_id, '2025-01-15 13:05:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0092' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-019' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0093', '元代行书扇面', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-01-15 13:05:00', @seed_admin_id, '2025-01-15 13:05:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0093' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-019' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0094', '战国云龙纹玉璧', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-01-15 13:05:00', @seed_admin_id, '2025-01-15 13:05:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0094' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-019' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0095', '清代鎏金带扣', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-01-15 13:05:00', @seed_admin_id, '2025-01-15 13:05:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0095' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-019' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-020', 'BATCH-DEMO-2026-020', '专题征集入藏', '苏瑶', '2025-01-25 11:40:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-25 11:40:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-01-25 11:40:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-020' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0096', '民国柏木髹漆经匣', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-01-25 11:40:00', @seed_admin_id, '2025-01-25 11:40:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0096' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-020' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0097', '明代戗金漆盘', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-01-25 11:40:00', @seed_admin_id, '2025-01-25 11:40:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0097' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-020' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0098', '唐代莲花座石刻残件', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-01-25 11:40:00', @seed_admin_id, '2025-01-25 11:40:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0098' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-020' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0099', '明代墨书竹简', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-01-25 11:40:00', @seed_admin_id, '2025-01-25 11:40:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0099' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-020' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0100', '唐代云雷纹鼎', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-01-25 11:40:00', @seed_admin_id, '2025-01-25 11:40:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0100' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-020' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-021', 'BATCH-DEMO-2026-021', '社会征集入藏', '郑川', '2025-02-04 09:15:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-04 09:15:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-04 09:15:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-021' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0101', '元代粉彩罐', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-02-04 09:15:00', @seed_admin_id, '2025-02-04 09:15:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0101' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-021' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0102', '明代花鸟册页', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-02-04 09:15:00', @seed_admin_id, '2025-02-04 09:15:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0102' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-021' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0103', '汉代素面玉璧', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-02-04 09:15:00', @seed_admin_id, '2025-02-04 09:15:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0103' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-021' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0104', '清代鎏金冠饰', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-02-04 09:15:00', @seed_admin_id, '2025-02-04 09:15:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0104' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-021' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0105', '明代紫檀雕花佛像', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-02-04 09:15:00', @seed_admin_id, '2025-02-04 09:15:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0105' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-021' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-022', 'BATCH-DEMO-2026-022', '社会征集入藏', '宋宁', '2025-02-14 14:50:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-14 14:50:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-14 14:50:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-022' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0106', '民国描金漆盘', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-02-14 14:50:00', @seed_admin_id, '2025-02-14 14:50:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0106' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-022' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0107', '北魏造像碑立像', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-02-14 14:50:00', @seed_admin_id, '2025-02-14 14:50:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0107' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-022' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0108', '战国简牍竹简', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-02-14 14:50:00', @seed_admin_id, '2025-02-14 14:50:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0108' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-022' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0109', '战国兽面纹镜', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-02-14 14:50:00', @seed_admin_id, '2025-02-14 14:50:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0109' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-022' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0110', '民国白釉罐', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-02-14 14:50:00', @seed_admin_id, '2025-02-14 14:50:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0110' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-022' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-023', 'BATCH-DEMO-2026-023', '旧藏整理建档', '魏安', '2025-02-24 12:25:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-24 12:25:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-24 12:25:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-023' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0111', '清代行书扇面', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-02-24 12:25:00', @seed_admin_id, '2025-02-24 12:25:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0111' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-023' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0112', '商代素面玉圭', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-02-24 12:25:00', @seed_admin_id, '2025-02-24 12:25:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0112' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-023' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0113', '宋代鎏金带扣', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-02-24 12:25:00', @seed_admin_id, '2025-02-24 12:25:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0113' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-023' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0114', '明代描金香几', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-02-24 12:25:00', @seed_admin_id, '2025-02-24 12:25:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0114' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-023' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0115', '战国描金漆壶', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-02-24 12:25:00', @seed_admin_id, '2025-02-24 12:25:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0115' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-023' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-024', 'BATCH-DEMO-2026-024', '专题征集入藏', '唐蕾', '2025-03-06 10:00:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-06 10:00:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-06 10:00:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-024' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0116', '北魏经幢坐像', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-03-06 10:00:00', @seed_admin_id, '2025-03-06 10:00:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0116' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-024' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0117', '战国题记册页', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-03-06 10:00:00', @seed_admin_id, '2025-03-06 10:00:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0117' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-024' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0118', '春秋错金银带钩', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-03-06 10:00:00', @seed_admin_id, '2025-03-06 10:00:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0118' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-024' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0119', '元代影青碗', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-03-06 10:00:00', @seed_admin_id, '2025-03-06 10:00:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0119' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-024' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0120', '清代花鸟手卷', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-03-06 10:00:00', @seed_admin_id, '2025-03-06 10:00:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0120' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-024' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-025', 'BATCH-DEMO-2026-025', '考古发掘入藏', '韩卓', '2025-03-16 15:35:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-16 15:35:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-16 15:35:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-025' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0121', '汉代素面带钩', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-03-16 15:35:00', @seed_admin_id, '2025-03-16 15:35:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0121' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-025' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0122', '清代掐丝带扣', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-03-16 15:35:00', @seed_admin_id, '2025-03-16 15:35:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0122' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-025' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0123', '清代描金香几', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-03-16 15:35:00', @seed_admin_id, '2025-03-16 15:35:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0123' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-025' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0124', '明代戗金漆盒', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-03-16 15:35:00', @seed_admin_id, '2025-03-16 15:35:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0124' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-025' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0125', '北魏莲花座坐像', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-03-16 15:35:00', @seed_admin_id, '2025-03-16 15:35:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0125' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-025' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-026', 'BATCH-DEMO-2026-026', '专题征集入藏', '顾琳', '2025-03-26 13:10:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-26 13:10:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-26 13:10:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-026' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0126', '宋代编联卷册', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-03-26 13:10:00', @seed_admin_id, '2025-03-26 13:10:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0126' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-026' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0127', '春秋铭文带钩', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-03-26 13:10:00', @seed_admin_id, '2025-03-26 13:10:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0127' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-026' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0128', '宋代印花香炉', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-03-26 13:10:00', @seed_admin_id, '2025-03-26 13:10:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0128' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-026' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0129', '元代行书手卷', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-03-26 13:10:00', @seed_admin_id, '2025-03-26 13:10:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0129' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-026' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0130', '新石器时代云龙纹玉佩', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-03-26 13:10:00', @seed_admin_id, '2025-03-26 13:10:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0130' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-026' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-027', 'BATCH-DEMO-2026-027', '社会征集入藏', '罗宁', '2025-04-05 11:45:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-05 11:45:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-05 11:45:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-027' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0131', '唐代掐丝冠饰', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-04-05 11:45:00', @seed_admin_id, '2025-04-05 11:45:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0131' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-027' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0132', '明代描金供案', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-04-05 11:45:00', @seed_admin_id, '2025-04-05 11:45:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0132' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-027' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0133', '战国戗金漆盘', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-04-05 11:45:00', @seed_admin_id, '2025-04-05 11:45:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0133' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-027' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0134', '唐代菩萨立像', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-04-05 11:45:00', @seed_admin_id, '2025-04-05 11:45:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0134' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-027' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0135', '汉代墨书册页', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-04-05 11:45:00', @seed_admin_id, '2025-04-05 11:45:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0135' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-027' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-028', 'BATCH-DEMO-2026-028', '考古发掘入藏', '姚菲', '2025-04-15 09:20:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-15 09:20:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-15 09:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-028' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0136', '战国云雷纹带钩', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-04-15 09:20:00', @seed_admin_id, '2025-04-15 09:20:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0136' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-028' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0137', '元代粉彩香炉', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-04-15 09:20:00', @seed_admin_id, '2025-04-15 09:20:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0137' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-028' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0138', '清代墨竹册页', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-04-15 09:20:00', @seed_admin_id, '2025-04-15 09:20:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0138' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-028' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0139', '新石器时代云龙纹玉圭', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-04-15 09:20:00', @seed_admin_id, '2025-04-15 09:20:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0139' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-028' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0140', '唐代錾花银盘', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-04-15 09:20:00', @seed_admin_id, '2025-04-15 09:20:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0140' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-028' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-029', 'BATCH-DEMO-2026-029', '专题征集入藏', '李博', '2025-04-25 14:55:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-25 14:55:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-25 14:55:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-029' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0141', '民国黄花梨佛像', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-04-25 14:55:00', @seed_admin_id, '2025-04-25 14:55:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0141' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-029' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0142', '汉代黑漆漆壶', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-04-25 14:55:00', @seed_admin_id, '2025-04-25 14:55:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0142' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-029' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0143', '北魏莲花座供养人像', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-04-25 14:55:00', @seed_admin_id, '2025-04-25 14:55:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0143' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-029' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0144', '战国漆书卷册', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-04-25 14:55:00', @seed_admin_id, '2025-04-25 14:55:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0144' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-029' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0145', '战国蟠螭纹镜', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-04-25 14:55:00', @seed_admin_id, '2025-04-25 14:55:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0145' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-029' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-030', 'BATCH-DEMO-2026-030', '馆际调拨入藏', '王蕾', '2025-05-05 12:30:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-05 12:30:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-05 12:30:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-030' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0146', '明代刻花香炉', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-05-05 12:30:00', @seed_admin_id, '2025-05-05 12:30:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0146' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-030' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0147', '宋代仕女册页', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-05-05 12:30:00', @seed_admin_id, '2025-05-05 12:30:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0147' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-030' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0148', '战国凤鸟纹玉璧', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-05-05 12:30:00', @seed_admin_id, '2025-05-05 12:30:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0148' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-030' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0149', '宋代錾刻执壶', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-05-05 12:30:00', @seed_admin_id, '2025-05-05 12:30:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0149' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-030' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0150', '明代黄花梨经匣', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-05-05 12:30:00', @seed_admin_id, '2025-05-05 12:30:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0150' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-030' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-031', 'BATCH-DEMO-2026-031', '考古发掘入藏', '周洋', '2025-05-15 10:05:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-15 10:05:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-15 10:05:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-031' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0151', '明代黑漆漆壶', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-05-15 10:05:00', @seed_admin_id, '2025-05-15 10:05:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0151' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-031' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0152', '唐代造像碑立像', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-05-15 10:05:00', @seed_admin_id, '2025-05-15 10:05:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0152' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-031' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0153', '汉代漆书卷册', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-05-15 10:05:00', @seed_admin_id, '2025-05-15 10:05:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0153' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-031' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0154', '春秋蟠螭纹镜', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-05-15 10:05:00', @seed_admin_id, '2025-05-15 10:05:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0154' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-031' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0155', '民国青花罐', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-05-15 10:05:00', @seed_admin_id, '2025-05-15 10:05:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0155' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-031' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-032', 'BATCH-DEMO-2026-032', '考古发掘入藏', '林清', '2025-05-25 15:40:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-25 15:40:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-25 15:40:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-032' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0156', '元代墨竹立轴', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-05-25 15:40:00', @seed_admin_id, '2025-05-25 15:40:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0156' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-032' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0157', '商代螭龙纹玉琮', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-05-25 15:40:00', @seed_admin_id, '2025-05-25 15:40:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0157' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-032' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0158', '清代錾刻银盘', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-05-25 15:40:00', @seed_admin_id, '2025-05-25 15:40:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0158' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-032' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0159', '民国描金佛像', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-05-25 15:40:00', @seed_admin_id, '2025-05-25 15:40:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0159' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-032' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0160', '汉代黑漆漆壶', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-05-25 15:40:00', @seed_admin_id, '2025-05-25 15:40:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0160' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-032' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-033', 'BATCH-DEMO-2026-033', '考古发掘入藏', '何远', '2025-06-04 13:15:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-04 13:15:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-04 13:15:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-033' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0161', '北魏佛首立像', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-06-04 13:15:00', @seed_admin_id, '2025-06-04 13:15:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0161' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-033' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0162', '明代编联册页', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-06-04 13:15:00', @seed_admin_id, '2025-06-04 13:15:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0162' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-033' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0163', '战国错金银带钩', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-06-04 13:15:00', @seed_admin_id, '2025-06-04 13:15:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0163' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-033' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0164', '唐代刻花梅瓶', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-06-04 13:15:00', @seed_admin_id, '2025-06-04 13:15:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0164' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-033' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0165', '清代仕女手卷', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-06-04 13:15:00', @seed_admin_id, '2025-06-04 13:15:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0165' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-033' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-034', 'BATCH-DEMO-2026-034', '社会征集入藏', '苏瑶', '2025-06-14 11:50:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-14 11:50:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-14 11:50:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-034' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0166', '商代素面玉璧', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-06-14 11:50:00', @seed_admin_id, '2025-06-14 11:50:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0166' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-034' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0167', '宋代錾刻带扣', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-06-14 11:50:00', @seed_admin_id, '2025-06-14 11:50:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0167' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-034' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0168', '清代描金佛像', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-06-14 11:50:00', @seed_admin_id, '2025-06-14 11:50:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0168' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-034' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0169', '民国剔红漆盘', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-06-14 11:50:00', @seed_admin_id, '2025-06-14 11:50:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0169' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-034' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0170', '北魏莲花座石刻残件', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-06-14 11:50:00', @seed_admin_id, '2025-06-14 11:50:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0170' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-034' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-035', 'BATCH-DEMO-2026-035', '馆际调拨入藏', '郑川', '2025-06-24 09:25:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-24 09:25:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-24 09:25:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-035' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0171', '宋代编联竹简', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-06-24 09:25:00', @seed_admin_id, '2025-06-24 09:25:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0171' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-035' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0172', '汉代云雷纹带钩', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-06-24 09:25:00', @seed_admin_id, '2025-06-24 09:25:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0172' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-035' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0173', '元代粉彩香炉', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-06-24 09:25:00', @seed_admin_id, '2025-06-24 09:25:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0173' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-035' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0174', '元代花鸟手卷', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-06-24 09:25:00', @seed_admin_id, '2025-06-24 09:25:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0174' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-035' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0175', '商代谷纹带钩', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-06-24 09:25:00', @seed_admin_id, '2025-06-24 09:25:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0175' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-035' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-036', 'BATCH-DEMO-2026-036', '馆际调拨入藏', '宋宁', '2025-07-04 14:00:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-04 14:00:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-04 14:00:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-036' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0176', '清代掐丝香囊', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-07-04 14:00:00', @seed_admin_id, '2025-07-04 14:00:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0176' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-036' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0177', '民国描金香几', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-07-04 14:00:00', @seed_admin_id, '2025-07-04 14:00:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0177' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-036' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0178', '汉代剔红漆盒', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-07-04 14:00:00', @seed_admin_id, '2025-07-04 14:00:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0178' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-036' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0179', '宋代造像碑供养人像', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-07-04 14:00:00', @seed_admin_id, '2025-07-04 14:00:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0179' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-036' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0180', '明代编联竹简', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-07-04 14:00:00', @seed_admin_id, '2025-07-04 14:00:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0180' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-036' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-037', 'BATCH-DEMO-2026-037', '馆际调拨入藏', '魏安', '2025-07-14 12:35:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-14 12:35:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-14 12:35:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-037' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0181', '西周错金银镜', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-07-14 12:35:00', @seed_admin_id, '2025-07-14 12:35:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0181' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-037' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0182', '唐代刻花盘口壶', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-07-14 12:35:00', @seed_admin_id, '2025-07-14 12:35:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0182' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-037' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0183', '宋代楷书立轴', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-07-14 12:35:00', @seed_admin_id, '2025-07-14 12:35:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0183' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-037' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0184', '汉代凤鸟纹带钩', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-07-14 12:35:00', @seed_admin_id, '2025-07-14 12:35:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0184' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-037' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0185', '唐代錾花银盘', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-07-14 12:35:00', @seed_admin_id, '2025-07-14 12:35:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0185' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-037' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-038', 'BATCH-DEMO-2026-038', '旧藏整理建档', '唐蕾', '2025-07-24 10:10:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-24 10:10:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-24 10:10:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-038' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0186', '明代柏木髹漆佛像', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-07-24 10:10:00', @seed_admin_id, '2025-07-24 10:10:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0186' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-038' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0187', '战国黑漆漆壶', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-07-24 10:10:00', @seed_admin_id, '2025-07-24 10:10:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0187' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-038' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0188', '北魏造像碑石刻残件', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-07-24 10:10:00', @seed_admin_id, '2025-07-24 10:10:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0188' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-038' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0189', '明代简牍竹简', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-07-24 10:10:00', @seed_admin_id, '2025-07-24 10:10:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0189' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-038' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0190', '春秋蟠螭纹簋', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-07-24 10:10:00', @seed_admin_id, '2025-07-24 10:10:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0190' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-038' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-039', 'BATCH-DEMO-2026-039', '专题征集入藏', '韩卓', '2025-08-03 15:45:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-03 15:45:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-03 15:45:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-039' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0191', '明代粉彩香炉', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-08-03 15:45:00', @seed_admin_id, '2025-08-03 15:45:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0191' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-039' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0192', '明代墨竹立轴', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-08-03 15:45:00', @seed_admin_id, '2025-08-03 15:45:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0192' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-039' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0193', '商代凤鸟纹玉琮', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-08-03 15:45:00', @seed_admin_id, '2025-08-03 15:45:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0193' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-039' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0194', '宋代錾花冠饰', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-08-03 15:45:00', @seed_admin_id, '2025-08-03 15:45:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0194' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-039' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0195', '明代紫檀雕花佛像', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-08-03 15:45:00', @seed_admin_id, '2025-08-03 15:45:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0195' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-039' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'IN-DEMO-2026-040', 'BATCH-DEMO-2026-040', '旧藏整理建档', '顾琳', '2025-08-13 13:20:00', 5, 'COMPLETED',
  '批量生成的入藏建档单，共包含 5 件文物。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-13 13:20:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-13 13:20:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = 'IN-DEMO-2026-040' AND deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0196', '明代朱漆漆盒', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-08-13 13:20:00', @seed_admin_id, '2025-08-13 13:20:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0196' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-040' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0197', '宋代佛首石刻残件', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-08-13 13:20:00', @seed_admin_id, '2025-08-13 13:20:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0197' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-040' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0198', '战国题记木牍', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-08-13 13:20:00', @seed_admin_id, '2025-08-13 13:20:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0198' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-040' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0199', '春秋蟠螭纹尊', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-08-13 13:20:00', @seed_admin_id, '2025-08-13 13:20:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0199' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-040' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0200', '元代印花香炉', 1, '模拟入藏建档明细。', @seed_admin_id, '2025-08-13 13:20:00', @seed_admin_id, '2025-08-13 13:20:00', 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0200' AND r.deleted = 0
WHERE o.order_no = 'IN-DEMO-2026-040' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-001', '学术研究调阅', '市文化馆联合展区', '李博', '2025-02-12 12:47:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'PENDING', NULL, NULL,
  NULL, NULL, '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-12 12:47:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-12 12:47:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-001' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0101', '元代粉彩罐', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-02-12 12:47:00', @seed_admin_id, '2025-02-12 12:47:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0101' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-001' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0102', '明代花鸟册页', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-02-12 12:47:00', @seed_admin_id, '2025-02-12 12:47:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0102' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-001' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-002', '专题临展借展', '省博物院交流展厅', '王蕾', '2025-02-16 14:01:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'PENDING', NULL, NULL,
  NULL, NULL, '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-16 14:01:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-16 14:01:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-002' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0103', '汉代素面玉璧', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-02-16 14:01:00', @seed_admin_id, '2025-02-16 14:01:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0103' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-002' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0104', '清代鎏金冠饰', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-02-16 14:01:00', @seed_admin_id, '2025-02-16 14:01:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0104' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-002' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-003', '数字化采集外拍', '省博物院交流展厅', '周洋', '2025-02-20 09:15:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'PENDING', NULL, NULL,
  NULL, NULL, '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-20 09:15:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-20 09:15:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-003' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0105', '明代紫檀雕花佛像', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-02-20 09:15:00', @seed_admin_id, '2025-02-20 09:15:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0105' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-003' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0106', '民国描金漆盘', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-02-20 09:15:00', @seed_admin_id, '2025-02-20 09:15:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0106' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-003' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-004', '专题临展借展', '市文化馆联合展区', '林清', '2025-02-24 11:29:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'PENDING', NULL, NULL,
  NULL, NULL, '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-24 11:29:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-24 11:29:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-004' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0107', '北魏造像碑立像', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-02-24 11:29:00', @seed_admin_id, '2025-02-24 11:29:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0107' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-004' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0108', '战国简牍竹简', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-02-24 11:29:00', @seed_admin_id, '2025-02-24 11:29:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0108' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-004' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-005', '文保评估送检', '高校文博实验室', '何远', '2025-02-28 13:43:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'PENDING', NULL, NULL,
  NULL, NULL, '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-28 13:43:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-02-28 13:43:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-005' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0109', '战国兽面纹镜', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-02-28 13:43:00', @seed_admin_id, '2025-02-28 13:43:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0109' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-005' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0110', '民国白釉罐', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-02-28 13:43:00', @seed_admin_id, '2025-02-28 13:43:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0110' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-005' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-006', '专题临展借展', '高校文博实验室', '苏瑶', '2025-03-04 15:57:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'PENDING', NULL, NULL,
  NULL, NULL, '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-04 15:57:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-04 15:57:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-006' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0111', '清代行书扇面', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-03-04 15:57:00', @seed_admin_id, '2025-03-04 15:57:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0111' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-006' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0112', '商代素面玉圭', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-03-04 15:57:00', @seed_admin_id, '2025-03-04 15:57:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0112' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-006' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-007', '学术研究调阅', '市文化馆联合展区', '郑川', '2025-03-08 10:11:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'PENDING', NULL, NULL,
  NULL, NULL, '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-08 10:11:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-08 10:11:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-007' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0113', '宋代鎏金带扣', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-03-08 10:11:00', @seed_admin_id, '2025-03-08 10:11:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0113' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-007' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0114', '明代描金香几', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-03-08 10:11:00', @seed_admin_id, '2025-03-08 10:11:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0114' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-007' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-008', '专题临展借展', '文物保护中心', '宋宁', '2025-03-12 12:25:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'PENDING', NULL, NULL,
  NULL, NULL, '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-12 12:25:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-12 12:25:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-008' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0115', '战国描金漆壶', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-03-12 12:25:00', @seed_admin_id, '2025-03-12 12:25:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0115' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-008' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0116', '北魏经幢坐像', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-03-12 12:25:00', @seed_admin_id, '2025-03-12 12:25:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0116' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-008' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-009', '专题临展借展', '市文化馆联合展区', '魏安', '2025-03-16 14:39:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'PENDING', NULL, NULL,
  NULL, NULL, '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-16 14:39:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-16 14:39:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-009' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0117', '战国题记册页', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-03-16 14:39:00', @seed_admin_id, '2025-03-16 14:39:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0117' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-009' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0118', '春秋错金银带钩', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-03-16 14:39:00', @seed_admin_id, '2025-03-16 14:39:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0118' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-009' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-010', '专题临展借展', '馆外数字采集点', '唐蕾', '2025-03-20 09:53:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'PENDING', NULL, NULL,
  NULL, NULL, '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-20 09:53:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-20 09:53:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-010' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0119', '元代影青碗', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-03-20 09:53:00', @seed_admin_id, '2025-03-20 09:53:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0119' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-010' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0120', '清代花鸟手卷', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-03-20 09:53:00', @seed_admin_id, '2025-03-20 09:53:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0120' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-010' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-011', '专题临展借展', '文物保护中心', '韩卓', '2025-03-24 11:07:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'APPROVED', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-25 11:07:00',
  '审批通过，已完成交接出库。', NULL, '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-24 11:07:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-25 11:07:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-011' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0121', '汉代素面带钩', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-03-24 11:07:00', @seed_admin_id, '2025-03-24 11:07:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0121' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-011' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0122', '清代掐丝带扣', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-03-24 11:07:00', @seed_admin_id, '2025-03-24 11:07:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0122' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-011' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-012', '馆际交流展', '省博物院交流展厅', '顾琳', '2025-03-28 13:21:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'APPROVED', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-29 13:21:00',
  '审批通过，已完成交接出库。', NULL, '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-28 13:21:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-03-29 13:21:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-012' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0123', '清代描金香几', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-03-28 13:21:00', @seed_admin_id, '2025-03-28 13:21:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0123' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-012' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0124', '明代戗金漆盒', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-03-28 13:21:00', @seed_admin_id, '2025-03-28 13:21:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0124' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-012' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-013', '学术研究调阅', '高校文博实验室', '罗宁', '2025-04-01 15:35:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'APPROVED', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-02 15:35:00',
  '审批通过，已完成交接出库。', NULL, '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-01 15:35:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-02 15:35:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-013' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0125', '北魏莲花座坐像', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-04-01 15:35:00', @seed_admin_id, '2025-04-01 15:35:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0125' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-013' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0126', '宋代编联卷册', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-04-01 15:35:00', @seed_admin_id, '2025-04-01 15:35:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0126' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-013' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-014', '数字化采集外拍', '省博物院交流展厅', '姚菲', '2025-04-05 10:49:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'APPROVED', COALESCE((SELECT id FROM sys_user WHERE username = 'admin04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-06 10:49:00',
  '审批通过，已完成交接出库。', NULL, '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-05 10:49:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-06 10:49:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-014' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0127', '春秋铭文带钩', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-04-05 10:49:00', @seed_admin_id, '2025-04-05 10:49:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0127' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-014' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0128', '宋代印花香炉', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-04-05 10:49:00', @seed_admin_id, '2025-04-05 10:49:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0128' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-014' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-015', '数字化采集外拍', '馆外数字采集点', '李博', '2025-04-09 12:03:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'APPROVED', COALESCE((SELECT id FROM sys_user WHERE username = 'admin05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-10 12:03:00',
  '审批通过，已完成交接出库。', NULL, '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-09 12:03:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-10 12:03:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-015' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0129', '元代行书手卷', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-04-09 12:03:00', @seed_admin_id, '2025-04-09 12:03:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0129' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-015' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0130', '新石器时代云龙纹玉佩', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-04-09 12:03:00', @seed_admin_id, '2025-04-09 12:03:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0130' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-015' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-016', '学术研究调阅', '高校文博实验室', '王蕾', '2025-04-13 14:17:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'APPROVED', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-14 14:17:00',
  '审批通过，已完成交接出库。', NULL, '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-13 14:17:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-14 14:17:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-016' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0131', '唐代掐丝冠饰', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-04-13 14:17:00', @seed_admin_id, '2025-04-13 14:17:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0131' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-016' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0132', '明代描金供案', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-04-13 14:17:00', @seed_admin_id, '2025-04-13 14:17:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0132' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-016' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-017', '专题临展借展', '馆外数字采集点', '周洋', '2025-04-17 09:31:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'APPROVED', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-18 09:31:00',
  '审批通过，已完成交接出库。', NULL, '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-17 09:31:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-18 09:31:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-017' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0133', '战国戗金漆盘', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-04-17 09:31:00', @seed_admin_id, '2025-04-17 09:31:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0133' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-017' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0134', '唐代菩萨立像', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-04-17 09:31:00', @seed_admin_id, '2025-04-17 09:31:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0134' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-017' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-018', '数字化采集外拍', '高校文博实验室', '林清', '2025-04-21 11:45:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'APPROVED', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-22 11:45:00',
  '审批通过，已完成交接出库。', NULL, '批量生成的出库业务单，共 1 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-21 11:45:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-04-22 11:45:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-018' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0135', '汉代墨书册页', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-04-21 11:45:00', @seed_admin_id, '2025-04-21 11:45:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0135' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-018' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-019', '文保评估送检', '市文化馆联合展区', '何远', '2025-07-22 15:07:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'RETURNED', COALESCE((SELECT id FROM sys_user WHERE username = 'admin04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-23 15:07:00',
  '审批通过，已完成借展并回库登记。', '2025-08-09 15:07:00', '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-22 15:07:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-09 15:07:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-019' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0181', '西周错金银镜', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-07-22 15:07:00', @seed_admin_id, '2025-07-22 15:07:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0181' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-019' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0182', '唐代刻花盘口壶', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-07-22 15:07:00', @seed_admin_id, '2025-07-22 15:07:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0182' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-019' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-020', '专题临展借展', '文物保护中心', '苏瑶', '2025-07-26 10:21:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'RETURNED', COALESCE((SELECT id FROM sys_user WHERE username = 'admin05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-27 10:21:00',
  '审批通过，已完成借展并回库登记。', '2025-08-13 10:21:00', '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-26 10:21:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-13 10:21:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-020' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0183', '宋代楷书立轴', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-07-26 10:21:00', @seed_admin_id, '2025-07-26 10:21:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0183' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-020' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0184', '汉代凤鸟纹带钩', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-07-26 10:21:00', @seed_admin_id, '2025-07-26 10:21:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0184' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-020' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-021', '文保评估送检', '市文化馆联合展区', '郑川', '2025-07-30 12:35:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'RETURNED', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-31 12:35:00',
  '审批通过，已完成借展并回库登记。', '2025-08-17 12:35:00', '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-30 12:35:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-17 12:35:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-021' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0185', '唐代錾花银盘', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-07-30 12:35:00', @seed_admin_id, '2025-07-30 12:35:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0185' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-021' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0186', '明代柏木髹漆佛像', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-07-30 12:35:00', @seed_admin_id, '2025-07-30 12:35:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0186' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-021' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-022', '馆际交流展', '高校文博实验室', '宋宁', '2025-08-03 14:49:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'RETURNED', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-04 14:49:00',
  '审批通过，已完成借展并回库登记。', '2025-08-21 14:49:00', '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-03 14:49:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-21 14:49:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-022' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0187', '战国黑漆漆壶', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-08-03 14:49:00', @seed_admin_id, '2025-08-03 14:49:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0187' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-022' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0188', '北魏造像碑石刻残件', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-08-03 14:49:00', @seed_admin_id, '2025-08-03 14:49:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0188' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-022' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-023', '数字化采集外拍', '省博物院交流展厅', '魏安', '2025-08-07 09:03:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'RETURNED', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-08 09:03:00',
  '审批通过，已完成借展并回库登记。', '2025-08-25 09:03:00', '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-07 09:03:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-25 09:03:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-023' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0189', '明代简牍竹简', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-08-07 09:03:00', @seed_admin_id, '2025-08-07 09:03:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0189' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-023' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0190', '春秋蟠螭纹簋', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-08-07 09:03:00', @seed_admin_id, '2025-08-07 09:03:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0190' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-023' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-024', '数字化采集外拍', '高校文博实验室', '唐蕾', '2025-08-11 11:17:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'REJECTED', COALESCE((SELECT id FROM sys_user WHERE username = 'admin04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-12 11:17:00',
  '借展条件未满足，驳回本次申请。', NULL, '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-11 11:17:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-12 11:17:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-024' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0191', '明代粉彩香炉', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-08-11 11:17:00', @seed_admin_id, '2025-08-11 11:17:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0191' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-024' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0192', '明代墨竹立轴', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-08-11 11:17:00', @seed_admin_id, '2025-08-11 11:17:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0192' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-024' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-025', '馆际交流展', '省博物院交流展厅', '韩卓', '2025-08-15 13:31:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'REJECTED', COALESCE((SELECT id FROM sys_user WHERE username = 'admin05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-16 13:31:00',
  '借展条件未满足，驳回本次申请。', NULL, '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-15 13:31:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-16 13:31:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-025' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0193', '商代凤鸟纹玉琮', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-08-15 13:31:00', @seed_admin_id, '2025-08-15 13:31:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0193' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-025' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0194', '宋代錾花冠饰', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-08-15 13:31:00', @seed_admin_id, '2025-08-15 13:31:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0194' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-025' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-026', '馆际交流展', '高校文博实验室', '顾琳', '2025-08-19 15:45:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'REJECTED', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-20 15:45:00',
  '借展条件未满足，驳回本次申请。', NULL, '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-19 15:45:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-20 15:45:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-026' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0195', '明代紫檀雕花佛像', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-08-19 15:45:00', @seed_admin_id, '2025-08-19 15:45:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0195' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-026' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0196', '明代朱漆漆盒', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-08-19 15:45:00', @seed_admin_id, '2025-08-19 15:45:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0196' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-026' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-027', '学术研究调阅', '高校文博实验室', '罗宁', '2025-08-23 10:59:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'REJECTED', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-24 10:59:00',
  '借展条件未满足，驳回本次申请。', NULL, '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-23 10:59:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-24 10:59:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-027' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0197', '宋代佛首石刻残件', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-08-23 10:59:00', @seed_admin_id, '2025-08-23 10:59:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0197' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-027' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0198', '战国题记木牍', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-08-23 10:59:00', @seed_admin_id, '2025-08-23 10:59:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0198' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-027' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'OUT-DEMO-2026-028', '文保评估送检', '文物保护中心', '姚菲', '2025-08-27 12:13:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id),
  'REJECTED', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-28 12:13:00',
  '借展条件未满足，驳回本次申请。', NULL, '批量生成的出库业务单，共 2 件文物。',
  COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-27 12:13:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-08-28 12:13:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = 'OUT-DEMO-2026-028' AND deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0199', '春秋蟠螭纹尊', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-08-27 12:13:00', @seed_admin_id, '2025-08-27 12:13:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0199' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-028' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, 'REL-DEMO-2026-0200', '元代印花香炉', 1, 'IN_STOCK', '模拟出库业务明细。', @seed_admin_id, '2025-08-27 12:13:00', @seed_admin_id, '2025-08-27 12:13:00', 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0200' AND r.deleted = 0
WHERE o.order_no = 'OUT-DEMO-2026-028' AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-001', r.id, 'REL-DEMO-2026-0154', '春秋蟠螭纹镜', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '存在裂隙与结构松动，需要进行加固处理。',
  'APPLIED', 'UNACCEPTED', '2025-06-08 09:58:00', NULL,
  NULL, NULL, NULL, NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-08 09:58:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-08 09:58:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0154' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-001' AND deleted = 0);

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-002', r.id, 'REL-DEMO-2026-0155', '民国青花罐', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '表层彩绘起翘，需要实施病害处置。',
  'APPLIED', 'UNACCEPTED', '2025-06-10 10:05:00', NULL,
  NULL, NULL, NULL, NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-10 10:05:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-10 10:05:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0155' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-002' AND deleted = 0);

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-003', r.id, 'REL-DEMO-2026-0156', '元代墨竹立轴', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '馆藏调阅中发现局部缺损，需要修复评估。',
  'APPLIED', 'UNACCEPTED', '2025-06-12 11:12:00', NULL,
  NULL, NULL, NULL, NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-12 11:12:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-12 11:12:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0156' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-003' AND deleted = 0);

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-004', r.id, 'REL-DEMO-2026-0157', '商代螭龙纹玉琮', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '长期存放后病害复发，需要重新修复。',
  'APPLIED', 'UNACCEPTED', '2025-06-14 12:19:00', NULL,
  NULL, NULL, NULL, NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-14 12:19:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-14 12:19:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0157' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-004' AND deleted = 0);

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-005', r.id, 'REL-DEMO-2026-0158', '清代錾刻银盘', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '器表腐蚀加重，需要开展清理与稳定性加固。',
  'APPLIED', 'UNACCEPTED', '2025-06-16 13:26:00', NULL,
  NULL, NULL, NULL, NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-16 13:26:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-16 13:26:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0158' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-005' AND deleted = 0);

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-006', r.id, 'REL-DEMO-2026-0159', '民国描金佛像', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '存在裂隙与结构松动，需要进行加固处理。',
  'APPLIED', 'UNACCEPTED', '2025-06-18 14:33:00', NULL,
  NULL, NULL, NULL, NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-18 14:33:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-18 14:33:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0159' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-006' AND deleted = 0);

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-007', r.id, 'REL-DEMO-2026-0160', '汉代黑漆漆壶', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '表层彩绘起翘，需要实施病害处置。',
  'APPLIED', 'UNACCEPTED', '2025-06-20 15:40:00', NULL,
  NULL, NULL, NULL, NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-20 15:40:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-20 15:40:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0160' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-007' AND deleted = 0);

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-008', r.id, 'REL-DEMO-2026-0161', '北魏佛首立像', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '馆藏调阅中发现局部缺损，需要修复评估。',
  'APPLIED', 'UNACCEPTED', '2025-06-22 09:47:00', NULL,
  NULL, NULL, NULL, NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-22 09:47:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-22 09:47:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0161' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-008' AND deleted = 0);

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-009', r.id, 'REL-DEMO-2026-0162', '明代编联册页', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '长期存放后病害复发，需要重新修复。',
  'APPLIED', 'UNACCEPTED', '2025-06-24 10:54:00', NULL,
  NULL, NULL, NULL, NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-24 10:54:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-24 10:54:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0162' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-009' AND deleted = 0);

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-010', r.id, 'REL-DEMO-2026-0163', '战国错金银带钩', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '器表腐蚀加重，需要开展清理与稳定性加固。',
  'APPLIED', 'UNACCEPTED', '2025-06-26 11:01:00', NULL,
  NULL, NULL, NULL, NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-26 11:01:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-26 11:01:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0163' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-010' AND deleted = 0);

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-011', r.id, 'REL-DEMO-2026-0164', '唐代刻花梅瓶', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '存在裂隙与结构松动，需要进行加固处理。',
  'APPROVED', 'UNACCEPTED', '2025-06-28 12:08:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-06-29 12:08:00', '审批通过，按方案推进修复。', NULL, NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-28 12:08:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-29 12:08:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0164' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-011' AND deleted = 0);

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-012', r.id, 'REL-DEMO-2026-0165', '清代仕女手卷', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '表层彩绘起翘，需要实施病害处置。',
  'APPROVED', 'UNACCEPTED', '2025-06-30 13:15:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin04' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-07-01 13:15:00', '审批通过，按方案推进修复。', NULL, NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-30 13:15:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-01 13:15:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0165' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-012' AND deleted = 0);

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-013', r.id, 'REL-DEMO-2026-0166', '商代素面玉璧', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '馆藏调阅中发现局部缺损，需要修复评估。',
  'APPROVED', 'UNACCEPTED', '2025-07-02 14:22:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin05' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-07-03 14:22:00', '审批通过，按方案推进修复。', NULL, NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-02 14:22:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-03 14:22:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0166' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-013' AND deleted = 0);

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-014', r.id, 'REL-DEMO-2026-0167', '宋代錾刻带扣', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '长期存放后病害复发，需要重新修复。',
  'APPROVED', 'UNACCEPTED', '2025-07-04 15:29:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-07-05 15:29:00', '审批通过，按方案推进修复。', NULL, NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-04 15:29:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-05 15:29:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0167' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-014' AND deleted = 0);

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-015', r.id, 'REL-DEMO-2026-0168', '清代描金佛像', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '器表腐蚀加重，需要开展清理与稳定性加固。',
  'APPROVED', 'UNACCEPTED', '2025-07-06 09:36:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-07-07 09:36:00', '审批通过，按方案推进修复。', NULL, NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-06 09:36:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-07 09:36:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0168' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-015' AND deleted = 0);

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-016', r.id, 'REL-DEMO-2026-0169', '民国剔红漆盘', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '存在裂隙与结构松动，需要进行加固处理。',
  'APPROVED', 'UNACCEPTED', '2025-07-08 10:43:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-07-09 10:43:00', '审批通过，按方案推进修复。', NULL, NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-08 10:43:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-09 10:43:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0169' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-016' AND deleted = 0);

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-017', r.id, 'REL-DEMO-2026-0170', '北魏莲花座石刻残件', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '表层彩绘起翘，需要实施病害处置。',
  'APPROVED', 'UNACCEPTED', '2025-07-10 11:50:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin04' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-07-11 11:50:00', '审批通过，按方案推进修复。', NULL, NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-10 11:50:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-11 11:50:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0170' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-017' AND deleted = 0);

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-018', r.id, 'REL-DEMO-2026-0136', '战国云雷纹带钩', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '馆藏调阅中发现局部缺损，需要修复评估。',
  'IN_PROGRESS', 'UNACCEPTED', '2025-05-03 12:52:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin05' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-05-04 12:52:00', '审批通过，按方案推进修复。', '2025-05-05 12:52:00', NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-03 12:52:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-05 12:52:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0136' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-018' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '战国云雷纹带钩-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-05-05 12:52:00', @seed_admin_id, '2025-05-05 12:52:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0136' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '战国云雷纹带钩-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '战国云雷纹带钩-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-05-05 13:22:00', @seed_admin_id, '2025-05-05 13:22:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0136' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '战国云雷纹带钩-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-019', r.id, 'REL-DEMO-2026-0137', '元代粉彩香炉', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '长期存放后病害复发，需要重新修复。',
  'IN_PROGRESS', 'UNACCEPTED', '2025-05-05 13:59:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-05-06 13:59:00', '审批通过，按方案推进修复。', '2025-05-07 13:59:00', NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-05 13:59:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-07 13:59:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0137' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-019' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '元代粉彩香炉-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-05-07 13:59:00', @seed_admin_id, '2025-05-07 13:59:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0137' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '元代粉彩香炉-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '元代粉彩香炉-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-05-07 14:29:00', @seed_admin_id, '2025-05-07 14:29:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0137' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '元代粉彩香炉-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-020', r.id, 'REL-DEMO-2026-0138', '清代墨竹册页', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '器表腐蚀加重，需要开展清理与稳定性加固。',
  'IN_PROGRESS', 'UNACCEPTED', '2025-05-07 14:06:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-05-08 14:06:00', '审批通过，按方案推进修复。', '2025-05-09 14:06:00', NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-07 14:06:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-09 14:06:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0138' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-020' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '清代墨竹册页-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-05-09 14:06:00', @seed_admin_id, '2025-05-09 14:06:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0138' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '清代墨竹册页-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '清代墨竹册页-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-05-09 14:36:00', @seed_admin_id, '2025-05-09 14:36:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0138' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '清代墨竹册页-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-021', r.id, 'REL-DEMO-2026-0139', '新石器时代云龙纹玉圭', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '存在裂隙与结构松动，需要进行加固处理。',
  'IN_PROGRESS', 'UNACCEPTED', '2025-05-09 15:13:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-05-10 15:13:00', '审批通过，按方案推进修复。', '2025-05-11 15:13:00', NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-09 15:13:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-11 15:13:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0139' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-021' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '新石器时代云龙纹玉圭-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-05-11 15:13:00', @seed_admin_id, '2025-05-11 15:13:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0139' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '新石器时代云龙纹玉圭-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '新石器时代云龙纹玉圭-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-05-11 15:43:00', @seed_admin_id, '2025-05-11 15:43:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0139' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '新石器时代云龙纹玉圭-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-022', r.id, 'REL-DEMO-2026-0140', '唐代錾花银盘', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '表层彩绘起翘，需要实施病害处置。',
  'IN_PROGRESS', 'UNACCEPTED', '2025-05-11 09:20:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin04' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-05-12 09:20:00', '审批通过，按方案推进修复。', '2025-05-13 09:20:00', NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-11 09:20:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-13 09:20:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0140' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-022' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '唐代錾花银盘-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-05-13 09:20:00', @seed_admin_id, '2025-05-13 09:20:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0140' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '唐代錾花银盘-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '唐代錾花银盘-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-05-13 09:50:00', @seed_admin_id, '2025-05-13 09:50:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0140' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '唐代錾花银盘-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-023', r.id, 'REL-DEMO-2026-0141', '民国黄花梨佛像', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '馆藏调阅中发现局部缺损，需要修复评估。',
  'IN_PROGRESS', 'UNACCEPTED', '2025-05-13 10:27:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin05' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-05-14 10:27:00', '审批通过，按方案推进修复。', '2025-05-15 10:27:00', NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-13 10:27:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-15 10:27:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0141' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-023' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '民国黄花梨佛像-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-05-15 10:27:00', @seed_admin_id, '2025-05-15 10:27:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0141' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '民国黄花梨佛像-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '民国黄花梨佛像-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-05-15 10:57:00', @seed_admin_id, '2025-05-15 10:57:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0141' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '民国黄花梨佛像-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-024', r.id, 'REL-DEMO-2026-0142', '汉代黑漆漆壶', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '长期存放后病害复发，需要重新修复。',
  'IN_PROGRESS', 'UNACCEPTED', '2025-05-15 11:34:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-05-16 11:34:00', '审批通过，按方案推进修复。', '2025-05-17 11:34:00', NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-15 11:34:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-17 11:34:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0142' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-024' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '汉代黑漆漆壶-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-05-17 11:34:00', @seed_admin_id, '2025-05-17 11:34:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0142' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '汉代黑漆漆壶-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '汉代黑漆漆壶-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-05-17 12:04:00', @seed_admin_id, '2025-05-17 12:04:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0142' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '汉代黑漆漆壶-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-025', r.id, 'REL-DEMO-2026-0143', '北魏莲花座供养人像', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '器表腐蚀加重，需要开展清理与稳定性加固。',
  'IN_PROGRESS', 'UNACCEPTED', '2025-05-17 12:41:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-05-18 12:41:00', '审批通过，按方案推进修复。', '2025-05-19 12:41:00', NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-17 12:41:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-19 12:41:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0143' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-025' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '北魏莲花座供养人像-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-05-19 12:41:00', @seed_admin_id, '2025-05-19 12:41:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0143' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '北魏莲花座供养人像-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '北魏莲花座供养人像-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-05-19 13:11:00', @seed_admin_id, '2025-05-19 13:11:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0143' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '北魏莲花座供养人像-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-026', r.id, 'REL-DEMO-2026-0144', '战国漆书卷册', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '存在裂隙与结构松动，需要进行加固处理。',
  'IN_PROGRESS', 'UNACCEPTED', '2025-05-19 13:48:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-05-20 13:48:00', '审批通过，按方案推进修复。', '2025-05-21 13:48:00', NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-19 13:48:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-21 13:48:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0144' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-026' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '战国漆书卷册-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-05-21 13:48:00', @seed_admin_id, '2025-05-21 13:48:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0144' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '战国漆书卷册-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '战国漆书卷册-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-05-21 14:18:00', @seed_admin_id, '2025-05-21 14:18:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0144' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '战国漆书卷册-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-027', r.id, 'REL-DEMO-2026-0145', '战国蟠螭纹镜', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '表层彩绘起翘，需要实施病害处置。',
  'IN_PROGRESS', 'UNACCEPTED', '2025-05-21 14:55:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin04' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-05-22 14:55:00', '审批通过，按方案推进修复。', '2025-05-23 14:55:00', NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-21 14:55:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-23 14:55:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0145' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-027' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '战国蟠螭纹镜-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-05-23 14:55:00', @seed_admin_id, '2025-05-23 14:55:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0145' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '战国蟠螭纹镜-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '战国蟠螭纹镜-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-05-23 15:25:00', @seed_admin_id, '2025-05-23 15:25:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0145' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '战国蟠螭纹镜-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-028', r.id, 'REL-DEMO-2026-0146', '明代刻花香炉', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '馆藏调阅中发现局部缺损，需要修复评估。',
  'COMPLETED', 'WAITING', '2025-05-23 15:02:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin05' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-05-24 15:02:00', '审批通过，按方案推进修复。', '2025-05-25 15:02:00', '2025-06-02 15:02:00',
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-23 15:02:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-02 15:02:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0146' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-028' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '明代刻花香炉-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-05-25 15:02:00', @seed_admin_id, '2025-05-25 15:02:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0146' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '明代刻花香炉-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '明代刻花香炉-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-05-25 15:32:00', @seed_admin_id, '2025-05-25 15:32:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0146' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '明代刻花香炉-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-029', r.id, 'REL-DEMO-2026-0147', '宋代仕女册页', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '长期存放后病害复发，需要重新修复。',
  'COMPLETED', 'WAITING', '2025-05-25 09:09:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-05-26 09:09:00', '审批通过，按方案推进修复。', '2025-05-27 09:09:00', '2025-06-05 09:09:00',
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-25 09:09:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-05 09:09:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0147' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-029' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '宋代仕女册页-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-05-27 09:09:00', @seed_admin_id, '2025-05-27 09:09:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0147' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '宋代仕女册页-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '宋代仕女册页-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-05-27 09:39:00', @seed_admin_id, '2025-05-27 09:39:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0147' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '宋代仕女册页-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-030', r.id, 'REL-DEMO-2026-0148', '战国凤鸟纹玉璧', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '器表腐蚀加重，需要开展清理与稳定性加固。',
  'COMPLETED', 'WAITING', '2025-05-27 10:16:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-05-28 10:16:00', '审批通过，按方案推进修复。', '2025-05-29 10:16:00', '2025-06-08 10:16:00',
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-27 10:16:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-08 10:16:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0148' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-030' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '战国凤鸟纹玉璧-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-05-29 10:16:00', @seed_admin_id, '2025-05-29 10:16:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0148' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '战国凤鸟纹玉璧-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '战国凤鸟纹玉璧-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-05-29 10:46:00', @seed_admin_id, '2025-05-29 10:46:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0148' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '战国凤鸟纹玉璧-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-031', r.id, 'REL-DEMO-2026-0149', '宋代錾刻执壶', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '存在裂隙与结构松动，需要进行加固处理。',
  'COMPLETED', 'WAITING', '2025-05-29 11:23:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-05-30 11:23:00', '审批通过，按方案推进修复。', '2025-05-31 11:23:00', '2025-06-11 11:23:00',
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-29 11:23:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-11 11:23:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0149' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-031' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '宋代錾刻执壶-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-05-31 11:23:00', @seed_admin_id, '2025-05-31 11:23:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0149' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '宋代錾刻执壶-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '宋代錾刻执壶-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-05-31 11:53:00', @seed_admin_id, '2025-05-31 11:53:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0149' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '宋代錾刻执壶-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-032', r.id, 'REL-DEMO-2026-0150', '明代黄花梨经匣', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '表层彩绘起翘，需要实施病害处置。',
  'COMPLETED', 'WAITING', '2025-05-31 12:30:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin04' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-06-01 12:30:00', '审批通过，按方案推进修复。', '2025-06-02 12:30:00', '2025-06-10 12:30:00',
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-05-31 12:30:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-10 12:30:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0150' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-032' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '明代黄花梨经匣-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-06-02 12:30:00', @seed_admin_id, '2025-06-02 12:30:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0150' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '明代黄花梨经匣-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '明代黄花梨经匣-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-06-02 13:00:00', @seed_admin_id, '2025-06-02 13:00:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0150' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '明代黄花梨经匣-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-033', r.id, 'REL-DEMO-2026-0151', '明代黑漆漆壶', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '馆藏调阅中发现局部缺损，需要修复评估。',
  'COMPLETED', 'WAITING', '2025-06-02 13:37:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin05' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-06-03 13:37:00', '审批通过，按方案推进修复。', '2025-06-04 13:37:00', '2025-06-13 13:37:00',
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher08' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-02 13:37:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-13 13:37:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0151' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-033' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '明代黑漆漆壶-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-06-04 13:37:00', @seed_admin_id, '2025-06-04 13:37:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0151' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '明代黑漆漆壶-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '明代黑漆漆壶-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-06-04 14:07:00', @seed_admin_id, '2025-06-04 14:07:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0151' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '明代黑漆漆壶-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-034', r.id, 'REL-DEMO-2026-0152', '唐代造像碑立像', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '长期存放后病害复发，需要重新修复。',
  'COMPLETED', 'WAITING', '2025-06-04 14:44:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-06-05 14:44:00', '审批通过，按方案推进修复。', '2025-06-06 14:44:00', '2025-06-16 14:44:00',
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher09' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-04 14:44:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-16 14:44:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0152' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-034' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '唐代造像碑立像-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-06-06 14:44:00', @seed_admin_id, '2025-06-06 14:44:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0152' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '唐代造像碑立像-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '唐代造像碑立像-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-06-06 15:14:00', @seed_admin_id, '2025-06-06 15:14:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0152' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '唐代造像碑立像-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-035', r.id, 'REL-DEMO-2026-0153', '汉代漆书卷册', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '器表腐蚀加重，需要开展清理与稳定性加固。',
  'COMPLETED', 'WAITING', '2025-06-06 15:51:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-06-07 15:51:00', '审批通过，按方案推进修复。', '2025-06-08 15:51:00', '2025-06-19 15:51:00',
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-06 15:51:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-06-19 15:51:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0153' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-035' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '汉代漆书卷册-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-06-08 15:51:00', @seed_admin_id, '2025-06-08 15:51:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0153' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '汉代漆书卷册-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '汉代漆书卷册-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-06-08 16:21:00', @seed_admin_id, '2025-06-08 16:21:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0153' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '汉代漆书卷册-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-036', r.id, 'REL-DEMO-2026-0171', '宋代编联竹简', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '存在裂隙与结构松动，需要进行加固处理。',
  'ACCEPTED', 'SUCCESS', '2025-07-12 12:57:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-07-13 12:57:00', '审批通过，按方案推进修复。', '2025-07-14 12:57:00', '2025-07-22 12:57:00',
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-12 12:57:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-22 12:57:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0171' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-036' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '宋代编联竹简-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-07-14 12:57:00', @seed_admin_id, '2025-07-14 12:57:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0171' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '宋代编联竹简-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '宋代编联竹简-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-07-14 13:27:00', @seed_admin_id, '2025-07-14 13:27:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0171' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '宋代编联竹简-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-037', r.id, 'REL-DEMO-2026-0172', '汉代云雷纹带钩', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '表层彩绘起翘，需要实施病害处置。',
  'ACCEPTED', 'SUCCESS', '2025-07-14 13:04:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin04' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-07-15 13:04:00', '审批通过，按方案推进修复。', '2025-07-16 13:04:00', '2025-07-25 13:04:00',
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-14 13:04:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-25 13:04:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0172' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-037' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '汉代云雷纹带钩-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-07-16 13:04:00', @seed_admin_id, '2025-07-16 13:04:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0172' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '汉代云雷纹带钩-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '汉代云雷纹带钩-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-07-16 13:34:00', @seed_admin_id, '2025-07-16 13:34:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0172' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '汉代云雷纹带钩-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-038', r.id, 'REL-DEMO-2026-0173', '元代粉彩香炉', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '馆藏调阅中发现局部缺损，需要修复评估。',
  'ACCEPTED', 'SUCCESS', '2025-07-16 14:11:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin05' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-07-17 14:11:00', '审批通过，按方案推进修复。', '2025-07-18 14:11:00', '2025-07-28 14:11:00',
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher13' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-16 14:11:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-28 14:11:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0173' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-038' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '元代粉彩香炉-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-07-18 14:11:00', @seed_admin_id, '2025-07-18 14:11:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0173' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '元代粉彩香炉-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '元代粉彩香炉-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-07-18 14:41:00', @seed_admin_id, '2025-07-18 14:41:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0173' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '元代粉彩香炉-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-039', r.id, 'REL-DEMO-2026-0174', '元代花鸟手卷', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '长期存放后病害复发，需要重新修复。',
  'ACCEPTED', 'SUCCESS', '2025-07-18 15:18:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-07-19 15:18:00', '审批通过，按方案推进修复。', '2025-07-20 15:18:00', '2025-07-31 15:18:00',
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-18 15:18:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-31 15:18:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0174' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-039' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '元代花鸟手卷-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-07-20 15:18:00', @seed_admin_id, '2025-07-20 15:18:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0174' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '元代花鸟手卷-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '元代花鸟手卷-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-07-20 15:48:00', @seed_admin_id, '2025-07-20 15:48:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0174' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '元代花鸟手卷-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-040', r.id, 'REL-DEMO-2026-0175', '商代谷纹带钩', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '器表腐蚀加重，需要开展清理与稳定性加固。',
  'ACCEPTED', 'SUCCESS', '2025-07-20 09:25:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-07-21 09:25:00', '审批通过，按方案推进修复。', '2025-07-22 09:25:00', '2025-07-30 09:25:00',
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-20 09:25:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-30 09:25:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0175' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-040' AND deleted = 0);

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_IMAGE', '商代谷纹带钩-修复过程图.png', '/uploads/demo/images/relic-placeholder.png', 68, 'png', '批量生成的修复过程图片占位文件。', @seed_admin_id, '2025-07-22 09:25:00', @seed_admin_id, '2025-07-22 09:25:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0175' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_IMAGE' AND a.file_name = '商代谷纹带钩-修复过程图.png' AND a.deleted = 0
  );

INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, 'REPAIR_FILE', '商代谷纹带钩-修复说明.txt', '/uploads/demo/repair/repair-log-note.txt', 24, 'txt', '批量生成的修复说明占位文件。', @seed_admin_id, '2025-07-22 09:55:00', @seed_admin_id, '2025-07-22 09:55:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0175' AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = 'REPAIR_FILE' AND a.file_name = '商代谷纹带钩-修复说明.txt' AND a.deleted = 0
  );

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-041', r.id, 'REL-DEMO-2026-0176', '清代掐丝香囊', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '存在裂隙与结构松动，需要进行加固处理。',
  'REJECTED', 'UNACCEPTED', '2025-07-22 10:32:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-07-23 10:32:00', '当前病害风险可控，建议先加强保管观察。', NULL, NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-22 10:32:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-23 10:32:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0176' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-041' AND deleted = 0);

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-042', r.id, 'REL-DEMO-2026-0177', '民国描金香几', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '表层彩绘起翘，需要实施病害处置。',
  'REJECTED', 'UNACCEPTED', '2025-07-24 11:39:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin04' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-07-25 11:39:00', '当前病害风险可控，建议先加强保管观察。', NULL, NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-24 11:39:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-25 11:39:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0177' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-042' AND deleted = 0);

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-043', r.id, 'REL-DEMO-2026-0178', '汉代剔红漆盒', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '馆藏调阅中发现局部缺损，需要修复评估。',
  'REJECTED', 'UNACCEPTED', '2025-07-26 12:46:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin05' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-07-27 12:46:00', '当前病害风险可控，建议先加强保管观察。', NULL, NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-26 12:46:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-27 12:46:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0178' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-043' AND deleted = 0);

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-044', r.id, 'REL-DEMO-2026-0179', '宋代造像碑供养人像', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '长期存放后病害复发，需要重新修复。',
  'REJECTED', 'UNACCEPTED', '2025-07-28 13:53:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-07-29 13:53:00', '当前病害风险可控，建议先加强保管观察。', NULL, NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-28 13:53:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-29 13:53:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0179' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-044' AND deleted = 0);

INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'REP-DEMO-2026-045', r.id, 'REL-DEMO-2026-0180', '明代编联竹简', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '器表腐蚀加重，需要开展清理与稳定性加固。',
  'REJECTED', 'UNACCEPTED', '2025-07-30 14:00:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id),
  '2025-07-31 14:00:00', '当前病害风险可控，建议先加强保管观察。', NULL, NULL,
  '批量生成的修复业务测试数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-30 14:00:00', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-31 14:00:00', 0
FROM relic r
WHERE r.relic_no = 'REL-DEMO-2026-0180' AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = 'REP-DEMO-2026-045' AND deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-001', '唐代刻花梅瓶清理与稳定化方案', '针对唐代刻花梅瓶当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '明胶、脱盐水、缓冲棉', '施工过程中需控制局部受力，避免二次损伤。', 'APPROVED',
  '姚菲', '陈昊', '2025-06-29 12:08:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-06-29 12:08:00', @seed_admin_id, '2025-06-29 12:08:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-011' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-002', '清代仕女手卷修复方案', '针对清代仕女手卷当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '支撑架、树脂材料、记录标签', '病害处置完成后需安排阶段性复核。', 'APPROVED',
  '李博', '许薇', '2025-07-01 13:15:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-07-01 13:15:00', @seed_admin_id, '2025-07-01 13:15:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-012' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-003', '商代素面玉璧清理与稳定化方案', '针对商代素面玉璧当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '支撑架、树脂材料、记录标签', '修复前后均需完成高清影像留存。', 'APPROVED',
  '王蕾', '刘舟', '2025-07-03 14:22:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-07-03 14:22:00', @seed_admin_id, '2025-07-03 14:22:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-013' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-004', '宋代錾刻带扣加固与补配方案', '针对宋代錾刻带扣当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '无酸纸、支撑纱、加固剂', '涉及彩绘与表面层的操作应减少接触频次。', 'APPROVED',
  '周洋', '管理员', '2025-07-05 15:29:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-07-05 15:29:00', @seed_admin_id, '2025-07-05 15:29:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-014' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-005', '清代描金佛像病害处置方案', '针对清代描金佛像当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '明胶、脱盐水、缓冲棉', '病害处置完成后需安排阶段性复核。', 'APPROVED',
  '林清', '赵楠', '2025-07-07 09:36:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-07-07 09:36:00', @seed_admin_id, '2025-07-07 09:36:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-015' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-006', '民国剔红漆盘加固与补配方案', '针对民国剔红漆盘当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '明胶、脱盐水、缓冲棉', '修复前后均需完成高清影像留存。', 'APPROVED',
  '何远', '陈昊', '2025-07-09 10:43:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-07-09 10:43:00', @seed_admin_id, '2025-07-09 10:43:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-016' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-007', '北魏莲花座石刻残件加固与补配方案', '针对北魏莲花座石刻残件当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '矿物颜料、保护胶、无纺布', '修复前后均需完成高清影像留存。', 'APPROVED',
  '苏瑶', '许薇', '2025-07-11 11:50:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-07-11 11:50:00', @seed_admin_id, '2025-07-11 11:50:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-017' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-008', '战国云雷纹带钩清理与稳定化方案', '针对战国云雷纹带钩当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '无酸纸、支撑纱、加固剂', '涉及彩绘与表面层的操作应减少接触频次。', 'APPROVED',
  '郑川', '刘舟', '2025-05-04 12:52:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-05-04 12:52:00', @seed_admin_id, '2025-05-04 12:52:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-018' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-009', '元代粉彩香炉加固与补配方案', '针对元代粉彩香炉当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '矿物颜料、保护胶、无纺布', '病害处置完成后需安排阶段性复核。', 'APPROVED',
  '宋宁', '管理员', '2025-05-06 13:59:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-05-06 13:59:00', @seed_admin_id, '2025-05-06 13:59:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-019' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-010', '清代墨竹册页加固与补配方案', '针对清代墨竹册页当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '矿物颜料、保护胶、无纺布', '涉及彩绘与表面层的操作应减少接触频次。', 'APPROVED',
  '魏安', '赵楠', '2025-05-08 14:06:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-05-08 14:06:00', @seed_admin_id, '2025-05-08 14:06:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-020' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-011', '新石器时代云龙纹玉圭修复方案', '针对新石器时代云龙纹玉圭当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '矿物颜料、保护胶、无纺布', '涉及彩绘与表面层的操作应减少接触频次。', 'APPROVED',
  '唐蕾', '陈昊', '2025-05-10 15:13:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-05-10 15:13:00', @seed_admin_id, '2025-05-10 15:13:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-021' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-012', '唐代錾花银盘修复方案', '针对唐代錾花银盘当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '无酸纸、支撑纱、加固剂', '涉及彩绘与表面层的操作应减少接触频次。', 'APPROVED',
  '韩卓', '许薇', '2025-05-12 09:20:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-05-12 09:20:00', @seed_admin_id, '2025-05-12 09:20:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-022' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-013', '民国黄花梨佛像加固与补配方案', '针对民国黄花梨佛像当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '无酸纸、支撑纱、加固剂', '涉及彩绘与表面层的操作应减少接触频次。', 'APPROVED',
  '顾琳', '刘舟', '2025-05-14 10:27:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-05-14 10:27:00', @seed_admin_id, '2025-05-14 10:27:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-023' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-014', '汉代黑漆漆壶修复方案', '针对汉代黑漆漆壶当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '明胶、脱盐水、缓冲棉', '施工过程中需控制局部受力，避免二次损伤。', 'APPROVED',
  '罗宁', '管理员', '2025-05-16 11:34:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-05-16 11:34:00', @seed_admin_id, '2025-05-16 11:34:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-024' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-015', '北魏莲花座供养人像清理与稳定化方案', '针对北魏莲花座供养人像当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '明胶、脱盐水、缓冲棉', '涉及彩绘与表面层的操作应减少接触频次。', 'APPROVED',
  '姚菲', '赵楠', '2025-05-18 12:41:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-05-18 12:41:00', @seed_admin_id, '2025-05-18 12:41:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-025' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-016', '战国漆书卷册加固与补配方案', '针对战国漆书卷册当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '无酸纸、支撑纱、加固剂', '施工过程中需控制局部受力，避免二次损伤。', 'APPROVED',
  '李博', '陈昊', '2025-05-20 13:48:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-05-20 13:48:00', @seed_admin_id, '2025-05-20 13:48:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-026' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-017', '战国蟠螭纹镜清理与稳定化方案', '针对战国蟠螭纹镜当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '矿物颜料、保护胶、无纺布', '涉及彩绘与表面层的操作应减少接触频次。', 'APPROVED',
  '王蕾', '许薇', '2025-05-22 14:55:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-05-22 14:55:00', @seed_admin_id, '2025-05-22 14:55:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-027' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-018', '明代刻花香炉病害处置方案', '针对明代刻花香炉当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '明胶、脱盐水、缓冲棉', '修复前后均需完成高清影像留存。', 'APPROVED',
  '周洋', '刘舟', '2025-05-24 15:02:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-05-24 15:02:00', @seed_admin_id, '2025-05-24 15:02:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-028' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-019', '宋代仕女册页加固与补配方案', '针对宋代仕女册页当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '矿物颜料、保护胶、无纺布', '病害处置完成后需安排阶段性复核。', 'APPROVED',
  '林清', '管理员', '2025-05-26 09:09:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-05-26 09:09:00', @seed_admin_id, '2025-05-26 09:09:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-029' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-020', '战国凤鸟纹玉璧加固与补配方案', '针对战国凤鸟纹玉璧当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '支撑架、树脂材料、记录标签', '施工过程中需控制局部受力，避免二次损伤。', 'APPROVED',
  '何远', '赵楠', '2025-05-28 10:16:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-05-28 10:16:00', @seed_admin_id, '2025-05-28 10:16:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-030' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-021', '宋代錾刻执壶清理与稳定化方案', '针对宋代錾刻执壶当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '明胶、脱盐水、缓冲棉', '修复前后均需完成高清影像留存。', 'APPROVED',
  '苏瑶', '陈昊', '2025-05-30 11:23:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-05-30 11:23:00', @seed_admin_id, '2025-05-30 11:23:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-031' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-022', '明代黄花梨经匣加固与补配方案', '针对明代黄花梨经匣当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '矿物颜料、保护胶、无纺布', '涉及彩绘与表面层的操作应减少接触频次。', 'APPROVED',
  '郑川', '许薇', '2025-06-01 12:30:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-06-01 12:30:00', @seed_admin_id, '2025-06-01 12:30:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-032' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-023', '明代黑漆漆壶加固与补配方案', '针对明代黑漆漆壶当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '明胶、脱盐水、缓冲棉', '病害处置完成后需安排阶段性复核。', 'APPROVED',
  '宋宁', '刘舟', '2025-06-03 13:37:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-06-03 13:37:00', @seed_admin_id, '2025-06-03 13:37:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-033' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-024', '唐代造像碑立像加固与补配方案', '针对唐代造像碑立像当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '矿物颜料、保护胶、无纺布', '病害处置完成后需安排阶段性复核。', 'APPROVED',
  '魏安', '管理员', '2025-06-05 14:44:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-06-05 14:44:00', @seed_admin_id, '2025-06-05 14:44:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-034' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-025', '汉代漆书卷册病害处置方案', '针对汉代漆书卷册当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '明胶、脱盐水、缓冲棉', '病害处置完成后需安排阶段性复核。', 'APPROVED',
  '唐蕾', '赵楠', '2025-06-07 15:51:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-06-07 15:51:00', @seed_admin_id, '2025-06-07 15:51:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-035' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-026', '宋代编联竹简病害处置方案', '针对宋代编联竹简当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '支撑架、树脂材料、记录标签', '修复前后均需完成高清影像留存。', 'APPROVED',
  '韩卓', '陈昊', '2025-07-13 12:57:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-07-13 12:57:00', @seed_admin_id, '2025-07-13 12:57:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-036' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-027', '汉代云雷纹带钩加固与补配方案', '针对汉代云雷纹带钩当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '支撑架、树脂材料、记录标签', '施工过程中需控制局部受力，避免二次损伤。', 'APPROVED',
  '顾琳', '许薇', '2025-07-15 13:04:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-07-15 13:04:00', @seed_admin_id, '2025-07-15 13:04:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-037' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-028', '元代粉彩香炉修复方案', '针对元代粉彩香炉当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '支撑架、树脂材料、记录标签', '涉及彩绘与表面层的操作应减少接触频次。', 'APPROVED',
  '罗宁', '刘舟', '2025-07-17 14:11:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-07-17 14:11:00', @seed_admin_id, '2025-07-17 14:11:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-038' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-029', '元代花鸟手卷清理与稳定化方案', '针对元代花鸟手卷当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '矿物颜料、保护胶、无纺布', '涉及彩绘与表面层的操作应减少接触频次。', 'APPROVED',
  '姚菲', '管理员', '2025-07-19 15:18:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-07-19 15:18:00', @seed_admin_id, '2025-07-19 15:18:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-039' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'PLAN-DEMO-2026-030', '商代谷纹带钩病害处置方案', '针对商代谷纹带钩当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。', '矿物颜料、保护胶、无纺布', '修复前后均需完成高清影像留存。', 'APPROVED',
  '李博', '赵楠', '2025-07-21 09:25:00', '方案内容完整，可按计划执行。', @seed_admin_id, '2025-07-21 09:25:00', @seed_admin_id, '2025-07-21 09:25:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-040' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-001', '表面清理', '对表面浮尘、附着物进行低干预清理。', '无酸纸、支撑纱、加固剂', '郑川', '2025-05-05 12:52:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-05 12:52:00', @seed_admin_id, '2025-05-05 12:52:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-018' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-001' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-002', '结构加固', '针对脆弱部位开展加固处理并完成稳定性复核。', '明胶、脱盐水、缓冲棉', '郑川', '2025-05-06 12:52:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-06 12:52:00', @seed_admin_id, '2025-05-06 12:52:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-018' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-002' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-003', '结构加固', '针对脆弱部位开展加固处理并完成稳定性复核。', '矿物颜料、保护胶、无纺布', '宋宁', '2025-05-07 13:59:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-07 13:59:00', @seed_admin_id, '2025-05-07 13:59:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-019' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-003' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-004', '颜色协调', '补录修复过程资料并形成归档说明。', '明胶、脱盐水、缓冲棉', '宋宁', '2025-05-08 13:59:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-08 13:59:00', @seed_admin_id, '2025-05-08 13:59:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-019' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-004' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-005', '颜色协调', '补录修复过程资料并形成归档说明。', '矿物颜料、保护胶、无纺布', '魏安', '2025-05-09 14:06:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-09 14:06:00', @seed_admin_id, '2025-05-09 14:06:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-020' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-005' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-006', '病害复核', '对表面浮尘、附着物进行低干预清理。', '支撑架、树脂材料、记录标签', '魏安', '2025-05-10 14:06:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-10 14:06:00', @seed_admin_id, '2025-05-10 14:06:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-020' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-006' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-007', '病害复核', '对表面浮尘、附着物进行低干预清理。', '支撑架、树脂材料、记录标签', '唐蕾', '2025-05-11 15:13:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-11 15:13:00', @seed_admin_id, '2025-05-11 15:13:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-021' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-007' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-008', '裂隙处理', '针对脆弱部位开展加固处理并完成稳定性复核。', '矿物颜料、保护胶、无纺布', '唐蕾', '2025-05-12 15:13:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-12 15:13:00', @seed_admin_id, '2025-05-12 15:13:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-021' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-008' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-009', '裂隙处理', '针对脆弱部位开展加固处理并完成稳定性复核。', '矿物颜料、保护胶、无纺布', '韩卓', '2025-05-13 09:20:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-13 09:20:00', @seed_admin_id, '2025-05-13 09:20:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-022' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-009' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-010', '补配与校正', '补录修复过程资料并形成归档说明。', '无酸纸、支撑纱、加固剂', '韩卓', '2025-05-14 09:20:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-14 09:20:00', @seed_admin_id, '2025-05-14 09:20:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-022' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-010' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-011', '补配与校正', '补录修复过程资料并形成归档说明。', '无酸纸、支撑纱、加固剂', '顾琳', '2025-05-15 10:27:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-15 10:27:00', @seed_admin_id, '2025-05-15 10:27:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-023' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-011' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-012', '记录归档', '对表面浮尘、附着物进行低干预清理。', '矿物颜料、保护胶、无纺布', '顾琳', '2025-05-16 10:27:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-16 10:27:00', @seed_admin_id, '2025-05-16 10:27:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-023' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-012' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-013', '记录归档', '对表面浮尘、附着物进行低干预清理。', '无酸纸、支撑纱、加固剂', '罗宁', '2025-05-17 11:34:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-17 11:34:00', @seed_admin_id, '2025-05-17 11:34:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-024' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-013' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-014', '表面清理', '针对脆弱部位开展加固处理并完成稳定性复核。', '矿物颜料、保护胶、无纺布', '罗宁', '2025-05-18 11:34:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-18 11:34:00', @seed_admin_id, '2025-05-18 11:34:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-024' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-014' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-015', '表面清理', '针对脆弱部位开展加固处理并完成稳定性复核。', '明胶、脱盐水、缓冲棉', '姚菲', '2025-05-19 12:41:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-19 12:41:00', @seed_admin_id, '2025-05-19 12:41:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-025' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-015' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-016', '结构加固', '补录修复过程资料并形成归档说明。', '无酸纸、支撑纱、加固剂', '姚菲', '2025-05-20 12:41:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-20 12:41:00', @seed_admin_id, '2025-05-20 12:41:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-025' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-016' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-017', '结构加固', '补录修复过程资料并形成归档说明。', '矿物颜料、保护胶、无纺布', '李博', '2025-05-21 13:48:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-21 13:48:00', @seed_admin_id, '2025-05-21 13:48:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-026' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-017' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-018', '颜色协调', '对表面浮尘、附着物进行低干预清理。', '明胶、脱盐水、缓冲棉', '李博', '2025-05-22 13:48:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-22 13:48:00', @seed_admin_id, '2025-05-22 13:48:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-026' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-018' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-019', '颜色协调', '对表面浮尘、附着物进行低干预清理。', '无酸纸、支撑纱、加固剂', '王蕾', '2025-05-23 14:55:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-23 14:55:00', @seed_admin_id, '2025-05-23 14:55:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-027' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-019' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-020', '病害复核', '针对脆弱部位开展加固处理并完成稳定性复核。', '明胶、脱盐水、缓冲棉', '王蕾', '2025-05-24 14:55:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-24 14:55:00', @seed_admin_id, '2025-05-24 14:55:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-027' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-020' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-021', '病害复核', '针对脆弱部位开展加固处理并完成稳定性复核。', '无酸纸、支撑纱、加固剂', '周洋', '2025-05-25 15:02:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-25 15:02:00', @seed_admin_id, '2025-05-25 15:02:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-028' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-021' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-022', '裂隙处理', '补录修复过程资料并形成归档说明。', '明胶、脱盐水、缓冲棉', '周洋', '2025-05-26 15:02:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-26 15:02:00', @seed_admin_id, '2025-05-26 15:02:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-028' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-022' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-023', '补配与校正', '对表面浮尘、附着物进行低干预清理。', '矿物颜料、保护胶、无纺布', '周洋', '2025-05-27 15:02:00',
  'COMPLETED', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-27 15:02:00', @seed_admin_id, '2025-05-27 15:02:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-028' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-023' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-024', '结构加固', '完成病害点位复核并建立修复影像记录。', '矿物颜料、保护胶、无纺布', '林清', '2025-05-27 09:09:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-27 09:09:00', @seed_admin_id, '2025-05-27 09:09:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-029' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-024' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-025', '颜色协调', '对裂隙与断口进行支撑固定和局部黏结。', '无酸纸、支撑纱、加固剂', '林清', '2025-05-28 09:09:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-28 09:09:00', @seed_admin_id, '2025-05-28 09:09:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-029' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-025' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-026', '病害复核', '完成局部补配、校正与协调处理。', '无酸纸、支撑纱、加固剂', '林清', '2025-05-29 09:09:00',
  'COMPLETED', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-29 09:09:00', @seed_admin_id, '2025-05-29 09:09:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-029' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-026' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-027', '记录归档', '针对脆弱部位开展加固处理并完成稳定性复核。', '无酸纸、支撑纱、加固剂', '何远', '2025-05-29 10:16:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-29 10:16:00', @seed_admin_id, '2025-05-29 10:16:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-030' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-027' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-028', '表面清理', '补录修复过程资料并形成归档说明。', '支撑架、树脂材料、记录标签', '何远', '2025-05-30 10:16:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-30 10:16:00', @seed_admin_id, '2025-05-30 10:16:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-030' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-028' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-029', '结构加固', '对表面浮尘、附着物进行低干预清理。', '支撑架、树脂材料、记录标签', '何远', '2025-05-31 10:16:00',
  'COMPLETED', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-31 10:16:00', @seed_admin_id, '2025-05-31 10:16:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-030' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-029' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-030', '裂隙处理', '完成病害点位复核并建立修复影像记录。', '明胶、脱盐水、缓冲棉', '苏瑶', '2025-05-31 11:23:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-05-31 11:23:00', @seed_admin_id, '2025-05-31 11:23:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-031' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-030' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-031', '补配与校正', '对裂隙与断口进行支撑固定和局部黏结。', '矿物颜料、保护胶、无纺布', '苏瑶', '2025-06-01 11:23:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-06-01 11:23:00', @seed_admin_id, '2025-06-01 11:23:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-031' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-031' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-032', '记录归档', '完成局部补配、校正与协调处理。', '矿物颜料、保护胶、无纺布', '苏瑶', '2025-06-02 11:23:00',
  'COMPLETED', '批量生成的修复过程记录。', @seed_admin_id, '2025-06-02 11:23:00', @seed_admin_id, '2025-06-02 11:23:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-031' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-032' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-033', '颜色协调', '针对脆弱部位开展加固处理并完成稳定性复核。', '明胶、脱盐水、缓冲棉', '郑川', '2025-06-02 12:30:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-06-02 12:30:00', @seed_admin_id, '2025-06-02 12:30:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-032' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-033' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-034', '病害复核', '补录修复过程资料并形成归档说明。', '无酸纸、支撑纱、加固剂', '郑川', '2025-06-03 12:30:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-06-03 12:30:00', @seed_admin_id, '2025-06-03 12:30:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-032' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-034' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-035', '裂隙处理', '对表面浮尘、附着物进行低干预清理。', '明胶、脱盐水、缓冲棉', '郑川', '2025-06-04 12:30:00',
  'COMPLETED', '批量生成的修复过程记录。', @seed_admin_id, '2025-06-04 12:30:00', @seed_admin_id, '2025-06-04 12:30:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-032' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-035' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-036', '表面清理', '完成病害点位复核并建立修复影像记录。', '明胶、脱盐水、缓冲棉', '宋宁', '2025-06-04 13:37:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-06-04 13:37:00', @seed_admin_id, '2025-06-04 13:37:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-033' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-036' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-037', '结构加固', '对裂隙与断口进行支撑固定和局部黏结。', '支撑架、树脂材料、记录标签', '宋宁', '2025-06-05 13:37:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-06-05 13:37:00', @seed_admin_id, '2025-06-05 13:37:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-033' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-037' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-038', '颜色协调', '完成局部补配、校正与协调处理。', '明胶、脱盐水、缓冲棉', '宋宁', '2025-06-06 13:37:00',
  'COMPLETED', '批量生成的修复过程记录。', @seed_admin_id, '2025-06-06 13:37:00', @seed_admin_id, '2025-06-06 13:37:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-033' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-038' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-039', '补配与校正', '针对脆弱部位开展加固处理并完成稳定性复核。', '支撑架、树脂材料、记录标签', '魏安', '2025-06-06 14:44:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-06-06 14:44:00', @seed_admin_id, '2025-06-06 14:44:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-034' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-039' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-040', '记录归档', '补录修复过程资料并形成归档说明。', '无酸纸、支撑纱、加固剂', '魏安', '2025-06-07 14:44:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-06-07 14:44:00', @seed_admin_id, '2025-06-07 14:44:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-034' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-040' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-041', '表面清理', '对表面浮尘、附着物进行低干预清理。', '明胶、脱盐水、缓冲棉', '魏安', '2025-06-08 14:44:00',
  'COMPLETED', '批量生成的修复过程记录。', @seed_admin_id, '2025-06-08 14:44:00', @seed_admin_id, '2025-06-08 14:44:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-034' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-041' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-042', '病害复核', '完成病害点位复核并建立修复影像记录。', '支撑架、树脂材料、记录标签', '唐蕾', '2025-06-08 15:51:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-06-08 15:51:00', @seed_admin_id, '2025-06-08 15:51:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-035' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-042' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-043', '裂隙处理', '对裂隙与断口进行支撑固定和局部黏结。', '矿物颜料、保护胶、无纺布', '唐蕾', '2025-06-09 15:51:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-06-09 15:51:00', @seed_admin_id, '2025-06-09 15:51:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-035' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-043' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-044', '补配与校正', '完成局部补配、校正与协调处理。', '无酸纸、支撑纱、加固剂', '唐蕾', '2025-06-10 15:51:00',
  'COMPLETED', '批量生成的修复过程记录。', @seed_admin_id, '2025-06-10 15:51:00', @seed_admin_id, '2025-06-10 15:51:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-035' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-044' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-045', '结构加固', '针对脆弱部位开展加固处理并完成稳定性复核。', '无酸纸、支撑纱、加固剂', '韩卓', '2025-07-14 12:57:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-07-14 12:57:00', @seed_admin_id, '2025-07-14 12:57:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-036' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-045' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-046', '颜色协调', '补录修复过程资料并形成归档说明。', '无酸纸、支撑纱、加固剂', '韩卓', '2025-07-15 12:57:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-07-15 12:57:00', @seed_admin_id, '2025-07-15 12:57:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-036' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-046' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-047', '病害复核', '对表面浮尘、附着物进行低干预清理。', '矿物颜料、保护胶、无纺布', '韩卓', '2025-07-16 12:57:00',
  'COMPLETED', '批量生成的修复过程记录。', @seed_admin_id, '2025-07-16 12:57:00', @seed_admin_id, '2025-07-16 12:57:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-036' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-047' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-048', '记录归档', '完成病害点位复核并建立修复影像记录。', '明胶、脱盐水、缓冲棉', '顾琳', '2025-07-16 13:04:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-07-16 13:04:00', @seed_admin_id, '2025-07-16 13:04:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-037' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-048' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-049', '表面清理', '对裂隙与断口进行支撑固定和局部黏结。', '无酸纸、支撑纱、加固剂', '顾琳', '2025-07-17 13:04:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-07-17 13:04:00', @seed_admin_id, '2025-07-17 13:04:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-037' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-049' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-050', '结构加固', '完成局部补配、校正与协调处理。', '无酸纸、支撑纱、加固剂', '顾琳', '2025-07-18 13:04:00',
  'COMPLETED', '批量生成的修复过程记录。', @seed_admin_id, '2025-07-18 13:04:00', @seed_admin_id, '2025-07-18 13:04:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-037' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-050' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-051', '裂隙处理', '针对脆弱部位开展加固处理并完成稳定性复核。', '矿物颜料、保护胶、无纺布', '罗宁', '2025-07-18 14:11:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-07-18 14:11:00', @seed_admin_id, '2025-07-18 14:11:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-038' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-051' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-052', '补配与校正', '补录修复过程资料并形成归档说明。', '支撑架、树脂材料、记录标签', '罗宁', '2025-07-19 14:11:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-07-19 14:11:00', @seed_admin_id, '2025-07-19 14:11:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-038' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-052' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-053', '记录归档', '对表面浮尘、附着物进行低干预清理。', '矿物颜料、保护胶、无纺布', '罗宁', '2025-07-20 14:11:00',
  'COMPLETED', '批量生成的修复过程记录。', @seed_admin_id, '2025-07-20 14:11:00', @seed_admin_id, '2025-07-20 14:11:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-038' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-053' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-054', '颜色协调', '完成病害点位复核并建立修复影像记录。', '矿物颜料、保护胶、无纺布', '姚菲', '2025-07-20 15:18:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-07-20 15:18:00', @seed_admin_id, '2025-07-20 15:18:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-039' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-054' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-055', '病害复核', '对裂隙与断口进行支撑固定和局部黏结。', '无酸纸、支撑纱、加固剂', '姚菲', '2025-07-21 15:18:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-07-21 15:18:00', @seed_admin_id, '2025-07-21 15:18:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-039' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-055' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-056', '裂隙处理', '完成局部补配、校正与协调处理。', '矿物颜料、保护胶、无纺布', '姚菲', '2025-07-22 15:18:00',
  'COMPLETED', '批量生成的修复过程记录。', @seed_admin_id, '2025-07-22 15:18:00', @seed_admin_id, '2025-07-22 15:18:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-039' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-056' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-057', '表面清理', '针对脆弱部位开展加固处理并完成稳定性复核。', '矿物颜料、保护胶、无纺布', '李博', '2025-07-22 09:25:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-07-22 09:25:00', @seed_admin_id, '2025-07-22 09:25:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-040' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-057' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-058', '结构加固', '补录修复过程资料并形成归档说明。', '无酸纸、支撑纱、加固剂', '李博', '2025-07-23 09:25:00',
  'IN_PROGRESS', '批量生成的修复过程记录。', @seed_admin_id, '2025-07-23 09:25:00', @seed_admin_id, '2025-07-23 09:25:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-040' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-058' AND deleted = 0);

INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'LOG-DEMO-2026-059', '颜色协调', '对表面浮尘、附着物进行低干预清理。', '支撑架、树脂材料、记录标签', '李博', '2025-07-24 09:25:00',
  'COMPLETED', '批量生成的修复过程记录。', @seed_admin_id, '2025-07-24 09:25:00', @seed_admin_id, '2025-07-24 09:25:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-040' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = 'LOG-DEMO-2026-059' AND deleted = 0);

INSERT INTO repair_acceptance (
  repair_task_id, acceptance_no, acceptance_result, acceptance_by, acceptance_time, acceptance_remark, follow_up_suggestion, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'ACC-DEMO-2026-001', 'PASS', COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-22 18:57:00', '修复质量符合馆藏验收要求，可转入常规保管。', '建议三个月后复核病害稳定性并补录阶段性照片。',
  @seed_admin_id, '2025-07-22 18:57:00', @seed_admin_id, '2025-07-22 18:57:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-036' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_acceptance a WHERE a.repair_task_id = t.id AND a.deleted = 0);

INSERT INTO repair_acceptance (
  repair_task_id, acceptance_no, acceptance_result, acceptance_by, acceptance_time, acceptance_remark, follow_up_suggestion, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'ACC-DEMO-2026-002', 'PASS', COALESCE((SELECT id FROM sys_user WHERE username = 'admin02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-25 19:04:00', '修复质量符合馆藏验收要求，可转入常规保管。', '建议三个月后复核病害稳定性并补录阶段性照片。',
  @seed_admin_id, '2025-07-25 19:04:00', @seed_admin_id, '2025-07-25 19:04:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-037' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_acceptance a WHERE a.repair_task_id = t.id AND a.deleted = 0);

INSERT INTO repair_acceptance (
  repair_task_id, acceptance_no, acceptance_result, acceptance_by, acceptance_time, acceptance_remark, follow_up_suggestion, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'ACC-DEMO-2026-003', 'PASS', COALESCE((SELECT id FROM sys_user WHERE username = 'admin03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-28 20:11:00', '修复质量符合馆藏验收要求，可转入常规保管。', '建议三个月后复核病害稳定性并补录阶段性照片。',
  @seed_admin_id, '2025-07-28 20:11:00', @seed_admin_id, '2025-07-28 20:11:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-038' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_acceptance a WHERE a.repair_task_id = t.id AND a.deleted = 0);

INSERT INTO repair_acceptance (
  repair_task_id, acceptance_no, acceptance_result, acceptance_by, acceptance_time, acceptance_remark, follow_up_suggestion, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'ACC-DEMO-2026-004', 'PASS', COALESCE((SELECT id FROM sys_user WHERE username = 'admin04' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-31 21:18:00', '修复质量符合馆藏验收要求，可转入常规保管。', '建议三个月后复核病害稳定性并补录阶段性照片。',
  @seed_admin_id, '2025-07-31 21:18:00', @seed_admin_id, '2025-07-31 21:18:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-039' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_acceptance a WHERE a.repair_task_id = t.id AND a.deleted = 0);

INSERT INTO repair_acceptance (
  repair_task_id, acceptance_no, acceptance_result, acceptance_by, acceptance_time, acceptance_remark, follow_up_suggestion, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, 'ACC-DEMO-2026-005', 'PASS', COALESCE((SELECT id FROM sys_user WHERE username = 'admin05' AND deleted = 0 LIMIT 1), @seed_admin_id), '2025-07-30 15:25:00', '修复质量符合馆藏验收要求，可转入常规保管。', '建议三个月后复核病害稳定性并补录阶段性照片。',
  @seed_admin_id, '2025-07-30 15:25:00', @seed_admin_id, '2025-07-30 15:25:00', 0
FROM repair_task t
WHERE t.task_no = 'REP-DEMO-2026-040' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_acceptance a WHERE a.repair_task_id = t.id AND a.deleted = 0);

INSERT INTO inventory_task (
  task_no, task_name, location_code, task_status, start_time, end_time, principal_name, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'INV-DEMO-2026-001', '一号综合库季度盘点', 'LOC_A', 'COMPLETED', '2026-03-07 09:00:00', '2026-03-07 17:00:00', '唐蕾',
  '批量生成的盘点任务数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2026-03-07 09:00:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2026-03-07 17:00:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM inventory_task WHERE task_no = 'INV-DEMO-2026-001' AND deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0005', '唐代累丝带扣', 1, 0,
  -1, '盘点时文物暂未在指定库位发现，已发起复核。', 'DIFF_FOUND',
  @seed_admin_id, '2026-03-07 09:00:00', @seed_admin_id, '2026-03-07 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0005' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-001' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0010', '汉代云雷纹镜', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-07 09:12:00', @seed_admin_id, '2026-03-07 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0010' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-001' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0018', '汉代题记册页', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-07 09:24:00', @seed_admin_id, '2026-03-07 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0018' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-001' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0022', '商代素面带钩', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-07 09:36:00', @seed_admin_id, '2026-03-07 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0022' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-001' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0025', '汉代描金漆盘', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-07 09:48:00', @seed_admin_id, '2026-03-07 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0025' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-001' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0040', '新石器时代云龙纹玉琮', 1, 1,
  0, NULL, 'CHECKED',
  @seed_admin_id, '2026-03-07 10:00:00', @seed_admin_id, '2026-03-07 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0040' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-001' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0050', '清代累丝执壶', 1, 0,
  -1, '盘点时文物暂未在指定库位发现，已发起复核。', 'DIFF_FOUND',
  @seed_admin_id, '2026-03-07 10:12:00', @seed_admin_id, '2026-03-07 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0050' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-001' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0060', '清代黄花梨佛像', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-07 10:24:00', @seed_admin_id, '2026-03-07 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0060' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-001' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0061', '明代黑漆漆奁', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-07 10:36:00', @seed_admin_id, '2026-03-07 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0061' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-001' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0075', '民国仕女册页', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-07 10:48:00', @seed_admin_id, '2026-03-07 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0075' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-001' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0078', '清代描金经匣', 1, 1,
  0, NULL, 'CHECKED',
  @seed_admin_id, '2026-03-07 11:00:00', @seed_admin_id, '2026-03-07 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0078' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-001' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0081', '战国墨书木牍', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-07 11:12:00', @seed_admin_id, '2026-03-07 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0081' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-001' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task (
  task_no, task_name, location_code, task_status, start_time, end_time, principal_name, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'INV-DEMO-2026-002', '二号恒温库专项盘点', 'LOC_B', 'COMPLETED', '2026-03-11 09:00:00', '2026-03-11 17:00:00', '唐蕾',
  '批量生成的盘点任务数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2026-03-11 09:00:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher10' AND deleted = 0 LIMIT 1), @seed_admin_id), '2026-03-11 17:00:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM inventory_task WHERE task_no = 'INV-DEMO-2026-002' AND deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0002', '明代印花罐', 1, 0,
  -1, '盘点时文物暂未在指定库位发现，已发起复核。', 'DIFF_FOUND',
  @seed_admin_id, '2026-03-11 09:00:00', @seed_admin_id, '2026-03-11 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0002' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-002' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0004', '汉代谷纹玉圭', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-11 09:12:00', @seed_admin_id, '2026-03-11 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0004' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-002' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0023', '清代掐丝冠饰', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-11 09:24:00', @seed_admin_id, '2026-03-11 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0023' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-002' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0024', '清代柏木髹漆香几', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-11 09:36:00', @seed_admin_id, '2026-03-11 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0024' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-002' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0037', '春秋错金银簋', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-11 09:48:00', @seed_admin_id, '2026-03-11 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0037' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-002' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0039', '民国行书扇面', 1, 1,
  0, NULL, 'CHECKED',
  @seed_admin_id, '2026-03-11 10:00:00', @seed_admin_id, '2026-03-11 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0039' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-002' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0048', '元代花鸟扇面', 1, 0,
  -1, '盘点时文物暂未在指定库位发现，已发起复核。', 'DIFF_FOUND',
  @seed_admin_id, '2026-03-11 10:12:00', @seed_admin_id, '2026-03-11 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0048' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-002' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0049', '新石器时代谷纹玉圭', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-11 10:24:00', @seed_admin_id, '2026-03-11 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0049' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-002' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0051', '明代黄花梨经匣', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-11 10:36:00', @seed_admin_id, '2026-03-11 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0051' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-002' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0053', '唐代造像碑坐像', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-11 10:48:00', @seed_admin_id, '2026-03-11 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0053' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-002' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0056', '清代白釉碗', 1, 1,
  0, NULL, 'CHECKED',
  @seed_admin_id, '2026-03-11 11:00:00', @seed_admin_id, '2026-03-11 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0056' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-002' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0057', '民国仕女立轴', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-11 11:12:00', @seed_admin_id, '2026-03-11 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0057' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-002' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task (
  task_no, task_name, location_code, task_status, start_time, end_time, principal_name, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'INV-DEMO-2026-003', '三号精品库重点盘点', 'LOC_C', 'IN_PROGRESS', '2026-03-15 09:00:00', NULL, '顾琳',
  '批量生成的盘点任务数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2026-03-15 09:00:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher12' AND deleted = 0 LIMIT 1), @seed_admin_id), '2026-03-15 09:00:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM inventory_task WHERE task_no = 'INV-DEMO-2026-003' AND deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0003', '明代楷书扇面', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-15 09:00:00', @seed_admin_id, '2026-03-15 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0003' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-003' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0044', '宋代造像碑立像', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-15 09:12:00', @seed_admin_id, '2026-03-15 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0044' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-003' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0046', '唐代蟠螭纹带钩', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-15 09:24:00', @seed_admin_id, '2026-03-15 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0046' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-003' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0052', '清代朱漆漆壶', 1, 0,
  -1, '现场复核中，待确认临时调拨记录。', 'DIFF_FOUND',
  @seed_admin_id, '2026-03-15 09:36:00', @seed_admin_id, '2026-03-15 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0052' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-003' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0055', '唐代兽面纹壶', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-15 09:48:00', @seed_admin_id, '2026-03-15 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0055' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-003' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0065', '唐代粉彩罐', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-15 10:00:00', @seed_admin_id, '2026-03-15 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0065' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-003' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0072', '战国编联木牍', 1, 0,
  -1, '现场复核中，待确认临时调拨记录。', 'DIFF_FOUND',
  @seed_admin_id, '2026-03-15 10:12:00', @seed_admin_id, '2026-03-15 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0072' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-003' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0079', '战国戗金漆盒', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-15 10:24:00', @seed_admin_id, '2026-03-15 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0079' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-003' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0084', '清代山水立轴', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-15 10:36:00', @seed_admin_id, '2026-03-15 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0084' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-003' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0098', '唐代莲花座石刻残件', 1, 0,
  -1, '现场复核中，待确认临时调拨记录。', 'DIFF_FOUND',
  @seed_admin_id, '2026-03-15 10:48:00', @seed_admin_id, '2026-03-15 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0098' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-003' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0129', '元代行书手卷', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-15 11:00:00', @seed_admin_id, '2026-03-15 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0129' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-003' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0131', '唐代掐丝冠饰', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-15 11:12:00', @seed_admin_id, '2026-03-15 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0131' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-003' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task (
  task_no, task_name, location_code, task_status, start_time, end_time, principal_name, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'INV-DEMO-2026-004', '一号展厅春季盘点', 'EXHIBIT_HALL_1', 'COMPLETED', '2026-03-18 09:00:00', '2026-03-18 17:00:00', '王蕾',
  '批量生成的盘点任务数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2026-03-18 09:00:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher02' AND deleted = 0 LIMIT 1), @seed_admin_id), '2026-03-18 17:00:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM inventory_task WHERE task_no = 'INV-DEMO-2026-004' AND deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0012', '清代花鸟手卷', 1, 0,
  -1, '盘点时文物暂未在指定库位发现，已发起复核。', 'DIFF_FOUND',
  @seed_admin_id, '2026-03-18 09:00:00', @seed_admin_id, '2026-03-18 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0012' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-004' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0014', '唐代錾刻带扣', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-18 09:12:00', @seed_admin_id, '2026-03-18 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0014' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-004' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0017', '宋代经幢供养人像', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-18 09:24:00', @seed_admin_id, '2026-03-18 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0017' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-004' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0019', '战国蟠螭纹镜', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-18 09:36:00', @seed_admin_id, '2026-03-18 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0019' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-004' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0021', '清代楷书立轴', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-18 09:48:00', @seed_admin_id, '2026-03-18 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0021' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-004' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0027', '宋代编联卷册', 1, 1,
  0, NULL, 'CHECKED',
  @seed_admin_id, '2026-03-18 10:00:00', @seed_admin_id, '2026-03-18 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0027' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-004' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0028', '西周兽面纹簋', 1, 0,
  -1, '盘点时文物暂未在指定库位发现，已发起复核。', 'DIFF_FOUND',
  @seed_admin_id, '2026-03-18 10:12:00', @seed_admin_id, '2026-03-18 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0028' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-004' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0035', '唐代莲花座供养人像', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-18 10:24:00', @seed_admin_id, '2026-03-18 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0035' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-004' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0043', '汉代戗金漆盘', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-18 10:36:00', @seed_admin_id, '2026-03-18 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0043' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-004' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0047', '宋代影青罐', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-18 10:48:00', @seed_admin_id, '2026-03-18 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0047' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-004' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0074', '元代刻花罐', 1, 1,
  0, NULL, 'CHECKED',
  @seed_admin_id, '2026-03-18 11:00:00', @seed_admin_id, '2026-03-18 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0074' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-004' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0085', '清代谷纹带钩', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-18 11:12:00', @seed_admin_id, '2026-03-18 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0085' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-004' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task (
  task_no, task_name, location_code, task_status, start_time, end_time, principal_name, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'INV-DEMO-2026-005', '二号展厅月度盘点', 'EXHIBIT_HALL_2', 'CREATED', '2026-03-21 09:00:00', NULL, '周洋',
  '批量生成的盘点任务数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2026-03-21 09:00:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher03' AND deleted = 0 LIMIT 1), @seed_admin_id), '2026-03-21 09:00:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM inventory_task WHERE task_no = 'INV-DEMO-2026-005' AND deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0007', '明代戗金漆壶', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-21 09:00:00', @seed_admin_id, '2026-03-21 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0007' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-005' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0008', '北齐莲花座立像', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-21 09:12:00', @seed_admin_id, '2026-03-21 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0008' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-005' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0013', '战国谷纹玉璧', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-21 09:24:00', @seed_admin_id, '2026-03-21 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0013' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-005' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0015', '民国柏木髹漆供案', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-21 09:36:00', @seed_admin_id, '2026-03-21 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0015' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-005' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0030', '明代花鸟扇面', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-21 09:48:00', @seed_admin_id, '2026-03-21 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0030' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-005' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0032', '清代錾刻冠饰', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-21 10:00:00', @seed_admin_id, '2026-03-21 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0032' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-005' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0033', '民国楠木透雕佛像', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-21 10:12:00', @seed_admin_id, '2026-03-21 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0033' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-005' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0034', '民国描金漆壶', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-21 10:24:00', @seed_admin_id, '2026-03-21 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0034' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-005' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0036', '明代题记竹简', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-21 10:36:00', @seed_admin_id, '2026-03-21 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0036' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-005' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0038', '明代白釉盘', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-21 10:48:00', @seed_admin_id, '2026-03-21 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0038' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-005' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0068', '明代掐丝执壶', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-21 11:00:00', @seed_admin_id, '2026-03-21 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0068' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-005' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0069', '民国柏木髹漆经匣', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-21 11:12:00', @seed_admin_id, '2026-03-21 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0069' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-005' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task (
  task_no, task_name, location_code, task_status, start_time, end_time, principal_name, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'INV-DEMO-2026-006', '三号库房保管复核', 'STORAGE_ROOM_3', 'IN_PROGRESS', '2026-03-22 09:00:00', NULL, '郑川',
  '批量生成的盘点任务数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2026-03-22 09:00:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher07' AND deleted = 0 LIMIT 1), @seed_admin_id), '2026-03-22 09:00:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM inventory_task WHERE task_no = 'INV-DEMO-2026-006' AND deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0001', '春秋错金银壶', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-22 09:00:00', @seed_admin_id, '2026-03-22 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0001' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-006' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0016', '明代朱漆漆奁', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-22 09:12:00', @seed_admin_id, '2026-03-22 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0016' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-006' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0026', '北魏经幢供养人像', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-22 09:24:00', @seed_admin_id, '2026-03-22 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0026' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-006' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0029', '清代影青碗', 1, 0,
  -1, '现场复核中，待确认临时调拨记录。', 'DIFF_FOUND',
  @seed_admin_id, '2026-03-22 09:36:00', @seed_admin_id, '2026-03-22 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0029' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-006' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0042', '民国黄花梨经匣', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-22 09:48:00', @seed_admin_id, '2026-03-22 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0042' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-006' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0054', '明代简牍册页', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-22 10:00:00', @seed_admin_id, '2026-03-22 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0054' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-006' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0062', '北魏经幢坐像', 1, 0,
  -1, '现场复核中，待确认临时调拨记录。', 'DIFF_FOUND',
  @seed_admin_id, '2026-03-22 10:12:00', @seed_admin_id, '2026-03-22 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0062' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-006' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0063', '宋代题记木牍', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-22 10:24:00', @seed_admin_id, '2026-03-22 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0063' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-006' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0066', '民国山水扇面', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-22 10:36:00', @seed_admin_id, '2026-03-22 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0066' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-006' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0070', '明代描金漆奁', 1, 0,
  -1, '现场复核中，待确认临时调拨记录。', 'DIFF_FOUND',
  @seed_admin_id, '2026-03-22 10:48:00', @seed_admin_id, '2026-03-22 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0070' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-006' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0082', '春秋云雷纹镜', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-22 11:00:00', @seed_admin_id, '2026-03-22 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0082' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-006' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0086', '唐代累丝带扣', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-22 11:12:00', @seed_admin_id, '2026-03-22 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0086' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-006' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task (
  task_no, task_name, location_code, task_status, start_time, end_time, principal_name, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'INV-DEMO-2026-007', '修复库状态抽盘', 'LOC_D', 'COMPLETED', '2026-03-23 09:00:00', '2026-03-23 17:00:00', '韩卓',
  '批量生成的盘点任务数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2026-03-23 09:00:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2026-03-23 17:00:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM inventory_task WHERE task_no = 'INV-DEMO-2026-007' AND deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0136', '战国云雷纹带钩', 1, 0,
  -1, '盘点时文物暂未在指定库位发现，已发起复核。', 'DIFF_FOUND',
  @seed_admin_id, '2026-03-23 09:00:00', @seed_admin_id, '2026-03-23 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0136' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-007' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0137', '元代粉彩香炉', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-23 09:12:00', @seed_admin_id, '2026-03-23 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0137' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-007' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0144', '战国漆书卷册', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-23 09:24:00', @seed_admin_id, '2026-03-23 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0144' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-007' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0145', '战国蟠螭纹镜', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-23 09:36:00', @seed_admin_id, '2026-03-23 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0145' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-007' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0148', '战国凤鸟纹玉璧', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-23 09:48:00', @seed_admin_id, '2026-03-23 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0148' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-007' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0151', '明代黑漆漆壶', 1, 1,
  0, NULL, 'CHECKED',
  @seed_admin_id, '2026-03-23 10:00:00', @seed_admin_id, '2026-03-23 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0151' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-007' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0152', '唐代造像碑立像', 1, 0,
  -1, '盘点时文物暂未在指定库位发现，已发起复核。', 'DIFF_FOUND',
  @seed_admin_id, '2026-03-23 10:12:00', @seed_admin_id, '2026-03-23 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0152' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-007' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0153', '汉代漆书卷册', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-23 10:24:00', @seed_admin_id, '2026-03-23 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0153' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-007' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0159', '民国描金佛像', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-23 10:36:00', @seed_admin_id, '2026-03-23 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0159' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-007' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0160', '汉代黑漆漆壶', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-23 10:48:00', @seed_admin_id, '2026-03-23 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0160' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-007' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0161', '北魏佛首立像', 1, 1,
  0, NULL, 'CHECKED',
  @seed_admin_id, '2026-03-23 11:00:00', @seed_admin_id, '2026-03-23 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0161' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-007' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0168', '清代描金佛像', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-23 11:12:00', @seed_admin_id, '2026-03-23 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0168' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-007' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task (
  task_no, task_name, location_code, task_status, start_time, end_time, principal_name, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'INV-DEMO-2026-008', '珍品专柜安全抽盘', 'LOC_VIP', 'COMPLETED', '2026-03-25 09:00:00', '2026-03-25 17:00:00', '苏瑶',
  '批量生成的盘点任务数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2026-03-25 09:00:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher06' AND deleted = 0 LIMIT 1), @seed_admin_id), '2026-03-25 17:00:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM inventory_task WHERE task_no = 'INV-DEMO-2026-008' AND deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0006', '清代楠木透雕屏风', 1, 0,
  -1, '盘点时文物暂未在指定库位发现，已发起复核。', 'DIFF_FOUND',
  @seed_admin_id, '2026-03-25 09:00:00', @seed_admin_id, '2026-03-25 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0006' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-008' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0009', '宋代墨书册页', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-25 09:12:00', @seed_admin_id, '2026-03-25 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0009' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-008' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0011', '民国粉彩梅瓶', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-25 09:24:00', @seed_admin_id, '2026-03-25 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0011' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-008' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0020', '宋代刻花盘', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-25 09:36:00', @seed_admin_id, '2026-03-25 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0020' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-008' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0031', '战国素面带钩', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-25 09:48:00', @seed_admin_id, '2026-03-25 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0031' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-008' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0041', '宋代掐丝银盘', 1, 1,
  0, NULL, 'CHECKED',
  @seed_admin_id, '2026-03-25 10:00:00', @seed_admin_id, '2026-03-25 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0041' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-008' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0045', '汉代编联木牍', 1, 0,
  -1, '盘点时文物暂未在指定库位发现，已发起复核。', 'DIFF_FOUND',
  @seed_admin_id, '2026-03-25 10:12:00', @seed_admin_id, '2026-03-25 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0045' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-008' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0067', '战国凤鸟纹玉璧', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-25 10:24:00', @seed_admin_id, '2026-03-25 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0067' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-008' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0071', '北魏经幢立像', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-25 10:36:00', @seed_admin_id, '2026-03-25 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0071' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-008' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0073', '春秋铭文壶', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-25 10:48:00', @seed_admin_id, '2026-03-25 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0073' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-008' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0077', '宋代累丝执壶', 1, 1,
  0, NULL, 'CHECKED',
  @seed_admin_id, '2026-03-25 11:00:00', @seed_admin_id, '2026-03-25 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0077' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-008' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0088', '战国剔红漆奁', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-25 11:12:00', @seed_admin_id, '2026-03-25 17:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0088' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-008' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task (
  task_no, task_name, location_code, task_status, start_time, end_time, principal_name, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'INV-DEMO-2026-009', '暂存区临时盘点', 'TEMP_STORAGE', 'CREATED', '2026-03-27 09:00:00', NULL, '姚菲',
  '批量生成的盘点任务数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2026-03-27 09:00:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher14' AND deleted = 0 LIMIT 1), @seed_admin_id), '2026-03-27 09:00:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM inventory_task WHERE task_no = 'INV-DEMO-2026-009' AND deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0104', '清代鎏金冠饰', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-27 09:00:00', @seed_admin_id, '2026-03-27 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0104' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-009' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0106', '民国描金漆盘', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-27 09:12:00', @seed_admin_id, '2026-03-27 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0106' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-009' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0116', '北魏经幢坐像', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-27 09:24:00', @seed_admin_id, '2026-03-27 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0116' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-009' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0118', '春秋错金银带钩', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-27 09:36:00', @seed_admin_id, '2026-03-27 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0118' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-009' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task (
  task_no, task_name, location_code, task_status, start_time, end_time, principal_name, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT 'INV-DEMO-2026-010', '修复室在修文物盘点', 'RESTORATION_ROOM', 'IN_PROGRESS', '2026-03-30 09:00:00', NULL, '韩卓',
  '批量生成的盘点任务数据。', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2026-03-30 09:00:00', COALESCE((SELECT id FROM sys_user WHERE username = 'researcher11' AND deleted = 0 LIMIT 1), @seed_admin_id), '2026-03-30 09:00:00', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM inventory_task WHERE task_no = 'INV-DEMO-2026-010' AND deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0138', '清代墨竹册页', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-30 09:00:00', @seed_admin_id, '2026-03-30 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0138' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-010' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0139', '新石器时代云龙纹玉圭', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-30 09:12:00', @seed_admin_id, '2026-03-30 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0139' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-010' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0140', '唐代錾花银盘', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-30 09:24:00', @seed_admin_id, '2026-03-30 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0140' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-010' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0141', '民国黄花梨佛像', 1, 0,
  -1, '现场复核中，待确认临时调拨记录。', 'DIFF_FOUND',
  @seed_admin_id, '2026-03-30 09:36:00', @seed_admin_id, '2026-03-30 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0141' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-010' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0142', '汉代黑漆漆壶', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-30 09:48:00', @seed_admin_id, '2026-03-30 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0142' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-010' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0143', '北魏莲花座供养人像', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-30 10:00:00', @seed_admin_id, '2026-03-30 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0143' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-010' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0146', '明代刻花香炉', 1, 0,
  -1, '现场复核中，待确认临时调拨记录。', 'DIFF_FOUND',
  @seed_admin_id, '2026-03-30 10:12:00', @seed_admin_id, '2026-03-30 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0146' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-010' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0147', '宋代仕女册页', 1, 1,
  0, NULL, 'NORMAL',
  @seed_admin_id, '2026-03-30 10:24:00', @seed_admin_id, '2026-03-30 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0147' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-010' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0149', '宋代錾刻执壶', 1, NULL,
  NULL, NULL, 'PENDING',
  @seed_admin_id, '2026-03-30 10:36:00', @seed_admin_id, '2026-03-30 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0149' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-010' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, 'REL-DEMO-2026-0150', '明代黄花梨经匣', 1, 0,
  -1, '现场复核中，待确认临时调拨记录。', 'DIFF_FOUND',
  @seed_admin_id, '2026-03-30 10:48:00', @seed_admin_id, '2026-03-30 09:00:00', 0
FROM inventory_task t
JOIN relic r ON r.relic_no = 'REL-DEMO-2026-0150' AND r.deleted = 0
WHERE t.task_no = 'INV-DEMO-2026-010' AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);

COMMIT;

-- 导入后可执行以下核对 SQL
-- SELECT COUNT(*) AS sys_user_count FROM sys_user WHERE deleted = 0;
-- SELECT COUNT(*) AS relic_count FROM relic WHERE deleted = 0;
-- SELECT COUNT(*) AS inbound_count FROM relic_inbound_order WHERE deleted = 0;
-- SELECT COUNT(*) AS outbound_count FROM relic_outbound_order WHERE deleted = 0;
-- SELECT COUNT(*) AS inventory_task_count FROM inventory_task WHERE deleted = 0;
-- SELECT COUNT(*) AS repair_task_count FROM repair_task WHERE deleted = 0;
