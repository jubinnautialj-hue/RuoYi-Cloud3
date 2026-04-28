/*
 ============================================
  文件名：03_数据字典.sql
  描述：Flowable 工作流数据字典插入脚本
  数据库：MySQL 8.0+
  执行顺序：第3步（在业务数据库执行）
 ============================================
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================
-- 1. 字典类型：流程状态 (wf_process_status)
-- ============================================
-- 先删除已存在的字典类型和数据（如果存在）
DELETE FROM `sys_dict_data` WHERE `dict_type` = 'wf_process_status';
DELETE FROM `sys_dict_type` WHERE `dict_type` = 'wf_process_status';

-- 插入字典类型
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) 
VALUES (500, '流程状态', 'wf_process_status', '0', 'admin', SYSDATE(), '', NULL, '工作流程状态');

-- ============================================
-- 2. 字典数据：流程状态
-- ============================================
-- 进行中
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) 
VALUES (501, 1, '进行中', 'running', 'wf_process_status', '', 'primary', 'N', '0', 'admin', SYSDATE(), '', NULL, '进行中状态');

-- 已终止
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) 
VALUES (502, 2, '已终止', 'terminated', 'wf_process_status', '', 'danger', 'N', '0', 'admin', SYSDATE(), '', NULL, '已终止状态');

-- 已完成
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) 
VALUES (503, 3, '已完成', 'completed', 'wf_process_status', '', 'success', 'N', '0', 'admin', SYSDATE(), '', NULL, '已完成状态');

-- 已取消
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) 
VALUES (504, 4, '已取消', 'canceled', 'wf_process_status', '', 'warning', 'N', '0', 'admin', SYSDATE(), '', NULL, '已取消状态');

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- 执行完成提示
-- ============================================
-- SELECT '流程状态数据字典插入完成！' AS Message;
