SET NAMES utf8mb4;
START TRANSACTION;

SET @operator_id = COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), 1);

UPDATE sys_menu
SET menu_name = CONVERT(0xE69687E789A9E7AEA1E79086 USING utf8mb4),
    path = '/relic',
    menu_type = 'DIR',
    sort_no = 20,
    visible = 1,
    status = 'ENABLED',
    icon = 'Collection',
    permission_code = NULL,
    update_by = @operator_id,
    deleted = 0
WHERE id = 200;

UPDATE sys_menu
SET menu_name = CONVERT(0xE5BA93E5AD98E7AEA1E79086 USING utf8mb4),
    path = '/inventory',
    menu_type = 'DIR',
    sort_no = 30,
    visible = 1,
    status = 'ENABLED',
    icon = 'Box',
    permission_code = NULL,
    update_by = @operator_id,
    deleted = 0
WHERE id = 300;

UPDATE sys_menu
SET menu_name = CONVERT(0xE4BFAEE5A48DE7AEA1E79086 USING utf8mb4),
    path = '/repair',
    menu_type = 'DIR',
    sort_no = 40,
    visible = 1,
    status = 'ENABLED',
    icon = 'Operation',
    permission_code = NULL,
    update_by = @operator_id,
    deleted = 0
WHERE id = 400;

UPDATE sys_menu
SET menu_name = CONVERT(0xE4B8AAE4BABAE4B8ADE5BF83 USING utf8mb4),
    icon = 'UserFilled',
    update_by = @operator_id,
    deleted = 0
WHERE id = 500;

UPDATE sys_menu
SET parent_id = 200,
    menu_name = CONVERT(0xE69687E789A9E58897E8A1A8 USING utf8mb4),
    path = '/relic/list',
    menu_type = 'MENU',
    permission_code = 'relic:list:view',
    sort_no = 21,
    visible = 1,
    status = 'ENABLED',
    icon = 'Tickets',
    update_by = @operator_id,
    deleted = 0
WHERE id = 201;

UPDATE sys_menu
SET parent_id = 200,
    menu_name = CONVERT(0xE69687E789A9E8AFA6E68385 USING utf8mb4),
    path = '/relic/detail/:id',
    menu_type = 'MENU',
    permission_code = 'relic:detail:view',
    sort_no = 29,
    visible = 0,
    status = 'ENABLED',
    icon = 'DocumentCopy',
    update_by = @operator_id,
    deleted = 0
WHERE id = 202;

INSERT INTO sys_menu (
    id, parent_id, menu_name, menu_code, menu_type, path, component, permission_code,
    sort_no, visible, status, icon, keep_alive, remark, create_by, update_by, deleted
) VALUES (
    203, 200, CONVERT(0xE696B0E5A29EE69687E789A9 USING utf8mb4), 'relic:create', 'MENU', '/relic/create', '',
    'relic:add', 22, 1, 'ENABLED', 'EditPen', 0, 'Restore sidebar menu', @operator_id, @operator_id, 0
)
ON DUPLICATE KEY UPDATE
    parent_id = VALUES(parent_id),
    menu_name = VALUES(menu_name),
    menu_type = VALUES(menu_type),
    path = VALUES(path),
    component = VALUES(component),
    permission_code = VALUES(permission_code),
    sort_no = VALUES(sort_no),
    visible = VALUES(visible),
    status = VALUES(status),
    icon = VALUES(icon),
    keep_alive = VALUES(keep_alive),
    remark = VALUES(remark),
    update_by = VALUES(update_by),
    deleted = 0;

UPDATE sys_menu
SET parent_id = 200,
    menu_name = CONVERT(0xE69687E789A9E585A5E5BA93 USING utf8mb4),
    path = '/inventory/inbound',
    menu_type = 'MENU',
    permission_code = 'inventory:inbound:view',
    sort_no = 23,
    visible = 1,
    status = 'ENABLED',
    icon = 'Upload',
    remark = 'Restore sidebar menu',
    update_by = @operator_id,
    deleted = 0
WHERE id = 301;

