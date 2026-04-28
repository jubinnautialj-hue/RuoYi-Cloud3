/*
 ============================================
  文件名：02_工作流中心菜单.sql
  描述：Flowable 工作流菜单数据插入脚本
  数据库：MySQL 8.0+
  执行顺序：第2步（在业务数据库执行）
  注意：执行前请确认 sys_menu 表中不存在相同的 menu_id
 ============================================
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================
-- 一级菜单
-- 列顺序参考：ry_20260417.sql
-- menu_id, menu_name, parent_id, order_num, path, component, query, route_name, 
-- is_frame, is_cache, menu_type, visible, status, perms, icon, 
-- create_by, create_time, update_by, update_time, remark
-- ============================================

-- 流程管理
INSERT INTO `sys_menu` VALUES ('2350', '流程管理', '0', '4', 'process', NULL, '', '', 1, 0, 'M', '0', '0', '', 'skill', 'admin', SYSDATE(), '', NULL, '流程管理目录');

-- 办公管理
INSERT INTO `sys_menu` VALUES ('2355', '办公管理', '0', '5', 'work', NULL, '', '', 1, 0, 'M', '0', '0', '', 'job', 'admin', SYSDATE(), '', NULL, '办公管理目录');

-- ============================================
-- 二级菜单 - 流程管理下的菜单
-- ============================================

-- 流程分类
INSERT INTO `sys_menu` VALUES ('2351', '流程分类', '2350', '1', 'category', 'workflow/category/index', '', '', 1, 0, 'C', '0', '0', 'workflow:category:list', 'nested', 'admin', SYSDATE(), '', NULL, '流程分类菜单');

-- 表单配置
INSERT INTO `sys_menu` VALUES ('2352', '表单配置', '2350', '2', 'form', 'workflow/form/index', '', '', 1, 0, 'C', '0', '0', 'workflow:form:list', 'form', 'admin', SYSDATE(), '', NULL, '表单配置菜单');

-- 流程模型
INSERT INTO `sys_menu` VALUES ('2353', '流程模型', '2350', '3', 'model', 'workflow/model/index', '', '', 1, 0, 'C', '0', '0', 'workflow:model:list', 'component', 'admin', SYSDATE(), '', NULL, '流程模型菜单');

-- 部署管理
INSERT INTO `sys_menu` VALUES ('2354', '部署管理', '2350', '4', 'deploy', 'workflow/deploy/index', '', '', 1, 0, 'C', '0', '0', 'workflow:deploy:list', 'example', 'admin', SYSDATE(), '', NULL, '部署管理菜单');

-- ============================================
-- 二级菜单 - 办公管理下的菜单
-- ============================================

-- 新建流程
INSERT INTO `sys_menu` VALUES ('2356', '新建流程', '2355', '1', 'create', 'workflow/work/index', '', '', 1, 0, 'C', '0', '0', 'workflow:process:startList', 'guide', 'admin', SYSDATE(), '', NULL, '新建流程菜单');

-- 我的流程
INSERT INTO `sys_menu` VALUES ('2357', '我的流程', '2355', '2', 'own', 'workflow/work/own', '', '', 1, 0, 'C', '0', '0', 'workflow:process:ownList', 'cascader', 'admin', SYSDATE(), '', NULL, '我的流程菜单');

-- 待办任务
INSERT INTO `sys_menu` VALUES ('2358', '待办任务', '2355', '3', 'todo', 'workflow/work/todo', '', '', 1, 0, 'C', '0', '0', 'workflow:process:todoList', 'time-range', 'admin', SYSDATE(), '', NULL, '待办任务菜单');

-- 待签任务
INSERT INTO `sys_menu` VALUES ('2359', '待签任务', '2355', '4', 'claim', 'workflow/work/claim', '', '', 1, 0, 'C', '0', '0', 'workflow:process:claimList', 'checkbox', 'admin', SYSDATE(), '', NULL, '待签任务菜单');

-- 已办任务
INSERT INTO `sys_menu` VALUES ('2362', '已办任务', '2355', '5', 'finished', 'workflow/work/finished', '', '', 1, 0, 'C', '0', '0', 'workflow:process:finishedList', 'checkbox', 'admin', SYSDATE(), '', NULL, '已办任务菜单');

-- 抄送我的
INSERT INTO `sys_menu` VALUES ('2361', '抄送我的', '2355', '6', 'copy', 'workflow/work/copy', '', '', 1, 0, 'C', '0', '0', 'workflow:process:copyList', 'checkbox', 'admin', SYSDATE(), '', NULL, '抄送我的菜单');

-- ============================================
-- 三级菜单（按钮权限）- 流程分类管理
-- ============================================
INSERT INTO `sys_menu` VALUES ('2363', '分类查询', '2351', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:category:query', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2364', '分类新增', '2351', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:category:add', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2365', '分类编辑', '2351', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:category:edit', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2366', '分类删除', '2351', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:category:remove', '#', 'admin', SYSDATE(), '', NULL, '');

-- ============================================
-- 三级菜单（按钮权限）- 表单配置
-- ============================================
INSERT INTO `sys_menu` VALUES ('2367', '表单查询', '2352', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:form:query', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2368', '表单新增', '2352', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:form:add', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2369', '表单修改', '2352', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:form:edit', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2370', '表单删除', '2352', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:form:remove', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2371', '表单导出', '2352', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:form:export', '#', 'admin', SYSDATE(), '', NULL, '');

-- ============================================
-- 三级菜单（按钮权限）- 流程模型
-- ============================================
INSERT INTO `sys_menu` VALUES ('2372', '模型查询', '2353', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:query', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2373', '模型新增', '2353', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:add', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2374', '模型修改', '2353', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:edit', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2375', '模型删除', '2353', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:remove', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2376', '模型导出', '2353', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:export', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2377', '模型导入', '2353', '6', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:import', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2378', '模型设计', '2353', '7', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:designer', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2379', '模型保存', '2353', '8', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:save', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2380', '流程部署', '2353', '9', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:model:deploy', '#', 'admin', SYSDATE(), '', NULL, '');

-- ============================================
-- 三级菜单（按钮权限）- 部署管理
-- ============================================
INSERT INTO `sys_menu` VALUES ('2381', '部署查询', '2354', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:deploy:query', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2382', '部署删除', '2354', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:deploy:remove', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2383', '更新状态', '2354', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:deploy:status', '#', 'admin', SYSDATE(), '', NULL, '');

-- ============================================
-- 三级菜单（按钮权限）- 新建流程
-- ============================================
INSERT INTO `sys_menu` VALUES ('2384', '发起流程', '2356', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:process:start', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2385', '新建流程导出', '2356', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:process:startExport', '#', 'admin', SYSDATE(), '', NULL, '');

-- ============================================
-- 三级菜单（按钮权限）- 我的流程
-- ============================================
INSERT INTO `sys_menu` VALUES ('2386', '流程详情', '2357', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:process:query', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2387', '流程删除', '2357', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:process:remove', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2388', '流程取消', '2357', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:process:cancel', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2389', '我的流程导出', '2357', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:process:ownExport', '#', 'admin', SYSDATE(), '', NULL, '');

-- ============================================
-- 三级菜单（按钮权限）- 待办任务
-- ============================================
INSERT INTO `sys_menu` VALUES ('2390', '流程办理', '2358', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:process:approval', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2391', '待办流程导出', '2358', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:process:todoExport', '#', 'admin', SYSDATE(), '', NULL, '');

-- ============================================
-- 三级菜单（按钮权限）- 待签任务
-- ============================================
INSERT INTO `sys_menu` VALUES ('2392', '流程签收', '2359', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:process:claim', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2393', '待签流程导出', '2359', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:process:claimExport', '#', 'admin', SYSDATE(), '', NULL, '');

-- ============================================
-- 三级菜单（按钮权限）- 已办任务
-- ============================================
INSERT INTO `sys_menu` VALUES ('2394', '流程撤回', '2362', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:process:revoke', '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO `sys_menu` VALUES ('2395', '已办流程导出', '2362', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:process:finishedExport', '#', 'admin', SYSDATE(), '', NULL, '');

-- ============================================
-- 三级菜单（按钮权限）- 抄送我的
-- ============================================
INSERT INTO `sys_menu` VALUES ('2396', '抄送流程导出', '2361', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'workflow:process:copyExport', '#', 'admin', SYSDATE(), '', NULL, '');

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- 执行完成提示
-- ============================================
-- SELECT '工作流菜单数据插入完成！' AS Message;
