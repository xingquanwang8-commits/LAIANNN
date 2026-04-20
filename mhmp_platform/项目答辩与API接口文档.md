# 项目答辩与API接口文档

## 文档说明
- 文档用途：用于毕业答辩时快速理解本系统的技术栈、架构设计、业务模块和接口清单。
- 适用范围：`mhmp` 前端 + `mhmp_back` 后端。
- 基线版本：基于当前仓库代码整理，更新时间为 2026-04-20。
- 维护规则：后续只要系统发生以下变化，必须同步更新本文档：
  - 新增、删除、重命名接口
  - 修改权限码、菜单结构、登录鉴权方式
  - 调整前后端技术栈
  - 调整核心业务流程
  - 调整启动方式、端口、数据库或 Redis 配置

## 1. 项目概述
本项目是一个基于 Vue3 + Spring Boot 的博物馆文物综合管理平台，目标是覆盖文物日常管理中的核心业务流程，重点服务于毕业设计演示与答辩。

系统当前主要包含以下业务模块：
- 登录认证与菜单权限
- 首页统计看板
- 用户、角色、菜单、字典、操作日志等系统管理
- 文物建档、编辑、详情、附件管理、馆内转存
- 文物入库、出库、归还
- 库存查询与盘点任务
- 文物修复申请、审批、过程记录、验收、历史追踪
- 个人中心与密码修改
- 业务文件上传

项目设计原则偏向“可运行、可演示、逻辑清晰”，没有引入微服务、消息队列等重型架构。

## 2. 技术栈

### 2.1 前端技术栈
| 技术 | 版本/类型 | 作用 |
| --- | --- | --- |
| Vue 3 | 核心框架 | 构建单页应用 |
| Vue Router 4 | 路由 | 管理登录页、业务页、权限跳转 |
| Pinia | 状态管理 | 保存登录态、用户信息、菜单信息、字典缓存 |
| Element Plus | UI 组件库 | 表单、表格、抽屉、对话框、消息提示 |
| Axios | HTTP 客户端 | 调用后端接口 |
| Vue CLI 5 | 构建工具 | 开发、打包、代理转发 |
| ESLint | 代码规范 | 基础静态检查 |

前端当前推荐使用 Node.js 18 LTS 或 20 LTS 作为运行环境。由于 Vue CLI 5 的依赖链仍包含 `spdy` 等旧包，项目已在 `mhmp/package.json` 中增加 `postinstall` 自动补丁脚本，用于把旧依赖中的 `util._extend` 替换为标准 `Object.assign()`，以消除新版 Node 的废弃告警；答辩和演示环境不建议使用 Node.js 24。
前端当前已对 Element Plus 做按需组件注册和按需样式引入，用于在不影响现有功能的前提下减小构建包体。

### 2.2 后端技术栈
| 技术 | 版本/类型 | 作用 |
| --- | --- | --- |
| Java | 17 | 后端运行环境 |
| Spring Boot | 3.3.5 | Web 应用基础框架 |
| Spring Security | 权限框架 | 统一认证与鉴权 |
| JWT | Token 鉴权 | 生成和校验登录令牌 |
| Redis | 会话存储 | 保存 Token 激活状态，实现退出登录失效 |
| MyBatis-Plus | ORM 增强 | Mapper、分页、逻辑删除 |
| MySQL 8 | 数据库 | 业务数据持久化 |
| Lombok | 代码简化 | DTO/VO/Entity 常用 getter/setter |
| Spring AOP | 切面 | 记录操作日志 |
| Jakarta Validation | 参数校验 | DTO 字段校验 |

### 2.3 基础运行环境
| 项目 | 默认值 | 说明 |
| --- | --- | --- |
| 前端端口 | `8081` | `mhmp/vue.config.js` |
| 后端端口 | `8080` | `application.yml` |
| Node.js | `18 LTS` / `20 LTS` | 前端推荐运行环境，不建议使用 `24.x` |
| MySQL | `127.0.0.1:3306/mhmp_db` | 主业务数据库 |
| Redis | `127.0.0.1:6379` | Token 状态缓存 |
| 上传目录 | `uploads` | 业务附件物理存储目录 |