UPDATE sys_menu
SET parent_id = 200,
    menu_name = CONVERT(0xE69687E789A9E587BAE5BA93 USING utf8mb4),
    path = '/inventory/outbound/apply',
    menu_type = 'MENU',
    permission_code = 'inventory:outbound:apply:view',
    sort_no = 24,
    visible = 1,
    status = 'ENABLED',
    icon = 'Download',
    remark = 'Restore sidebar menu',
    update_by = @operator_id,
    deleted = 0
WHERE id = 302;

INSERT INTO sys_menu (
    id, parent_id, menu_name, menu_code, menu_type, path, component, permission_code,
    sort_no, visible, status, icon, keep_alive, remark, create_by, update_by, deleted
) VALUES (
    204, 300, CONVERT(0xE58F91E8B5B7E8BDACE5AD98 USING utf8mb4), 'inventory:transfer', 'MENU', '/inventory/transfer', '',
    'inventory:transfer:view', 34, 1, 'ENABLED', 'RefreshRight', 1, 'Restore sidebar menu', @operator_id, @operator_id, 0
)
ON DUPLICATE KEY UPDATE
    parent_id = VALUES(parent_id),
    menu_name = VALUES(menu_name),
    menu_code = VALUES(menu_code),
    menu_type = VALUES(menu_type),
    path = VALUES(path),
    component = VALUES(component),
    permission_code = VALUES(permission_code),
    sort_no = VALUES(sort_no),
    visible = VALUES(visible),
    status = VALUES(status),
    icon = VALUES(icon),
    keep_alive = VALUES(keep_alive),
    remark = VALUES(remark),
    update_by = VALUES(update_by),
    deleted = 0;

UPDATE sys_menu
SET parent_id = 300,
    menu_name = CONVERT(0xE5BA93E5AD98E69FA5E8AFA2 USING utf8mb4),
    path = '/inventory/query',
    menu_type = 'MENU',
    permission_code = 'inventory:query:view',
    sort_no = 31,
    visible = 1,
    status = 'ENABLED',
    icon = 'Search',
    update_by = @operator_id,
    deleted = 0
WHERE id = 304;

INSERT INTO sys_menu (
    id, parent_id, menu_name, menu_code, menu_type, path, component, permission_code,
    sort_no, visible, status, icon, keep_alive, remark, create_by, update_by, deleted
) VALUES (
    306, 300, CONVERT(0xE585A5E5BA93E5AEA1E689B9 USING utf8mb4), 'inventory:inbound-approve', 'MENU', '/inventory/inbound/approve', '',
    'inventory:inbound:approve', 32, 1, 'ENABLED', 'CircleCheck', 0, 'Restore sidebar menu', @operator_id, @operator_id, 0
)
ON DUPLICATE KEY UPDATE
    parent_id = VALUES(parent_id),
    menu_name = VALUES(menu_name),
    menu_type = VALUES(menu_type),
    path = VALUES(path),
    component = VALUES(component),
    permission_code = VALUES(permission_code),
    sort_no = VALUES(sort_no),
    visible = VALUES(visible),
    status = VALUES(status),
    icon = VALUES(icon),
    keep_alive = VALUES(keep_alive),
    remark = VALUES(remark),
    update_by = VALUES(update_by),
    deleted = 0;

UPDATE sys_menu
SET parent_id = 300,
    menu_name = CONVERT(0xE587BAE5BA93E5AEA1E689B9 USING utf8mb4),
    path = '/inventory/outbound/approve',
    menu_type = 'MENU',
    permission_code = 'inventory:outbound:approve:view',
    sort_no = 33,
    visible = 1,
    status = 'ENABLED',
    icon = 'CircleCheck',
    update_by = @operator_id,
    deleted = 0
WHERE id = 303;

UPDATE sys_menu
SET parent_id = 300,
    menu_name = CONVERT(0xE79B98E782B9E4BBBBE58AA1 USING utf8mb4),
    path = '/inventory/task',
    menu_type = 'MENU',
    permission_code = 'inventory:task:view',
    sort_no = 36,
    visible = 1,
    status = 'ENABLED',
    icon = 'Checked',
    update_by = @operator_id,
    deleted = 0
