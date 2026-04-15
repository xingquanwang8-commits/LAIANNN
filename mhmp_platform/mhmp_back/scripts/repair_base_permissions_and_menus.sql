SET NAMES utf8mb4;
START TRANSACTION;

SET @operator_id = COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), 1);

DROP TEMPORARY TABLE IF EXISTS tmp_role_seed;
CREATE TEMPORARY TABLE tmp_role_seed (
    role_name VARCHAR(100) NOT NULL,
    role_code VARCHAR(100) NOT NULL PRIMARY KEY,
    status VARCHAR(20) NOT NULL,
    remark VARCHAR(500) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO tmp_role_seed (role_name, role_code, status, remark) VALUES
    ('系统管理员', 'admin', 'ENABLED', 'Built-in role repair'),
    ('高级研究员', 'senior_researcher', 'ENABLED', 'Built-in role repair'),
    ('研究员', 'researcher', 'ENABLED', 'Built-in role repair'),
    ('讲解员', 'docent', 'ENABLED', 'Built-in role repair');

INSERT INTO sys_role (
    role_name, role_code, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT
    s.role_name, s.role_code, s.status, s.remark, @operator_id, NOW(), @operator_id, NOW(), 0
FROM tmp_role_seed s
LEFT JOIN sys_role r ON r.role_code = s.role_code
WHERE r.id IS NULL;

UPDATE sys_role r
JOIN tmp_role_seed s ON s.role_code = r.role_code
SET r.role_name = s.role_name,
    r.status = s.status,
    r.remark = s.remark,
    r.update_by = @operator_id,
    r.update_time = NOW(),
    r.deleted = 0;

DROP TEMPORARY TABLE IF EXISTS tmp_menu_seed;
CREATE TEMPORARY TABLE tmp_menu_seed (
    parent_menu_code VARCHAR(100) NULL,
    menu_name VARCHAR(100) NOT NULL,
    menu_code VARCHAR(100) NOT NULL PRIMARY KEY,
    menu_type VARCHAR(20) NOT NULL,
    path VARCHAR(255) NULL,
    component VARCHAR(255) NULL,
    permission_code VARCHAR(100) NULL,
    sort_no INT NOT NULL,
    visible TINYINT(1) NOT NULL,
    status VARCHAR(20) NOT NULL,
    icon VARCHAR(100) NULL,
    keep_alive TINYINT(1) NOT NULL,
    remark VARCHAR(500) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO tmp_menu_seed (
    parent_menu_code, menu_name, menu_code, menu_type, path, component, permission_code,
    sort_no, visible, status, icon, keep_alive, remark
) VALUES
    (NULL, '工作台', 'dashboard', 'MENU', '/dashboard', NULL, 'dashboard:view', 1, 1, 'ENABLED', 'House', 1, 'Base menu repair'),
    (NULL, '系统管理', 'sys', 'DIR', '/system', NULL, NULL, 10, 1, 'ENABLED', 'Setting', 0, 'Base menu repair'),
    (NULL, '文物管理', 'relic', 'DIR', '/relic', NULL, NULL, 20, 1, 'ENABLED', 'Collection', 0, 'Base menu repair'),
    (NULL, '库存管理', 'inventory', 'DIR', '/inventory', NULL, NULL, 30, 1, 'ENABLED', 'Box', 0, 'Base menu repair'),
    (NULL, '修复管理', 'repair', 'DIR', '/repair', NULL, NULL, 40, 1, 'ENABLED', 'Operation', 0, 'Base menu repair'),
    (NULL, '个人中心', 'profile', 'MENU', '/profile', NULL, 'profile:view', 50, 1, 'ENABLED', 'UserFilled', 1, 'Base menu repair'),

    ('sys', '用户管理', 'sys:user', 'MENU', '/system/user', NULL, 'sys:user:view', 11, 1, 'ENABLED', 'User', 1, 'Base menu repair'),
    ('sys', '角色管理', 'sys:role', 'MENU', '/system/role', NULL, 'sys:role:view', 12, 1, 'ENABLED', 'UserFilled', 1, 'Base menu repair'),
    ('sys', '菜单管理', 'sys:menu', 'MENU', '/system/menu', NULL, 'sys:menu:view', 13, 1, 'ENABLED', 'Menu', 1, 'Base menu repair'),
    ('sys', '字典管理', 'sys:dict', 'MENU', '/system/dict', NULL, 'sys:dict:view', 14, 1, 'ENABLED', 'Files', 1, 'Base menu repair'),
    ('sys', '操作日志', 'sys:log', 'MENU', '/system/log', NULL, 'sys:log:view', 15, 1, 'ENABLED', 'Document', 1, 'Base menu repair'),
    ('sys:user', '用户新增', 'sys:user:add', 'BUTTON', NULL, NULL, 'sys:user:add', 1, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('sys:user', '用户编辑', 'sys:user:edit', 'BUTTON', NULL, NULL, 'sys:user:edit', 2, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('sys:user', '用户删除', 'sys:user:delete', 'BUTTON', NULL, NULL, 'sys:user:delete', 3, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('sys:role', '角色授权', 'sys:role:assign', 'BUTTON', NULL, NULL, 'sys:role:assign', 1, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('sys:role', '角色新增', 'sys:role:add', 'BUTTON', NULL, NULL, 'sys:role:add', 2, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('sys:role', '角色编辑', 'sys:role:edit', 'BUTTON', NULL, NULL, 'sys:role:edit', 3, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('sys:role', '角色状态', 'sys:role:status', 'BUTTON', NULL, NULL, 'sys:role:status', 4, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('sys:role', '角色删除', 'sys:role:delete', 'BUTTON', NULL, NULL, 'sys:role:delete', 5, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('sys:menu', '菜单新增', 'sys:menu:add', 'BUTTON', NULL, NULL, 'sys:menu:add', 1, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('sys:menu', '菜单编辑', 'sys:menu:edit', 'BUTTON', NULL, NULL, 'sys:menu:edit', 2, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('sys:menu', '菜单删除', 'sys:menu:delete', 'BUTTON', NULL, NULL, 'sys:menu:delete', 3, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('sys:dict', '字典导入', 'sys:dict:import', 'BUTTON', NULL, NULL, 'sys:dict:import', 1, 1, 'ENABLED', NULL, 0, 'Base permission repair'),

    ('relic', '文物列表', 'relic:list', 'MENU', '/relic/list', NULL, 'relic:list:view', 21, 1, 'ENABLED', 'Tickets', 1, 'Base menu repair'),
    ('relic', '新增文物', 'relic:create', 'MENU', '/relic/create', NULL, 'relic:add', 22, 1, 'ENABLED', 'EditPen', 0, 'Base menu repair'),
    ('relic', '文物入库', 'inventory:inbound', 'MENU', '/inventory/inbound', NULL, 'inventory:inbound:view', 23, 1, 'ENABLED', 'Upload', 1, 'Base menu repair'),
    ('relic', '文物出库', 'inventory:outbound-apply', 'MENU', '/inventory/outbound/apply', NULL, 'inventory:outbound:apply:view', 24, 1, 'ENABLED', 'Download', 1, 'Base menu repair'),
    ('relic', '馆内转存', 'relic:transfer', 'MENU', '/relic/transfer', NULL, 'relic:edit', 25, 1, 'ENABLED', 'RefreshRight', 0, 'Base menu repair'),
    ('relic', '文物详情', 'relic:detail', 'MENU', '/relic/detail/:id', NULL, 'relic:detail:view', 29, 0, 'ENABLED', 'DocumentCopy', 0, 'Base menu repair'),
    ('relic:list', '文物新增', 'relic:add', 'BUTTON', NULL, NULL, 'relic:add', 1, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('relic:list', '文物编辑', 'relic:edit', 'BUTTON', NULL, NULL, 'relic:edit', 2, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('relic:list', '文物删除', 'relic:delete', 'BUTTON', NULL, NULL, 'relic:delete', 3, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('relic:list', '文物查看', 'relic:view', 'BUTTON', NULL, NULL, 'relic:view', 4, 1, 'ENABLED', NULL, 0, 'Base permission repair'),

    ('inventory', '库存查询', 'inventory:query', 'MENU', '/inventory/query', NULL, 'inventory:query:view', 31, 1, 'ENABLED', 'Search', 1, 'Base menu repair'),
    ('inventory', '入库审批', 'inventory:inbound-approve', 'MENU', '/inventory/inbound/approve', NULL, 'inventory:inbound:approve', 32, 1, 'ENABLED', 'CircleCheck', 0, 'Base menu repair'),
    ('inventory', '出库审批', 'inventory:outbound-approve', 'MENU', '/inventory/outbound/approve', NULL, 'inventory:outbound:approve:view', 33, 1, 'ENABLED', 'CircleCheck', 1, 'Base menu repair'),
    ('inventory', '盘点任务', 'inventory:task', 'MENU', '/inventory/task', NULL, 'inventory:task:view', 34, 1, 'ENABLED', 'Checked', 1, 'Base menu repair'),
    ('inventory:inbound', '入库登记提交', 'inventory:inbound:add', 'BUTTON', NULL, NULL, 'inventory:inbound:add', 1, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('inventory:outbound-apply', '出库申请提交', 'inventory:outbound:submit', 'BUTTON', NULL, NULL, 'inventory:outbound:submit', 1, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('inventory:outbound-approve', '出库审批通过', 'inventory:outbound:approve', 'BUTTON', NULL, NULL, 'inventory:outbound:approve', 1, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('inventory:outbound-approve', '出库审批驳回', 'inventory:outbound:reject', 'BUTTON', NULL, NULL, 'inventory:outbound:reject', 2, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('inventory:task', '盘点任务新增', 'inventory:task:add', 'BUTTON', NULL, NULL, 'inventory:task:add', 0, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('inventory:task', '盘点结果提交', 'inventory:task:submit', 'BUTTON', NULL, NULL, 'inventory:task:submit', 1, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('inventory:inbound-approve', '入库审批', 'inventory:inbound:approve', 'BUTTON', NULL, NULL, 'inventory:inbound:approve', 1, 1, 'ENABLED', NULL, 0, 'Base permission repair'),

    ('repair', '待修复文物', 'repair:apply', 'MENU', '/repair/apply', NULL, 'repair:apply:view', 41, 1, 'ENABLED', 'Clock', 1, 'Base menu repair'),
    ('repair', '修复审批', 'repair:approve', 'MENU', '/repair/approve', NULL, 'repair:approve:view', 42, 1, 'ENABLED', 'Document', 1, 'Base menu repair'),
    ('repair', '我的修复', 'repair:process', 'MENU', '/repair/process', NULL, 'repair:process:view', 43, 1, 'ENABLED', 'Files', 1, 'Base menu repair'),
    ('repair', '修复验收', 'repair:acceptance', 'MENU', '/repair/acceptance', NULL, 'repair:acceptance:view', 44, 1, 'ENABLED', 'Select', 1, 'Base menu repair'),
    ('repair', '已修复', 'repair:history', 'MENU', '/repair/history', NULL, 'repair:history:view', 45, 1, 'ENABLED', 'DocumentCopy', 1, 'Base menu repair'),
    ('repair:apply', '修复申请提交', 'repair:apply:submit', 'BUTTON', NULL, NULL, 'repair:apply:submit', 1, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('repair:approve', '修复方案审批', 'repair:plan:approve', 'BUTTON', NULL, NULL, 'repair:plan:approve', 1, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('repair:process', '修复过程记录', 'repair:log:add', 'BUTTON', NULL, NULL, 'repair:log:add', 1, 1, 'ENABLED', NULL, 0, 'Base permission repair'),
    ('repair:acceptance', '修复验收提交', 'repair:acceptance:add', 'BUTTON', NULL, NULL, 'repair:acceptance:add', 1, 1, 'ENABLED', NULL, 0, 'Base permission repair');

INSERT INTO sys_menu (
    parent_id, menu_name, menu_code, menu_type, path, component, permission_code,
    sort_no, visible, status, icon, keep_alive, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT
    0, s.menu_name, s.menu_code, s.menu_type, s.path, s.component, s.permission_code,
    s.sort_no, s.visible, s.status, s.icon, s.keep_alive, s.remark, @operator_id, NOW(), @operator_id, NOW(), 0
FROM tmp_menu_seed s
LEFT JOIN sys_menu m ON m.menu_code = s.menu_code
WHERE m.id IS NULL;

UPDATE sys_menu m
JOIN tmp_menu_seed s ON s.menu_code = m.menu_code
LEFT JOIN sys_menu p ON p.menu_code = s.parent_menu_code
SET m.parent_id = COALESCE(p.id, 0),
    m.menu_name = s.menu_name,
    m.menu_type = s.menu_type,
    m.path = s.path,
    m.component = s.component,
    m.permission_code = s.permission_code,
    m.sort_no = s.sort_no,
    m.visible = s.visible,
    m.status = s.status,
    m.icon = s.icon,
    m.keep_alive = s.keep_alive,
    m.remark = s.remark,
    m.update_by = @operator_id,
    m.update_time = NOW(),
    m.deleted = 0;

DROP TEMPORARY TABLE IF EXISTS tmp_role_menu_seed;
CREATE TEMPORARY TABLE tmp_role_menu_seed (
    role_code VARCHAR(100) NOT NULL,
    menu_code VARCHAR(100) NOT NULL,
    PRIMARY KEY (role_code, menu_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO tmp_role_menu_seed (role_code, menu_code)
SELECT 'admin', menu_code FROM tmp_menu_seed;

INSERT IGNORE INTO tmp_role_menu_seed (role_code, menu_code) VALUES
    ('researcher', 'dashboard'),
    ('researcher', 'relic'),
    ('researcher', 'inventory'),
    ('researcher', 'repair'),
    ('researcher', 'profile'),
    ('researcher', 'relic:list'),
    ('researcher', 'relic:create'),
    ('researcher', 'inventory:inbound'),
    ('researcher', 'inventory:outbound-apply'),
    ('researcher', 'relic:transfer'),
    ('researcher', 'relic:detail'),
    ('researcher', 'relic:add'),
    ('researcher', 'relic:edit'),
    ('researcher', 'relic:view'),
    ('researcher', 'inventory:query'),
    ('researcher', 'inventory:task'),
    ('researcher', 'inventory:inbound:add'),
    ('researcher', 'inventory:outbound:submit'),
    ('researcher', 'inventory:task:add'),
    ('researcher', 'inventory:task:submit'),
    ('researcher', 'repair:apply'),
    ('researcher', 'repair:process'),
    ('researcher', 'repair:history'),
    ('researcher', 'repair:apply:submit'),
    ('researcher', 'repair:log:add');

INSERT IGNORE INTO tmp_role_menu_seed (role_code, menu_code) VALUES
    ('senior_researcher', 'dashboard'),
    ('senior_researcher', 'relic'),
    ('senior_researcher', 'inventory'),
    ('senior_researcher', 'repair'),
    ('senior_researcher', 'profile'),
    ('senior_researcher', 'relic:list'),
    ('senior_researcher', 'relic:create'),
    ('senior_researcher', 'inventory:inbound'),
    ('senior_researcher', 'inventory:outbound-apply'),
    ('senior_researcher', 'relic:transfer'),
    ('senior_researcher', 'relic:detail'),
    ('senior_researcher', 'relic:add'),
    ('senior_researcher', 'relic:edit'),
    ('senior_researcher', 'relic:view'),
    ('senior_researcher', 'inventory:query'),
    ('senior_researcher', 'inventory:task'),
    ('senior_researcher', 'inventory:inbound:add'),
    ('senior_researcher', 'inventory:outbound:submit'),
    ('senior_researcher', 'inventory:task:add'),
    ('senior_researcher', 'inventory:task:submit'),
    ('senior_researcher', 'repair:apply'),
    ('senior_researcher', 'repair:process'),
    ('senior_researcher', 'repair:history'),
    ('senior_researcher', 'repair:apply:submit'),
    ('senior_researcher', 'repair:log:add'),
    ('senior_researcher', 'inventory:inbound-approve'),
    ('senior_researcher', 'inventory:inbound:approve'),
    ('senior_researcher', 'inventory:outbound-approve'),
    ('senior_researcher', 'inventory:outbound:approve'),
    ('senior_researcher', 'inventory:outbound:reject'),
    ('senior_researcher', 'repair:approve'),
    ('senior_researcher', 'repair:plan:approve'),
    ('senior_researcher', 'repair:acceptance'),
    ('senior_researcher', 'repair:acceptance:add');

INSERT IGNORE INTO tmp_role_menu_seed (role_code, menu_code) VALUES
    ('docent', 'dashboard'),
    ('docent', 'relic'),
    ('docent', 'inventory'),
    ('docent', 'repair'),
    ('docent', 'profile'),
    ('docent', 'relic:list'),
    ('docent', 'relic:detail'),
    ('docent', 'relic:view'),
    ('docent', 'inventory:query'),
    ('docent', 'repair:history');

UPDATE sys_role_menu rm
JOIN sys_role r ON r.id = rm.role_id
LEFT JOIN sys_menu m ON m.id = rm.menu_id
LEFT JOIN tmp_role_menu_seed s ON s.role_code = r.role_code AND s.menu_code = m.menu_code
SET rm.deleted = 1,
    rm.update_by = @operator_id,
    rm.update_time = NOW()
WHERE r.deleted = 0
  AND rm.deleted = 0
  AND r.role_code IN (SELECT role_code FROM tmp_role_seed)
  AND s.role_code IS NULL;

UPDATE sys_role_menu rm
JOIN sys_role r ON r.id = rm.role_id
JOIN sys_menu m ON m.id = rm.menu_id
JOIN tmp_role_menu_seed s ON s.role_code = r.role_code AND s.menu_code = m.menu_code
SET rm.deleted = 0,
    rm.update_by = @operator_id,
    rm.update_time = NOW()
WHERE r.deleted = 0
  AND m.deleted = 0;

INSERT INTO sys_role_menu (
    role_id, menu_id, create_by, create_time, update_by, update_time, deleted
)
SELECT
    r.id, m.id, @operator_id, NOW(), @operator_id, NOW(), 0
FROM tmp_role_menu_seed s
JOIN sys_role r ON r.role_code = s.role_code AND r.deleted = 0 AND r.status = 'ENABLED'
JOIN sys_menu m ON m.menu_code = s.menu_code AND m.deleted = 0
LEFT JOIN sys_role_menu rm ON rm.role_id = r.id AND rm.menu_id = m.id
WHERE rm.id IS NULL;

SET @default_researcher_user_id = (
    SELECT id FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1
);
SET @senior_researcher_role_id = (
    SELECT id FROM sys_role WHERE role_code = 'senior_researcher' AND deleted = 0 LIMIT 1
);

UPDATE sys_user
SET nick_name = CASE
        WHEN nick_name IS NULL OR nick_name = '' OR nick_name = '馆藏研究员' THEN '高级研究员'
        ELSE nick_name
    END,
    remark = CASE
        WHEN remark IS NULL OR remark = '' THEN '默认高级研究员演示账号，负责业务审批与修复验收。'
        ELSE remark
    END,
    update_by = @operator_id,
    update_time = NOW()
WHERE id = @default_researcher_user_id;

UPDATE sys_user_role
SET deleted = 1,
    update_by = @operator_id,
    update_time = NOW()
WHERE user_id = @default_researcher_user_id
  AND deleted = 0
  AND role_id <> @senior_researcher_role_id;

UPDATE sys_user_role
SET deleted = 0,
    update_by = @operator_id,
    update_time = NOW()
WHERE user_id = @default_researcher_user_id
  AND role_id = @senior_researcher_role_id;

INSERT INTO sys_user_role (
    user_id, role_id, create_by, create_time, update_by, update_time, deleted
)
SELECT
    @default_researcher_user_id, @senior_researcher_role_id, @operator_id, NOW(), @operator_id, NOW(), 0
FROM DUAL
WHERE @default_researcher_user_id IS NOT NULL
  AND @senior_researcher_role_id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM sys_user_role
      WHERE user_id = @default_researcher_user_id
        AND role_id = @senior_researcher_role_id
        AND deleted = 0
  );

DROP TEMPORARY TABLE IF EXISTS tmp_role_menu_seed;
DROP TEMPORARY TABLE IF EXISTS tmp_menu_seed;
DROP TEMPORARY TABLE IF EXISTS tmp_role_seed;

COMMIT;