## 3. 目录结构
```text
mhmp_platform/
├─ mhmp/                         前端项目
│  ├─ src/api/                   前端接口封装
│  ├─ src/views/                 页面视图
│  ├─ src/router/                前端路由守卫
│  ├─ src/stores/                Pinia 状态
│  ├─ src/utils/                 请求、表单、异常、业务规则工具
│  └─ vue.config.js              开发代理与端口配置
├─ mhmp_back/                    后端项目
│  ├─ src/main/java/com/mhmp/controller/   控制器层
│  ├─ src/main/java/com/mhmp/service/      业务接口层
│  ├─ src/main/java/com/mhmp/serviceImpl/  业务实现层
│  ├─ src/main/java/com/mhmp/mapper/       数据访问层
│  ├─ src/main/java/com/mhmp/entity/       实体类
│  ├─ src/main/java/com/mhmp/dto/          请求 DTO
│  ├─ src/main/java/com/mhmp/vo/           响应 VO
│  ├─ src/main/java/com/mhmp/config/       配置类
│  ├─ src/main/java/com/mhmp/common/       公共结果、异常、安全、注解、工具
│  └─ src/main/resources/application.yml   主配置文件
└─ 项目答辩与API接口文档.md        当前文档
```

## 4. 系统整体架构

### 4.1 前后端关系
- 前端是 Vue 单页应用，负责页面展示、表单交互、表格查询、路由权限控制。
- 后端是 Spring Boot REST API，负责登录鉴权、业务规则、数据库访问、文件上传和日志记录。
- 前端开发环境通过代理将 `/api` 和 `/uploads` 请求转发到 `http://127.0.0.1:8080`。

### 4.2 后端分层
- `controller`：接收请求、参数校验、返回统一响应。
- `service / serviceImpl`：处理业务流程与规则。
- `mapper`：MyBatis-Plus 数据访问。
- `entity`：对应数据库表。
- `dto`：接收前端请求参数。
- `vo`：返回给前端的结果对象。
- `common`：统一返回、异常、JWT、安全、AOP 日志、通用工具。

### 4.3 核心配置特点
- Spring Security 使用无状态模式：`SessionCreationPolicy.STATELESS`
- 逻辑删除字段统一为 `deleted`
- 文件通过 `/uploads/**` 暴露静态资源
- JWT 默认有效期为 `86400` 秒
- 是否初始化演示数据由 `mhmp.startup.init-enabled` 控制

## 5. 登录、权限与日志机制

### 5.1 登录流程
1. 前端调用 `POST /api/auth/login`，提交用户名和密码。
2. 后端在 `AuthServiceImpl` 中校验账号状态与密码。
3. 校验通过后生成 JWT，并将 Token 写入 Redis。
4. 前端把 Token 保存到 `sessionStorage`，不会长期写入 `localStorage`。
5. 前端继续调用：
   - `GET /api/auth/current-user` 获取当前用户信息、角色、权限码
   - `GET /api/auth/menus` 获取当前账号可见菜单
6. 前端路由根据权限控制页面访问。

### 5.2 鉴权机制
- 请求头格式：`Authorization: Bearer {token}`
- 后端过滤器：`JwtAuthenticationFilter`
- 校验规则：
  - JWT 格式合法
  - Redis 中 Token 仍然有效
  - 用户状态为启用
- 退出登录时：
  - 前端清理 `sessionStorage`
  - 后端删除 Redis 中的 Token

### 5.3 权限机制
- 权限来源：用户 -> 角色 -> 菜单/权限码
- 控制方式：控制器方法上使用 `@PreAuthorize`
- 前端页面路由也带有 `permission` 元信息，用于页面级访问限制
- 当前内置角色固定为 4 类：
  - `admin` / 系统管理员：拥有全部菜单与按钮权限
  - `senior_researcher` / 高级研究员：负责入库审批、出库审批、转存任务派发、修复审批和修复验收，同时保留研究员的业务办理权限