WHERE id = 305;

INSERT INTO sys_menu (
    id, parent_id, menu_name, menu_code, menu_type, path, component, permission_code,
    sort_no, visible, status, icon, keep_alive, remark, create_by, update_by, deleted
) VALUES (
    307, 300, CONVERT(0xE68891E79A84E8BDACE5AD98 USING utf8mb4), 'inventory:transfer:my', 'MENU', '/inventory/transfer/my', '',
    'inventory:transfer:my:view', 35, 1, 'ENABLED', 'Finished', 1, 'Restore sidebar menu', @operator_id, @operator_id, 0
)
ON DUPLICATE KEY UPDATE
    parent_id = VALUES(parent_id),
    menu_name = VALUES(menu_name),
    menu_code = VALUES(menu_code),
    menu_type = VALUES(menu_type),
    path = VALUES(path),
    component = VALUES(component),
    permission_code = VALUES(permission_code),
    sort_no = VALUES(sort_no),
    visible = VALUES(visible),
    status = VALUES(status),
    icon = VALUES(icon),
    keep_alive = VALUES(keep_alive),
    remark = VALUES(remark),
    update_by = VALUES(update_by),
    deleted = 0;

INSERT INTO sys_menu (
    parent_id, menu_name, menu_code, menu_type, path, component, permission_code,
    sort_no, visible, status, icon, keep_alive, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT
    300, CONVERT(0xE68891E79A84E79B98E782B9 USING utf8mb4), 'inventory:task:my', 'MENU', '/inventory/task/my', NULL, 'inventory:task:view',
    37, 1, 'ENABLED', 'List', 1, CONVERT(0xE79B98E782B9E4BEA7E8BEB9E8A18CE4BFAEE5A48D USING utf8mb4), @operator_id, NOW(), @operator_id, NOW(), 0
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM sys_menu WHERE menu_code = 'inventory:task:my' AND deleted = 0
);

UPDATE sys_menu
SET parent_id = 300,
    menu_name = CONVERT(0xE68891E79A84E79B98E782B9 USING utf8mb4),
    path = '/inventory/task/my',
    menu_type = 'MENU',
    permission_code = 'inventory:task:view',
    sort_no = 37,
    visible = 1,
    status = 'ENABLED',
    icon = 'List',
    update_by = @operator_id,
    deleted = 0
WHERE menu_code = 'inventory:task:my';

UPDATE sys_menu
SET parent_id = 306,
    menu_name = CONVERT(0xE585A5E5BA93E5AEA1E689B9 USING utf8mb4),
    sort_no = 1,
    visible = 1,
    status = 'ENABLED',
    update_by = @operator_id,
    deleted = 0
WHERE id = 4049;

UPDATE sys_menu
SET parent_id = 400,
    menu_name = CONVERT(0xE5BE85E4BFAEE5A48DE69687E789A9 USING utf8mb4),
    path = '/repair/apply',
    menu_type = 'MENU',
    permission_code = 'repair:apply:view',
    sort_no = 41,
    visible = 1,
    status = 'ENABLED',
    icon = 'Clock',
    update_by = @operator_id,
    deleted = 0
WHERE id = 401;

UPDATE sys_menu
SET parent_id = 400,
    menu_name = CONVERT(0xE4BFAEE5A48DE5AEA1E689B9 USING utf8mb4),
    path = '/repair/approve',
    menu_type = 'MENU',
    permission_code = 'repair:approve:view',
    sort_no = 42,
    visible = 1,
    status = 'ENABLED',
    icon = 'Document',
    update_by = @operator_id,
    deleted = 0
WHERE id = 402;

UPDATE sys_menu
SET parent_id = 400,
    menu_name = CONVERT(0xE68891E79A84E4BFAEE5A48D USING utf8mb4),
    path = '/repair/process',
    menu_type = 'MENU',
    permission_code = 'repair:process:view',
    sort_no = 43,
    visible = 1,
    status = 'ENABLED',
    icon = 'Files',
    update_by = @operator_id,
    deleted = 0
