-- ------------------------------------------------------
-- 若依微服务Flowable工作流数据库
-- ------------------------------------------------------

CREATE DATABASE IF NOT EXISTS `ry-flowable` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `ry-flowable`;

-- =====================================================
-- 注意：
-- 1. 本脚本仅包含数据库创建语句
-- 2. Flowable 7.x 的表结构会在服务首次启动时自动创建
-- 3. 请确保 bootstrap.yml 中 flowable.database-schema-update 设置为 true
-- 4. 表结构创建完成后，建议将该值改为 false 以提高启动速度
-- =====================================================

-- ------------------------------------------------------
-- Flowable 7.x 表结构说明（服务启动后自动创建）
-- ------------------------------------------------------

-- =====================================================
-- 1. 通用数据表 (ACT_GE_*)
-- =====================================================
-- ACT_GE_PROPERTY      系统相关属性表
-- ACT_GE_BYTEARRAY     通用的流程定义和流程资源表

-- =====================================================
-- 2. 流程定义存储表 (ACT_RE_*)
-- =====================================================
-- ACT_RE_DEPLOYMENT    部署单元信息表
-- ACT_RE_PROCDEF       已部署的流程定义表
-- ACT_RE_MODEL         模型信息表
-- ACT_PROCDEF_INFO     流程定义信息表

-- =====================================================
-- 3. 运行时流程实例表 (ACT_RU_*)
-- =====================================================
-- ACT_RU_EXECUTION         运行时流程执行实例表
-- ACT_RU_TASK              运行时任务表
-- ACT_RU_VARIABLE          运行时变量表
-- ACT_RU_IDENTITYLINK      运行时用户关系信息表
-- ACT_RU_JOB               运行时作业表
-- ACT_RU_TIMER_JOB         定时作业表
-- ACT_RU_SUSPENDED_JOB     暂停作业表
-- ACT_RU_DEADLETTER_JOB    死信作业表
-- ACT_RU_HISTORY_JOB       历史作业表
-- ACT_RU_EVENT_SUBSCR      运行时事件订阅表

-- =====================================================
-- 4. 历史流程实例表 (ACT_HI_*)
-- =====================================================
-- ACT_HI_PROCINST       历史的流程实例表
-- ACT_HI_ACTINST        历史的活动实例表
-- ACT_HI_TASKINST       历史的任务实例表
-- ACT_HI_VARINST        历史的流程运行中的变量信息表
-- ACT_HI_DETAIL         历史的流程运行中的细节信息表
-- ACT_HI_COMMENT        历史的说明性信息表
-- ACT_HI_ATTACHMENT     历史的流程附件表
-- ACT_HI_IDENTITYLINK   历史的流程运行过程中用户关系表

-- =====================================================
-- 5. 其他表
-- =====================================================
-- ACT_EVT_LOG           事件日志表
-- FLW_* 系列表          Flowable 7.x 新增的基于Liquibase管理的表

-- ------------------------------------------------------
-- 配置提示
-- ------------------------------------------------------
-- 1. 在 Nacos 配置中心创建 ruoyi-flowable-dev.yml 配置文件
-- 2. 添加Flowable独立数据源配置：
--
-- spring:
--   datasource:
--     druid:
--       flowable:
--         url: jdbc:mysql://localhost:3306/ry-flowable?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8
--         username: root
--         password: password
--         driver-class-name: com.mysql.cj.jdbc.Driver
--
-- 3. 首次启动服务时，Flowable会自动创建所有表结构
-- 4. 表结构创建完成后，可将 flowable.database-schema-update 改为 false
-- ------------------------------------------------------