- `researcher` / 研究员：负责建档、入库登记、出库申请、转存确认、盘点、修复申请和修复过程记录，不再保留审批类权限
- 盘点任务支持“高级研究员发起并指派研究员负责人”，研究员进入“我的盘点”页面处理自己负责的盘点任务
- 转存任务支持“系统管理员/高级研究员发起并指派研究员执行”，研究员进入“我的转存”页面确认完成任务
  - `docent` / 讲解员：保持原只读讲解类权限不变
- 演示库默认账号 `researcher` 已迁移为 `senior_researcher`，便于直接演示审批与修复验收流程
- 演示数据额外预置了 `senior_researcher02`、`senior_researcher03`、`senior_researcher04` 三个高级研究员账号，便于多账号分角色演示审批链路
- 用户管理目前按“单账号单主角色”维护，`roleIds` 仍为数组字段，但后端只允许提交 1 个角色 ID，前端表单也已改为单选主角色

### 5.4 操作日志
- 通过自定义注解 `@OperationLog` 标记重要业务方法
- 使用 AOP 切面 `OperationLogAspect` 自动记录：
  - 操作人
  - 模块名
  - 业务类型
  - 请求地址
  - 请求参数
  - 响应结果或异常信息
  - 操作耗时

这部分是答辩重点，体现了系统的“审计留痕”能力。

## 6. 前端页面模块
前端实际主入口以 `APP_ROUTE_DEFINITIONS` 为准，当前主要页面如下：

| 前端路由 | 页面功能 | 主要权限 |
| --- | --- | --- |
| `/login` | 登录页 | 无 |
| `/dashboard` | 首页统计看板 | `dashboard:view` |
| `/system/user` | 用户管理 | `sys:user:view` |
| `/system/role` | 角色管理 | `sys:role:view` |
| `/system/menu` | 菜单管理 | `sys:menu:view` |
| `/system/dict` | 字典管理 | `sys:dict:view` |
| `/system/log` | 操作日志 | `sys:log:view` |
| `/relic/list` | 文物列表 | `relic:list:view` |
| `/relic/detail/:id` | 文物详情 | `relic:detail:view` 等 |
| `/relic/create` | 新增文物 | `relic:add` |
| `/relic/edit/:id` | 编辑文物 | `relic:edit` |
| `/inventory/transfer` | 发起转存 | `inventory:transfer:view` |
| `/inventory/transfer/my` | 我的转存 | `inventory:transfer:my:view` |
| `/inventory/inbound` | 入库业务 | `inventory:inbound:view` |
| `/inventory/inbound/approve` | 入库审批查询 | `inventory:inbound:approve` |
| `/inventory/outbound/apply` | 出库申请 | `inventory:outbound:apply:view` |
| `/inventory/outbound/approve` | 出库审批 | `inventory:outbound:approve:view` |
| `/inventory/query` | 库存查询 | `inventory:query:view` |
| `/inventory/task` | 盘点任务 | `inventory:task:view` |
| `/inventory/task/my` | 我的盘点 | `inventory:task:view` |
| `/repair/apply` | 修复申请 | `repair:apply:view` |
| `/repair/approve` | 修复审批 | `repair:approve:view` |
| `/repair/process` | 修复过程 | `repair:process:view` |
| `/repair/acceptance` | 修复验收 | `repair:acceptance:view` |
| `/repair/history` | 修复历史 | `repair:history:view` |
| `/profile` | 个人中心（资料维护、头像上传、密码修改） | `profile:view` |

## 7. 核心数据表/实体
答辩时可以按下面的业务分组讲数据库设计：

### 7.1 系统权限相关
- `sys_user`：用户
- `sys_role`：角色
- `sys_menu`：菜单和权限节点
- `sys_user_role`：用户角色关联
- `sys_role_menu`：角色菜单关联
- `sys_role_menu` 补充说明：角色授权保存时会直接同步这张表，采用“逻辑删除 + 恢复已存在关联”的方式，避免重复授权时因 `(role_id, menu_id)` 唯一约束导致保存失败。
- 角色管理页补充说明：授权菜单树采用“独立勾选 + 向下联动”模式，勾选父菜单时会自动勾选下级节点，便于批量授权；取消某个子页面或按钮时不会反向强制改动父节点，因此页面权限和按钮权限仍然可以分开精确控制。
- `sys_operation_log`：操作日志
- `sys_dict_type`：字典类型
- `sys_dict_item`：字典项