WHERE id = 403;

UPDATE sys_menu
SET parent_id = 400,
    menu_name = CONVERT(0xE4BFAEE5A48DE9AA8CE694B6 USING utf8mb4),
    path = '/repair/acceptance',
    menu_type = 'MENU',
    permission_code = 'repair:acceptance:view',
    sort_no = 44,
    visible = 1,
    status = 'ENABLED',
    icon = 'Select',
    update_by = @operator_id,
    deleted = 0
WHERE id = 404;

UPDATE sys_menu
SET parent_id = 400,
    menu_name = CONVERT(0xE5B7B2E4BFAEE5A48D USING utf8mb4),
    path = '/repair/history',
    menu_type = 'MENU',
    permission_code = 'repair:history:view',
    sort_no = 45,
    visible = 1,
    status = 'ENABLED',
    icon = 'DocumentCopy',
    update_by = @operator_id,
    deleted = 0
WHERE id = 405;

INSERT INTO sys_role_menu (role_id, menu_id, create_by, create_time, update_by, update_time, deleted)
SELECT r.id, m.id, @operator_id, NOW(), @operator_id, NOW(), 0
FROM sys_role r
JOIN sys_menu m ON m.id = 203 AND m.deleted = 0
WHERE r.role_code IN ('admin', 'researcher', 'senior_researcher')
  AND r.deleted = 0
  AND NOT EXISTS (
      SELECT 1 FROM sys_role_menu srm
      WHERE srm.role_id = r.id AND srm.menu_id = m.id AND srm.deleted = 0
  );

INSERT INTO sys_role_menu (role_id, menu_id, create_by, create_time, update_by, update_time, deleted)
SELECT r.id, m.id, @operator_id, NOW(), @operator_id, NOW(), 0
FROM sys_role r
JOIN sys_menu m ON m.id = 204 AND m.deleted = 0
WHERE r.role_code IN ('admin', 'senior_researcher')
  AND r.deleted = 0
  AND NOT EXISTS (
      SELECT 1 FROM sys_role_menu srm
      WHERE srm.role_id = r.id AND srm.menu_id = m.id AND srm.deleted = 0
  );

INSERT INTO sys_role_menu (role_id, menu_id, create_by, create_time, update_by, update_time, deleted)
SELECT r.id, m.id, @operator_id, NOW(), @operator_id, NOW(), 0
FROM sys_role r
JOIN sys_menu m ON m.id = 306 AND m.deleted = 0
WHERE r.role_code IN ('admin', 'senior_researcher')
  AND r.deleted = 0
  AND NOT EXISTS (
      SELECT 1 FROM sys_role_menu srm
      WHERE srm.role_id = r.id AND srm.menu_id = m.id AND srm.deleted = 0
  );

INSERT INTO sys_role_menu (role_id, menu_id, create_by, create_time, update_by, update_time, deleted)
SELECT r.id, m.id, @operator_id, NOW(), @operator_id, NOW(), 0
FROM sys_role r
JOIN sys_menu m ON m.menu_code = 'inventory:transfer:my' AND m.deleted = 0
WHERE r.role_code IN ('admin', 'researcher')
  AND r.deleted = 0
  AND NOT EXISTS (
      SELECT 1 FROM sys_role_menu srm
      WHERE srm.role_id = r.id AND srm.menu_id = m.id AND srm.deleted = 0
  );

INSERT INTO sys_role_menu (role_id, menu_id, create_by, create_time, update_by, update_time, deleted)
SELECT r.id, m.id, @operator_id, NOW(), @operator_id, NOW(), 0
FROM sys_role r
JOIN sys_menu m ON m.menu_code = 'inventory:task:my' AND m.deleted = 0
WHERE r.role_code IN ('admin', 'researcher', 'senior_researcher')
  AND r.deleted = 0
  AND NOT EXISTS (
      SELECT 1 FROM sys_role_menu srm
      WHERE srm.role_id = r.id AND srm.menu_id = m.id AND srm.deleted = 0
  );

COMMIT;
