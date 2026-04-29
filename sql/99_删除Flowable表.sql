/*
 ============================================
  文件名：99_删除Flowable表.sql
  描述：删除所有 Flowable 相关表（用于重建）
  数据库：MySQL 8.0+
  
  【警告】：此脚本会删除所有 Flowable 表和数据！
  仅在以下情况使用：
  1. 版本不匹配需要重建
  2. 表结构有问题需要重建
  3. 完全重新初始化
  
  执行前请确认：
  - 已备份重要数据
  - 了解此操作的后果
 ============================================
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================
-- 1. 删除历史表 (ACT_HI_*)
-- ============================================
DROP TABLE IF EXISTS `ACT_HI_ATTACHMENT`;
DROP TABLE IF EXISTS `ACT_HI_COMMENT`;
DROP TABLE IF EXISTS `ACT_HI_IDENTITYLINK`;
DROP TABLE IF EXISTS `ACT_HI_VARINST`;
DROP TABLE IF EXISTS `ACT_HI_TASKINST`;
DROP TABLE IF EXISTS `ACT_HI_ACTINST`;
DROP TABLE IF EXISTS `ACT_HI_PROCINST`;

-- ============================================
-- 2. 删除运行时表 (ACT_RU_*)
-- ============================================
DROP TABLE IF EXISTS `ACT_RU_DEADLETTER_JOB`;
DROP TABLE IF EXISTS `ACT_RU_SUSPENDED_JOB`;
DROP TABLE IF EXISTS `ACT_RU_TIMER_JOB`;
DROP TABLE IF EXISTS `ACT_RU_JOB`;
DROP TABLE IF EXISTS `ACT_RU_EVENT_SUBSCR`;
DROP TABLE IF EXISTS `ACT_RU_IDENTITYLINK`;
DROP TABLE IF EXISTS `ACT_RU_VARIABLE`;
DROP TABLE IF EXISTS `ACT_RU_TASK`;
DROP TABLE IF EXISTS `ACT_RU_EXECUTION`;

-- ============================================
-- 3. 删除流程定义表 (ACT_RE_*)
-- ============================================
DROP TABLE IF EXISTS `ACT_RE_MODEL`;
DROP TABLE IF EXISTS `ACT_RE_PROCDEF`;
DROP TABLE IF EXISTS `ACT_RE_DEPLOYMENT`;

-- ============================================
-- 4. 删除通用表 (ACT_GE_*)
-- ============================================
DROP TABLE IF EXISTS `ACT_GE_BYTEARRAY`;
DROP TABLE IF EXISTS `ACT_GE_PROPERTY`;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- 执行完成提示
-- ============================================
-- SELECT '所有 Flowable 表已删除完成！' AS Message;

/*
 ============================================
  注意事项：
  ============================================
  
  1. 此脚本会删除以下类型的表：
     - ACT_GE_*: 通用表
     - ACT_RE_*: 流程定义表
     - ACT_RU_*: 运行时表
     - ACT_HI_*: 历史表
  
  2. 删除顺序很重要：
     - 先删除有外键依赖的表（如 ACT_HI_*、ACT_RU_*）
     - 最后删除被依赖的表（如 ACT_GE_*、ACT_RE_*）
  
  3. 执行此脚本后：
     - 所有 Flowable 数据将被永久删除
     - 需要重新启动服务让 Flowable 自动创建表
     - 流程定义、流程实例、任务等都需要重新创建
  
  4. 如果只需要解决版本不匹配问题：
     - 可以尝试只更新 ACT_GE_PROPERTY 表中的版本号
     - 但这可能会导致其他问题，建议完整重建
  
 ============================================
  重建步骤：
 ============================================
  
  1. 执行此脚本删除所有 Flowable 表
  2. 确保 Nacos 配置中 flowable.database-schema-update: true
  3. 确保代码中 databaseSchemaUpdate 设置为 "true"
  4. 重新启动 ruoyi-flowable 服务
  5. Flowable 会自动创建所有需要的表
  
 ============================================
*/