### 7.2 文物业务相关
- `relic`：文物主档案
- `relic_attachment`：文物附件
- `relic_inbound_order` / `relic_inbound_detail`：入库单及明细
- `relic_outbound_order` / `relic_outbound_detail`：出库单及明细
- `relic_transfer_task`：馆内转存任务，记录派发人、研究员负责人、目标库位和确认结果
- `inventory_task` / `inventory_task_detail`：盘点任务及明细，其中 `inventory_task.principal_user_id` 记录负责人用户 ID，`principal_name` 记录负责人展示名快照
- `repair_task`：修复任务
- `repair_plan`：修复方案
- `repair_log`：修复过程日志
- `repair_acceptance`：修复验收

## 8. 统一接口规范

### 8.1 接口前缀
- 后端业务接口统一前缀：`/api`
- 文件访问路径统一前缀：`/uploads`

### 8.2 统一返回格式
后端统一返回 `R<T>` 结构，前端按 `code` 解包。

```json
{
  "code": 200,
  "message": "操作成功",
  "msg": "操作成功",
  "data": {},
  "success": true,
  "timestamp": 1710000000000
}
```

### 8.3 分页返回格式
分页接口的 `data` 一般是 `PageResponse<T>`：

```json
{
  "total": 100,
  "pageNum": 1,
  "pageSize": 10,
  "records": []
}
```

### 8.4 常见状态码
| 状态码 | 含义 |
| --- | --- |
| `200` | 请求成功 |
| `401` | 未登录、Token 失效、账号不存在或会话过期 |
| `403` | 已登录但无权限 |
| `500` | 业务失败或系统异常 |

### 8.5 分页查询约定
多数分页接口支持：
- `pageNum`：页码，默认 `1`
- `pageSize`：每页条数，默认 `10`

### 8.6 文件上传约定
- 接口：`POST /api/files/upload`
- 格式：`multipart/form-data`
- 参数：
  - `file`：文件本体
  - `bizType`：业务目录，可选，例如 `avatar`、`relic-image`
- 返回：
  - `fileName`
  - `fileUrl`
  - `fileSize`
  - `fileSuffix`

## 9. API 接口清单

### 9.1 认证与菜单
| 方法 | 路径 | 权限 | 说明 | 关键参数 |
| --- | --- | --- | --- | --- |
| POST | `/api/auth/login` | 无 | 用户登录 | `username`、`password` |
| POST | `/api/auth/logout` | 已登录 | 退出登录并使 Token 失效 | Header 中的 Bearer Token |
| GET | `/api/auth/current-user` | 已登录 | 获取当前用户信息、角色、权限码 | 无 |
| GET | `/api/auth/menus` | 已登录 | 获取当前账号可访问菜单树 | 无 |

登录成功后 `data` 主要字段：
- `token`
- `tokenType`
- `expireSeconds`

### 9.2 首页、个人中心、文件与公共字典
| 方法 | 路径 | 权限 | 说明 | 关键参数 |
| --- | --- | --- | --- | --- |
| GET | `/api/dashboard/summary` | `dashboard:view` | 首页统计汇总 | 无 |
| GET | `/api/profile` | `profile:view` | 获取个人资料 | 无 |
| PUT | `/api/profile` | `profile:view` | 修改个人资料 | `nickName`、`realName`、`phone`、`email`、`gender`、`avatarUrl`、`remark` |
| PUT | `/api/profile/password` | `profile:view` | 修改密码 | `oldPassword`、`newPassword` |
| POST | `/api/files/upload` | 已登录 | 上传业务文件 | `file`、`bizType` |
| GET | `/api/dict/types` | 已登录 | 获取可用字典类型 | 无 |
| GET | `/api/dict/{dictTypeCode}/items` | 已登录 | 获取某字典类型下的字典项 | 路径参数 `dictTypeCode` |

### 9.3 系统管理

#### 9.3.1 用户管理
| 方法 | 路径 | 权限 | 说明 | 关键参数 |
| --- | --- | --- | --- | --- |
| GET | `/api/system/users/page` | `sys:user:view` | 用户分页查询 | `pageNum`、`pageSize`、`keyword`、`status`、`roleId` |
| GET | `/api/system/users/{id}` | `sys:user:view` | 用户详情 | 路径参数 `id` |
| POST | `/api/system/users` | `sys:user:add` | 新增用户 | `username`、`password`、`nickName`、`realName`、`phone`、`email`、`gender`、`avatarUrl`、`status`、`remark`、`roleIds`（仅允许 1 个主角色） |
| PUT | `/api/system/users/{id}` | `sys:user:edit` | 编辑用户 | 同新增，编辑时密码可为空，`roleIds` 仍仅允许 1 个主角色 |
| PUT | `/api/system/users/{id}/status` | `sys:user:edit` | 修改用户状态 | `status` |
| DELETE | `/api/system/users/{id}` | `sys:user:delete` | 删除用户 | 路径参数 `id` |

#### 9.3.2 角色管理
| 方法 | 路径 | 权限 | 说明 | 关键参数 |
| --- | --- | --- | --- | --- |
| GET | `/api/system/roles/page` | `sys:role:view` | 角色分页查询 | `pageNum`、`pageSize`、`keyword`、`status` |
| GET | `/api/system/roles/list` | `sys:role:view` | 获取角色列表 | 无 |
| GET | `/api/system/roles/{id}` | `sys:role:view` | 角色详情 | 路径参数 `id` |
| POST | `/api/system/roles` | `sys:role:add` | 新增角色 | `roleName`、`roleCode`、`status`、`remark` |
| PUT | `/api/system/roles/{id}` | `sys:role:edit` | 编辑角色 | 同新增 |
| PUT | `/api/system/roles/{id}/status` | `sys:role:status` | 修改角色状态 | `status` |
| PUT | `/api/system/roles/{id}/menus` | `sys:role:assign` | 分配角色菜单权限 | `menuIds` |
| DELETE | `/api/system/roles/{id}` | `sys:role:delete` | 删除角色 | 路径参数 `id` |

#### 9.3.3 菜单管理
| 方法 | 路径 | 权限 | 说明 | 关键参数 |
| --- | --- | --- | --- | --- |
| GET | `/api/system/menus/tree` | `sys:menu:view` | 查询菜单树 | 无 |
| GET | `/api/system/menus/{id}` | `sys:menu:view` | 查询菜单详情 | 路径参数 `id` |
| POST | `/api/system/menus` | `sys:menu:add` | 新增菜单 | `parentId`、`menuName`、`menuCode`、`menuType`、`path`、`component`、`permissionCode`、`sortNo`、`visible`、`status`、`icon`、`keepAlive`、`remark` |
| PUT | `/api/system/menus/{id}` | `sys:menu:edit` | 编辑菜单 | 同新增 |
| DELETE | `/api/system/menus/{id}` | `sys:menu:delete` | 删除菜单 | 路径参数 `id` |

#### 9.3.4 字典管理
| 方法 | 路径 | 权限 | 说明 | 关键参数 |
| --- | --- | --- | --- | --- |
| GET | `/api/system/dicts/types/page` | `sys:dict:view` | 字典类型分页 | `pageNum`、`pageSize`、`keyword`、`status` |
| POST | `/api/system/dicts/types` | `sys:dict:view` | 新增字典类型 | `dictName`、`dictTypeCode`、`status`、`remark` |
| PUT | `/api/system/dicts/types/{id}` | `sys:dict:view` | 编辑字典类型 | 同新增 |
| DELETE | `/api/system/dicts/types/{id}` | `sys:dict:view` | 删除字典类型 | 路径参数 `id` |
| GET | `/api/system/dicts/{dictTypeCode}/items` | `sys:dict:view` | 查询字典项 | 路径参数 `dictTypeCode` |
| POST | `/api/system/dicts/items` | `sys:dict:view` | 新增字典项 | `dictTypeCode`、`itemLabel`、`itemValue`、`itemSort`、`status`、`cssClass`、`remark` |
| PUT | `/api/system/dicts/items/{id}` | `sys:dict:view` | 编辑字典项 | 同新增 |
| DELETE | `/api/system/dicts/items/{id}` | `sys:dict:view` | 删除字典项 | 路径参数 `id` |
| POST | `/api/system/dicts/import` | `sys:dict:import` | 批量导入字典项 | `dictTypeCode`、`content` |

#### 9.3.5 操作日志
| 方法 | 路径 | 权限 | 说明 | 关键参数 |
| --- | --- | --- | --- | --- |
| GET | `/api/system/logs/page` | `sys:log:view` | 日志分页查询 | `pageNum`、`pageSize`、`username`、`moduleName`、`businessType`、`operationStatus`、`startTime`、`endTime` |
| GET | `/api/system/logs/{id}` | `sys:log:view` | 日志详情 | 路径参数 `id` |

### 9.4 文物管理
| 方法 | 路径 | 权限 | 说明 | 关键参数 |
| --- | --- | --- | --- | --- |
| GET | `/api/relic/page` | `relic:list:view` / `relic:view` | 文物分页查询 | `pageNum`、`pageSize`、`keyword`、`categoryCode`、`materialCode`、`preservationStatusCode`、`currentStatus`、`storageLocationCode` |
| GET | `/api/relic/{id}` | `relic:detail:view` 等 | 文物详情 | 路径参数 `id` |
| GET | `/api/relic/{id}/attachments` | `relic:detail:view` 等 | 文物附件列表 | 路径参数 `id` |
| POST | `/api/relic` | `relic:add` | 新增文物 | `relicNo`、`name`、`categoryCode`、`materialCode`、`era`、`source`、`storageLocationCode`、`preservationStatusCode`、`currentStatus`、`protectionLevel`、`storageCondition`、`attentionNote`、`description`、`note`、`imageUrl`、`appraisalReportUrl`、`attachments` |
| PUT | `/api/relic/{id}` | `relic:edit` | 编辑文物 | 同新增 |
| POST | `/api/relic/categories` | `relic:add` / `relic:edit` | 新增文物类别字典项 | `categoryName` |
| POST | `/api/relic/materials` | `relic:add` / `relic:edit` | 新增文物材质字典项 | `materialName` |
| DELETE | `/api/relic/{id}` | `relic:delete` | 删除文物 | 路径参数 `id` |

附件对象 `attachments` 的主要字段：
- `attachmentType`
- `fileName`
- `fileUrl`
- `fileSize`
- `fileSuffix`
- `remark`

### 9.5 入库、出库与库存盘点

#### 9.5.1 入库
| 方法 | 路径 | 权限 | 说明 | 关键参数 |
| --- | --- | --- | --- | --- |
| GET | `/api/inbound/page` | `inventory:inbound:view` | 入库单分页 | `pageNum`、`pageSize`、`keyword`、`status` |
| GET | `/api/inbound/{id}` | `inventory:inbound:view` | 入库单详情 | 路径参数 `id` |
| POST | `/api/inbound` | `inventory:inbound:add` | 新建入库单 | `batchNo`、`source`、`handlerName`、`inboundTime`、`storageLocationCode`、`remark`、`relicIds` |
| POST | `/api/inbound/approve/{id}` | `inventory:inbound:approve` | 审批入库单 | 路径参数 `id` |

#### 9.5.2 出库
| 方法 | 路径 | 权限 | 说明 | 关键参数 |
| --- | --- | --- | --- | --- |
| GET | `/api/outbound/page` | `inventory:outbound:apply:view` / `inventory:outbound:approve:view` | 出库单分页 | `pageNum`、`pageSize`、`keyword`、`approveStatus`、`applyUserId` |
| GET | `/api/outbound/{id}` | 同上 | 出库单详情 | 路径参数 `id` |
| POST | `/api/outbound` | `inventory:outbound:submit` | 新建出库申请 | `purpose`、`destination`、`handlerName`、`outboundTime`、`remark`、`relicIds` |
| POST | `/api/outbound/approve/{id}` | `inventory:outbound:approve` | 审批通过 | `approveRemark` |
| POST | `/api/outbound/reject/{id}` | `inventory:outbound:reject` | 审批驳回 | `approveRemark` |
| POST | `/api/outbound/return/{id}` | `inventory:outbound:approve` / `inventory:outbound:submit` | 文物归还登记 | `returnTime`、`remark` |

#### 9.5.3 库存查询与盘点
| 方法 | 路径 | 权限 | 说明 | 关键参数 |
| --- | --- | --- | --- | --- |
| GET | `/api/inventory/query/summary` | `inventory:query:view` | 库存统计概览 | 无 |
| GET | `/api/inventory/query/page` | `inventory:query:view` | 库存分页查询 | `pageNum`、`pageSize`、`keyword`、`categoryCode`、`materialCode`、`storageLocationCode`、`preservationStatusCode`、`currentStatus` |
| GET | `/api/inventory/tasks/page` | `inventory:task:view` | 盘点任务分页 | `pageNum`、`pageSize`、`keyword`、`locationCode`、`taskStatus`、`principalUserId` |
| GET | `/api/inventory/tasks/{id}` | `inventory:task:view` | 盘点任务详情 | 路径参数 `id` |
| GET | `/api/inventory/tasks/principals` | `inventory:task:add` | 获取可选盘点负责人 | 无，返回当前账号可指派的研究员列表 |
| POST | `/api/inventory/tasks` | `inventory:task:add` | 创建盘点任务 | `taskName`、`locationCode`、`startTime`、`principalUserId`、`remark` |
| PUT | `/api/inventory/tasks/{taskId}/details/{detailId}` | `inventory:task:submit` | 更新盘点明细 | `actualQuantity`、`diffRemark` |
| POST | `/api/inventory/tasks/{taskId}/submit` | `inventory:task:submit` | 提交盘点任务 | 路径参数 `taskId` |
| GET | `/api/inventory/transfer-tasks/principals` | `inventory:transfer:add` | 获取可选转存负责人 | 无，返回可指派的研究员列表 |
| POST | `/api/inventory/transfer-tasks` | `inventory:transfer:add` | 创建单个转存任务 | `relicId`、`principalUserId`、`targetLocationCode`、`transferReason` |
| POST | `/api/inventory/transfer-tasks/batch` | `inventory:transfer:add` | 批量创建转存任务 | `relicIds`、`principalUserId`、`targetLocationCode`、`transferReason` |
| GET | `/api/inventory/transfer-tasks/my/page` | `inventory:transfer:my:view` | 我的转存任务分页 | `pageNum`、`pageSize`、`keyword`、`taskStatus` |
| GET | `/api/inventory/transfer-tasks/{id}` | `inventory:transfer:view` / `inventory:transfer:my:view` | 转存任务详情 | 路径参数 `id` |
| POST | `/api/inventory/transfer-tasks/{id}/confirm` | `inventory:transfer:confirm` | 确认转存完成 | 路径参数 `id`，请求体可选 `confirmRemark` |

补充说明：
- 高级研究员和系统管理员可以为任意“研究员”发起盘点任务。
- 研究员只能为自己发起盘点任务，前端“我的盘点”页面通过 `principalUserId = 当前用户ID` 过滤任务。
- 系统管理员和高级研究员可以发起转存任务，并将任务派发给研究员执行。
- 研究员在“我的转存”页面确认任务完成后，系统才会正式更新文物库位；当前版本确认时不再要求上传照片。

### 9.6 修复管理
| 方法 | 路径 | 权限 | 说明 | 关键参数 |
| --- | --- | --- | --- | --- |
| GET | `/api/repair/apply/page` | `repair:apply:view` | 修复申请列表 | `pageNum`、`pageSize`、`keyword`、`taskStatus`、`acceptanceStatus` |
| GET | `/api/repair/approve/page` | `repair:approve:view` | 修复审批列表 | 同上 |
| GET | `/api/repair/process/page` | `repair:process:view` | 修复过程列表 | 同上 |
| GET | `/api/repair/acceptance/page` | `repair:acceptance:view` | 修复验收列表 | 同上 |
| GET | `/api/repair/history/page` | `repair:history:view` | 修复历史列表 | 同上 |
| GET | `/api/repair/pending-relics/page` | `repair:apply:view` | 待修复文物分页 | 复用文物分页筛选参数 |
| GET | `/api/repair/my/page` | `repair:process:view` | 我的修复任务 | `pageNum`、`pageSize`、`keyword`、`taskStatus`、`acceptanceStatus` |
| GET | `/api/repair/repaired/page` | `repair:history:view` | 已修复任务 | `pageNum`、`pageSize`、`keyword`、`taskStatus`、`acceptanceStatus` |
| GET | `/api/repair/{id}` | 多个修复权限之一 | 修复任务详情 | 路径参数 `id` |
| POST | `/api/repair/apply` | `repair:apply:submit` | 发起修复申请 | `relicId`、`applyReason`、`remark` |
| POST | `/api/repair/approve/{id}` | `repair:plan:approve` | 审批修复申请并制定方案 | `approveResult`、`approveRemark`、`planTitle`、`planContent`、`materials`、`riskNote` |
| POST | `/api/repair/process/{id}/log` | `repair:log:add` | 新增修复过程日志 | `stepName`、`operationContent`、`materialsUsed`、`operatorName`、`logTime`、`progressStatus`、`remark`、`attachments` |
| POST | `/api/repair/process/{id}/apply-acceptance` | `repair:log:add` | 申请修复验收 | 路径参数 `id` |
| POST | `/api/repair/acceptance/{id}` | `repair:acceptance:add` | 提交修复验收结果 | `acceptanceResult`、`acceptanceTime`、`acceptanceRemark`、`followUpSuggestion`、`preservationStatusCode`、`storageLocationCode` |

## 10. 典型业务流程

### 10.1 文物建档流程
1. 管理员或业务人员登录系统
2. 获取字典项、类别、材质、库位等下拉数据
3. 上传主图和附件文件
4. 调用文物新增接口创建主档
5. 在文物列表、详情页中查看结果

### 10.2 入库流程
1. 选择待入库文物
2. 创建入库单
3. 审批入库单
4. 文物状态更新为在库，库位生效

### 10.3 出库流程
1. 选择文物并填写出库用途、去向
2. 创建出库申请
3. 审批通过或驳回
4. 如已出库，后续执行归还登记

### 10.4 盘点流程
1. 高级研究员或研究员针对指定库位发起盘点任务，并选择研究员负责人
2. 自动生成盘点明细
3. 负责人在“我的盘点”页面填写实际数量与差异备注
4. 提交盘点任务形成结果

### 10.5 转存流程
1. 系统管理员或高级研究员选择文物并发起转存任务
2. 选择目标库位，并指派研究员负责人
3. 研究员在“我的转存”页面查看自己负责的转存任务
4. 实际完成转存后，研究员点击“确认转存”完成任务闭环
5. 系统正式更新文物库位，并在文物详情时间线中记录转存结果

### 10.6 修复流程
1. 从待修复文物中发起修复申请
2. 审批人审核并制定修复方案
3. 修复人员持续记录修复日志
4. 修复完成后申请验收
5. 验收通过后更新保存状态和回库位置

## 11. 答辩建议讲解顺序
建议答辩时按下面顺序讲，逻辑最清晰：

1. 先讲项目定位：这是一个围绕文物全生命周期管理的综合平台。
2. 再讲技术栈：前端 Vue3，后端 Spring Boot，鉴权是 Spring Security + JWT + Redis。
3. 再讲架构分层：Controller、Service、Mapper、DTO、VO。
4. 再讲统一机制：统一返回结构、统一权限码、统一操作日志。
5. 然后讲核心业务流程：建档、入库、出库、盘点、修复。
6. 最后讲亮点：
   - 菜单和按钮权限联动
   - JWT + Redis 退出登录失效
   - AOP 自动记录操作日志
   - 字典管理支持统一维护下拉选项

## 12. 后续维护清单
以后如果继续对系统做修改，更新本文档时至少检查以下内容：
- 是否新增了控制器方法或修改了接口路径
- 是否修改了 DTO 字段或分页筛选条件
- 是否修改了权限码
- 是否修改了前端路由入口
- 是否修改了登录、Token、Redis、文件上传逻辑
- 是否增加了新的业务模块或数据表

如果这份文档和代码不一致，以代码为准，并应立刻回补文档。
