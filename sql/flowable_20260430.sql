SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Flowable 7.2.0 数据库表初始化脚本
-- 适用于 MySQL 5.7+
-- ----------------------------

-- ============================================================
-- 清理所有旧表（按依赖关系逆序删除）
-- ============================================================

-- 历史表
DROP TABLE IF EXISTS act_hi_attachment;
DROP TABLE IF EXISTS act_hi_comment;
DROP TABLE IF EXISTS act_hi_identitylink;
DROP TABLE IF EXISTS act_hi_detail;
DROP TABLE IF EXISTS act_hi_varinst;
DROP TABLE IF EXISTS act_hi_taskinst;
DROP TABLE IF EXISTS act_hi_actinst;
DROP TABLE IF EXISTS act_hi_procinst;

-- 运行时表
DROP TABLE IF EXISTS act_ru_identitylink;
DROP TABLE IF EXISTS act_ru_deadletter_job;
DROP TABLE IF EXISTS act_ru_suspended_job;
DROP TABLE IF EXISTS act_ru_timer_job;
DROP TABLE IF EXISTS act_ru_job;
DROP TABLE IF EXISTS act_ru_event_subscr;
DROP TABLE IF EXISTS act_ru_variable;
DROP TABLE IF EXISTS act_ru_task;
DROP TABLE IF EXISTS act_ru_execution;

-- 流程定义存储表
DROP TABLE IF EXISTS act_re_model;
DROP TABLE IF EXISTS act_re_procdef;
DROP TABLE IF EXISTS act_re_deployment;

-- 通用表
DROP TABLE IF EXISTS act_ge_bytearray;
DROP TABLE IF EXISTS act_ge_property;

-- ============================================================
-- 1. 通用数据表 (ACT_GE_*)
-- ============================================================

-- ----------------------------
-- 通用属性表
-- ----------------------------
CREATE TABLE act_ge_property (
  NAME_          VARCHAR(64)      NOT NULL,
  VALUE_         VARCHAR(300)     NULL,
  REV_           INT              NULL,
  PRIMARY KEY (NAME_)
) ENGINE=INNODB COMMENT = '通用属性表';

-- ----------------------------
-- 通用资源表
-- ----------------------------
CREATE TABLE act_ge_bytearray (
  ID_            VARCHAR(64)      NOT NULL,
  REV_           INT              NULL,
  NAME_          VARCHAR(255)     NULL,
  DEPLOYMENT_ID_ VARCHAR(64)      NULL,
  BYTES_         LONGBLOB         NULL,
  GENERATED_     TINYINT          NULL,
  PRIMARY KEY (ID_)
) ENGINE=INNODB COMMENT = '通用资源表';

-- ============================================================
-- 2. 流程定义存储表 (ACT_RE_*)
-- ============================================================

-- ----------------------------
-- 流程部署表
-- ----------------------------
CREATE TABLE act_re_deployment (
  ID_                     VARCHAR(64)      NOT NULL,
  NAME_                   VARCHAR(255)     NULL,
  CATEGORY_               VARCHAR(255)     NULL,
  KEY_                    VARCHAR(255)     NULL,
  TENANT_ID_              VARCHAR(255)     DEFAULT '',
  DEPLOY_TIME_            DATETIME(3)      NULL,
  DERIVED_FROM_           VARCHAR(64)      NULL,
  DERIVED_FROM_ROOT_      VARCHAR(64)      NULL,
  PARENT_DEPLOYMENT_ID_   VARCHAR(64)      NULL,
  ENGINE_VERSION_         VARCHAR(255)     NULL,
  PRIMARY KEY (ID_)
) ENGINE=INNODB COMMENT = '流程部署表';

-- ----------------------------
-- 流程定义表
-- ----------------------------
CREATE TABLE act_re_procdef (
  ID_                     VARCHAR(64)      NOT NULL,
  REV_                    INT              NULL,
  CATEGORY_               VARCHAR(255)     NULL,
  NAME_                   VARCHAR(255)     NULL,
  KEY_                    VARCHAR(255)     NOT NULL,
  VERSION_                INT              NOT NULL,
  DEPLOYMENT_ID_          VARCHAR(64)      NULL,
  RESOURCE_NAME_          VARCHAR(4000)   NULL,
  DGRM_RESOURCE_NAME_     VARCHAR(4000)   NULL,
  DESCRIPTION_            VARCHAR(4000)   NULL,
  HAS_START_FORM_KEY_     TINYINT          NULL,
  HAS_GRAPHICAL_NOTATION_ TINYINT          NULL,
  SUSPENSION_STATE_       INT              NULL,
  TENANT_ID_              VARCHAR(255)     DEFAULT '',
  ENGINE_VERSION_         VARCHAR(255)     NULL,
  DERIVED_FROM_           VARCHAR(64)      NULL,
  DERIVED_FROM_ROOT_      VARCHAR(64)      NULL,
  DERIVED_VERSION_        INT              DEFAULT 0,
  PRIMARY KEY (ID_),
  UNIQUE KEY ACT_UNIQ_PROCDEF (KEY_, VERSION_, TENANT_ID_, DERIVED_VERSION_)
) ENGINE=INNODB COMMENT = '流程定义表';

-- ----------------------------
-- 流程模型表
-- ----------------------------
CREATE TABLE act_re_model (
  ID_                          VARCHAR(64)      NOT NULL,
  REV_                         INT              NULL,
  NAME_                        VARCHAR(255)     NULL,
  KEY_                         VARCHAR(255)     NULL,
  CATEGORY_                    VARCHAR(255)     NULL,
  CREATE_TIME_                 DATETIME(3)      NULL,
  LAST_UPDATE_TIME_            DATETIME(3)      NULL,
  VERSION_                     INT              NULL,
  META_INFO_                   VARCHAR(4000)   NULL,
  DEPLOYMENT_ID_               VARCHAR(64)      NULL,
  EDITOR_SOURCE_VALUE_ID_      VARCHAR(64)      NULL,
  EDITOR_SOURCE_EXTRA_VALUE_ID_ VARCHAR(64)     NULL,
  TENANT_ID_                   VARCHAR(255)     DEFAULT '',
  PRIMARY KEY (ID_)
) ENGINE=INNODB COMMENT = '流程模型表';

-- ============================================================
-- 3. 运行时流程表 (ACT_RU_*)
-- ============================================================

-- ----------------------------
-- 运行时流程实例表
-- ----------------------------
CREATE TABLE act_ru_execution (
  ID_                    VARCHAR(64)      NOT NULL,
  REV_                   INT              NULL,
  PROC_INST_ID_          VARCHAR(64)      NULL,
  BUSINESS_KEY_          VARCHAR(255)     NULL,
  PARENT_ID_             VARCHAR(64)      NULL,
  PROC_DEF_ID_           VARCHAR(64)      NULL,
  SUPER_EXEC_            VARCHAR(64)      NULL,
  ROOT_PROC_INST_ID_     VARCHAR(64)      NULL,
  ACT_ID_                VARCHAR(255)     NULL,
  IS_ACTIVE_             TINYINT          NULL,
  IS_CONCURRENT_         TINYINT          NULL,
  IS_SCOPE_              TINYINT          NULL,
  IS_EVENT_SCOPE_        TINYINT          NULL,
  IS_MI_ROOT_            TINYINT          NULL,
  SUSPENSION_STATE_      INT              NULL,
  CACHED_ENT_STATE_      INT              NULL,
  TENANT_ID_             VARCHAR(255)     DEFAULT '',
  NAME_                  VARCHAR(255)     NULL,
  START_TIME_            DATETIME(3)      NULL,
  START_USER_ID_         VARCHAR(255)     NULL,
  LOCK_TIME_             DATETIME(3)      NULL,
  LOCK_OWNER_            VARCHAR(255)     NULL,
  IS_COUNT_ENABLED_      TINYINT          NULL,
  EVT_SUBSCR_COUNT_      INT              NULL,
  TASK_COUNT_            INT              NULL,
  JOB_COUNT_             INT              NULL,
  TIMER_JOB_COUNT_       INT              NULL,
  SUSP_JOB_COUNT_        INT              NULL,
  DEADLETTER_JOB_COUNT_  INT              NULL,
  VAR_COUNT_             INT              NULL,
  ID_LINK_COUNT_         INT              NULL,
  PRIMARY KEY (ID_)
) ENGINE=INNODB COMMENT = '运行时流程实例表';

-- ----------------------------
-- 运行时任务表
-- ----------------------------
CREATE TABLE act_ru_task (
  ID_                   VARCHAR(64)      NOT NULL,
  REV_                  INT              NULL,
  EXECUTION_ID_         VARCHAR(64)      NULL,
  PROC_INST_ID_         VARCHAR(64)      NULL,
  PROC_DEF_ID_          VARCHAR(64)      NULL,
  TASK_DEF_ID_          VARCHAR(64)      NULL,
  SCOPE_ID_             VARCHAR(255)     NULL,
  SUB_SCOPE_ID_         VARCHAR(255)     NULL,
  SCOPE_TYPE_           VARCHAR(255)     NULL,
  SCOPE_DEFINITION_ID_  VARCHAR(255)     NULL,
  NAME_                 VARCHAR(255)     NULL,
  PARENT_TASK_ID_       VARCHAR(64)      NULL,
  DESCRIPTION_          VARCHAR(4000)   NULL,
  TASK_DEF_KEY_         VARCHAR(255)     NULL,
  OWNER_                VARCHAR(255)     NULL,
  ASSIGNEE_             VARCHAR(255)     NULL,
  DELEGATION_           VARCHAR(64)      NULL,
  PRIORITY_             INT              NULL,
  CREATE_TIME_          DATETIME(3)      NULL,
  DUE_DATE_             DATETIME(3)      NULL,
  CATEGORY_             VARCHAR(255)     NULL,
  SUSPENSION_STATE_     INT              NULL,
  TENANT_ID_            VARCHAR(255)     DEFAULT '',
  FORM_KEY_             VARCHAR(255)     NULL,
  CLAIM_TIME_           DATETIME(3)      NULL,
  IS_COUNT_ENABLED_     TINYINT          NULL,
  VAR_COUNT_            INT              NULL,
  ID_LINK_COUNT_        INT              NULL,
  SUB_TASK_COUNT_       INT              NULL,
  PRIMARY KEY (ID_)
) ENGINE=INNODB COMMENT = '运行时任务表';

-- ----------------------------
-- 运行时变量表
-- ----------------------------
CREATE TABLE act_ru_variable (
  ID_              VARCHAR(64)      NOT NULL,
  REV_             INT              NULL,
  TYPE_            VARCHAR(255)     NOT NULL,
  NAME_            VARCHAR(255)     NOT NULL,
  EXECUTION_ID_    VARCHAR(64)      NULL,
  PROC_INST_ID_    VARCHAR(64)      NULL,
  TASK_ID_         VARCHAR(64)      NULL,
  SCOPE_ID_        VARCHAR(255)     NULL,
  SUB_SCOPE_ID_    VARCHAR(255)     NULL,
  SCOPE_TYPE_      VARCHAR(255)     NULL,
  BYTEARRAY_ID_    VARCHAR(64)      NULL,
  DOUBLE_          DOUBLE           NULL,
  LONG_            BIGINT           NULL,
  TEXT_            VARCHAR(4000)   NULL,
  TEXT2_           VARCHAR(4000)   NULL,
  PRIMARY KEY (ID_)
) ENGINE=INNODB COMMENT = '运行时变量表';

-- ----------------------------
-- 运行时事件订阅表
-- ----------------------------
CREATE TABLE act_ru_event_subscr (
  ID_                    VARCHAR(64)      NOT NULL,
  REV_                   INT              NULL,
  EVENT_TYPE_            VARCHAR(255)     NOT NULL,
  EVENT_NAME_            VARCHAR(255)     NULL,
  EXECUTION_ID_          VARCHAR(64)      NULL,
  PROC_INST_ID_          VARCHAR(64)      NULL,
  ACTIVITY_ID_           VARCHAR(255)     NULL,
  CONFIGURATION_         VARCHAR(255)     NULL,
  CREATED_               DATETIME(3)      NOT NULL,
  PROC_DEF_ID_           VARCHAR(64)      NULL,
  TENANT_ID_             VARCHAR(255)     DEFAULT '',
  SCOPE_ID_              VARCHAR(255)     NULL,
  SUB_SCOPE_ID_          VARCHAR(255)     NULL,
  SCOPE_TYPE_            VARCHAR(255)     NULL,
  SCOPE_DEFINITION_ID_   VARCHAR(255)     NULL,
  PRIMARY KEY (ID_)
) ENGINE=INNODB COMMENT = '运行时事件订阅表';

-- ----------------------------
-- 运行时作业表
-- ----------------------------
CREATE TABLE act_ru_job (
  ID_                    VARCHAR(64)      NOT NULL,
  REV_                   INT              NULL,
  TYPE_                  VARCHAR(255)     NOT NULL,
  LOCK_EXP_TIME_         DATETIME(3)      NULL,
  LOCK_OWNER_            VARCHAR(255)     NULL,
  EXCLUSIVE_             TINYINT          NULL,
  EXECUTION_ID_          VARCHAR(64)      NULL,
  PROCESS_INSTANCE_ID_   VARCHAR(64)      NULL,
  PROC_DEF_ID_           VARCHAR(64)      NULL,
  SCOPE_ID_              VARCHAR(255)     NULL,
  SUB_SCOPE_ID_          VARCHAR(255)     NULL,
  SCOPE_TYPE_            VARCHAR(255)     NULL,
  ELEMENT_ID_            VARCHAR(255)     NULL,
  ELEMENT_NAME_          VARCHAR(255)     NULL,
  SCOPE_DEFINITION_ID_   VARCHAR(255)     NULL,
  RETRIES_               INT              NULL,
  EXCEPTION_STACK_ID_    VARCHAR(64)      NULL,
  EXCEPTION_MSG_         VARCHAR(4000)   NULL,
  DUEDATE_               DATETIME(3)      NULL,
  REPEAT_                VARCHAR(255)     NULL,
  HANDLER_TYPE_          VARCHAR(255)     NULL,
  HANDLER_CFG_           VARCHAR(4000)   NULL,
  CUSTOM_VALUES_ID_      VARCHAR(64)      NULL,
  CREATE_TIME_           DATETIME(3)      NULL,
  TENANT_ID_             VARCHAR(255)     DEFAULT '',
  PRIMARY KEY (ID_)
) ENGINE=INNODB COMMENT = '运行时作业表';

-- ----------------------------
-- 运行时定时作业表
-- ----------------------------
CREATE TABLE act_ru_timer_job (
  ID_                    VARCHAR(64)      NOT NULL,
  REV_                   INT              NULL,
  TYPE_                  VARCHAR(255)     NOT NULL,
  LOCK_EXP_TIME_         DATETIME(3)      NULL,
  LOCK_OWNER_            VARCHAR(255)     NULL,
  EXCLUSIVE_             TINYINT          NULL,
  EXECUTION_ID_          VARCHAR(64)      NULL,
  PROCESS_INSTANCE_ID_   VARCHAR(64)      NULL,
  PROC_DEF_ID_           VARCHAR(64)      NULL,
  SCOPE_ID_              VARCHAR(255)     NULL,
  SUB_SCOPE_ID_          VARCHAR(255)     NULL,
  SCOPE_TYPE_            VARCHAR(255)     NULL,
  ELEMENT_ID_            VARCHAR(255)     NULL,
  ELEMENT_NAME_          VARCHAR(255)     NULL,
  SCOPE_DEFINITION_ID_   VARCHAR(255)     NULL,
  RETRIES_               INT              NULL,
  EXCEPTION_STACK_ID_    VARCHAR(64)      NULL,
  EXCEPTION_MSG_         VARCHAR(4000)   NULL,
  DUEDATE_               DATETIME(3)      NULL,
  REPEAT_                VARCHAR(255)     NULL,
  HANDLER_TYPE_          VARCHAR(255)     NULL,
  HANDLER_CFG_           VARCHAR(4000)   NULL,
  CUSTOM_VALUES_ID_      VARCHAR(64)      NULL,
  CREATE_TIME_           DATETIME(3)      NULL,
  TENANT_ID_             VARCHAR(255)     DEFAULT '',
  PRIMARY KEY (ID_)
) ENGINE=INNODB COMMENT = '运行时定时作业表';

-- ----------------------------
-- 运行时挂起作业表
-- ----------------------------
CREATE TABLE act_ru_suspended_job (
  ID_                    VARCHAR(64)      NOT NULL,
  REV_                   INT              NULL,
  TYPE_                  VARCHAR(255)     NOT NULL,
  LOCK_EXP_TIME_         DATETIME(3)      NULL,
  LOCK_OWNER_            VARCHAR(255)     NULL,
  EXCLUSIVE_             TINYINT          NULL,
  EXECUTION_ID_          VARCHAR(64)      NULL,
  PROCESS_INSTANCE_ID_   VARCHAR(64)      NULL,
  PROC_DEF_ID_           VARCHAR(64)      NULL,
  SCOPE_ID_              VARCHAR(255)     NULL,
  SUB_SCOPE_ID_          VARCHAR(255)     NULL,
  SCOPE_TYPE_            VARCHAR(255)     NULL,
  ELEMENT_ID_            VARCHAR(255)     NULL,
  ELEMENT_NAME_          VARCHAR(255)     NULL,
  SCOPE_DEFINITION_ID_   VARCHAR(255)     NULL,
  RETRIES_               INT              NULL,
  EXCEPTION_STACK_ID_    VARCHAR(64)      NULL,
  EXCEPTION_MSG_         VARCHAR(4000)   NULL,
  DUEDATE_               DATETIME(3)      NULL,
  REPEAT_                VARCHAR(255)     NULL,
  HANDLER_TYPE_          VARCHAR(255)     NULL,
  HANDLER_CFG_           VARCHAR(4000)   NULL,
  CUSTOM_VALUES_ID_      VARCHAR(64)      NULL,
  CREATE_TIME_           DATETIME(3)      NULL,
  TENANT_ID_             VARCHAR(255)     DEFAULT '',
  PRIMARY KEY (ID_)
) ENGINE=INNODB COMMENT = '运行时挂起作业表';

-- ----------------------------
-- 运行时死信作业表
-- ----------------------------
CREATE TABLE act_ru_deadletter_job (
  ID_                    VARCHAR(64)      NOT NULL,
  REV_                   INT              NULL,
  TYPE_                  VARCHAR(255)     NOT NULL,
  LOCK_EXP_TIME_         DATETIME(3)      NULL,
  LOCK_OWNER_            VARCHAR(255)     NULL,
  EXCLUSIVE_             TINYINT          NULL,
  EXECUTION_ID_          VARCHAR(64)      NULL,
  PROCESS_INSTANCE_ID_   VARCHAR(64)      NULL,
  PROC_DEF_ID_           VARCHAR(64)      NULL,
  SCOPE_ID_              VARCHAR(255)     NULL,
  SUB_SCOPE_ID_          VARCHAR(255)     NULL,
  SCOPE_TYPE_            VARCHAR(255)     NULL,
  ELEMENT_ID_            VARCHAR(255)     NULL,
  ELEMENT_NAME_          VARCHAR(255)     NULL,
  SCOPE_DEFINITION_ID_   VARCHAR(255)     NULL,
  RETRIES_               INT              NULL,
  EXCEPTION_STACK_ID_    VARCHAR(64)      NULL,
  EXCEPTION_MSG_         VARCHAR(4000)   NULL,
  DUEDATE_               DATETIME(3)      NULL,
  REPEAT_                VARCHAR(255)     NULL,
  HANDLER_TYPE_          VARCHAR(255)     NULL,
  HANDLER_CFG_           VARCHAR(4000)   NULL,
  CUSTOM_VALUES_ID_      VARCHAR(64)      NULL,
  CREATE_TIME_           DATETIME(3)      NULL,
  TENANT_ID_             VARCHAR(255)     DEFAULT '',
  PRIMARY KEY (ID_)
) ENGINE=INNODB COMMENT = '运行时死信作业表';

-- ----------------------------
-- 运行时身份链接表
-- ----------------------------
CREATE TABLE act_ru_identitylink (
  ID_                    VARCHAR(64)      NOT NULL,
  REV_                   INT              NULL,
  GROUP_ID_              VARCHAR(255)     NULL,
  TYPE_                  VARCHAR(255)     NULL,
  USER_ID_               VARCHAR(255)     NULL,
  TASK_ID_               VARCHAR(64)      NULL,
  PROC_INST_ID_          VARCHAR(64)      NULL,
  PROC_DEF_ID_           VARCHAR(64)      NULL,
  SCOPE_ID_              VARCHAR(255)     NULL,
  SUB_SCOPE_ID_          VARCHAR(255)     NULL,
  SCOPE_TYPE_            VARCHAR(255)     NULL,
  SCOPE_DEFINITION_ID_   VARCHAR(255)     NULL,
  PRIMARY KEY (ID_)
) ENGINE=INNODB COMMENT = '运行时身份链接表';

-- ============================================================
-- 4. 历史流程表 (ACT_HI_*)
-- ============================================================

-- ----------------------------
-- 历史流程实例表
-- ----------------------------
CREATE TABLE act_hi_procinst (
  ID_                         VARCHAR(64)      NOT NULL,
  REV_                        INT              NULL,
  PROC_INST_ID_               VARCHAR(64)      NOT NULL,
  BUSINESS_KEY_               VARCHAR(255)     NULL,
  PROC_DEF_ID_                VARCHAR(64)      NOT NULL,
  START_TIME_                 DATETIME(3)      NOT NULL,
  END_TIME_                   DATETIME(3)      NULL,
  DURATION_                   BIGINT           NULL,
  START_USER_ID_              VARCHAR(255)     NULL,
  START_ACT_ID_               VARCHAR(255)     NULL,
  END_ACT_ID_                 VARCHAR(255)     NULL,
  SUPER_PROCESS_INSTANCE_ID_  VARCHAR(64)      NULL,
  DELETE_REASON_              VARCHAR(4000)   NULL,
  TENANT_ID_                  VARCHAR(255)     DEFAULT '',
  NAME_                       VARCHAR(255)     NULL,
  CALLBACK_ID_                VARCHAR(255)     NULL,
  CALLBACK_TYPE_              VARCHAR(255)     NULL,
  REFERENCE_ID_               VARCHAR(255)     NULL,
  REFERENCE_TYPE_             VARCHAR(255)     NULL,
  PROPAGATED_STAGE_INST_ID_   VARCHAR(255)     NULL,
  BUSINESS_STATUS_            VARCHAR(255)     NULL,
  PRIMARY KEY (ID_),
  UNIQUE KEY ACT_UNIQ_HI_PROC_INST (PROC_INST_ID_)
) ENGINE=INNODB COMMENT = '历史流程实例表';

-- ----------------------------
-- 历史活动实例表
-- ----------------------------
CREATE TABLE act_hi_actinst (
  ID_                VARCHAR(64)      NOT NULL,
  REV_               INT              NULL,
  PROC_DEF_ID_       VARCHAR(64)      NOT NULL,
  PROC_INST_ID_      VARCHAR(64)      NOT NULL,
  EXECUTION_ID_      VARCHAR(64)      NOT NULL,
  ACT_ID_            VARCHAR(255)     NOT NULL,
  TASK_ID_           VARCHAR(64)      NULL,
  CALL_PROC_INST_ID_ VARCHAR(64)      NULL,
  ACT_NAME_          VARCHAR(255)     NULL,
  ACT_TYPE_          VARCHAR(255)     NOT NULL,
  ASSIGNEE_          VARCHAR(255)     NULL,
  START_TIME_        DATETIME(3)      NOT NULL,
  END_TIME_          DATETIME(3)      NULL,
  DURATION_          BIGINT           NULL,
  DELETE_REASON_     VARCHAR(4000)   NULL,
  TENANT_ID_         VARCHAR(255)     DEFAULT '',
  PRIMARY KEY (ID_)
) ENGINE=INNODB COMMENT = '历史活动实例表';

-- ----------------------------
-- 历史任务实例表
-- ----------------------------
CREATE TABLE act_hi_taskinst (
  ID_                     VARCHAR(64)      NOT NULL,
  REV_                    INT              NULL,
  PROC_DEF_ID_            VARCHAR(64)      NULL,
  TASK_DEF_ID_            VARCHAR(64)      NULL,
  TASK_DEF_KEY_           VARCHAR(255)     NULL,
  PROC_INST_ID_           VARCHAR(64)      NULL,
  EXECUTION_ID_           VARCHAR(64)      NULL,
  SCOPE_ID_               VARCHAR(255)     NULL,
  SUB_SCOPE_ID_           VARCHAR(255)     NULL,
  SCOPE_TYPE_             VARCHAR(255)     NULL,
  SCOPE_DEFINITION_ID_    VARCHAR(255)     NULL,
  NAME_                   VARCHAR(255)     NULL,
  PARENT_TASK_ID_         VARCHAR(64)      NULL,
  DESCRIPTION_            VARCHAR(4000)   NULL,
  OWNER_                  VARCHAR(255)     NULL,
  ASSIGNEE_               VARCHAR(255)     NULL,
  DELEGATION_             VARCHAR(64)      NULL,
  PRIORITY_               INT              NULL,
  CREATE_TIME_            DATETIME(3)      NOT NULL,
  CLAIM_TIME_             DATETIME(3)      NULL,
  END_TIME_               DATETIME(3)      NULL,
  DURATION_               BIGINT           NULL,
  DELETE_REASON_          VARCHAR(4000)   NULL,
  FORM_KEY_               VARCHAR(255)     NULL,
  CATEGORY_               VARCHAR(255)     NULL,
  TENANT_ID_              VARCHAR(255)     DEFAULT '',
  LAST_UPDATED_TIME_      DATETIME(3)      NULL,
  QUERY_COUNT_            INT              DEFAULT 0,
  AD_HOC_                 TINYINT          NULL,
  AD_HOC_ORDER_           INT              NULL,
  AD_HOC_REMOVED_         TINYINT          NULL,
  PRIMARY KEY (ID_)
) ENGINE=INNODB COMMENT = '历史任务实例表';

-- ----------------------------
-- 历史变量实例表
-- ----------------------------
CREATE TABLE act_hi_varinst (
  ID_                 VARCHAR(64)      NOT NULL,
  REV_                INT              NULL,
  PROC_INST_ID_       VARCHAR(64)      NULL,
  EXECUTION_ID_       VARCHAR(64)      NULL,
  TASK_ID_            VARCHAR(64)      NULL,
  SCOPE_ID_           VARCHAR(255)     NULL,
  SUB_SCOPE_ID_       VARCHAR(255)     NULL,
  SCOPE_TYPE_         VARCHAR(255)     NULL,
  NAME_               VARCHAR(255)     NOT NULL,
  VAR_TYPE_           VARCHAR(100)     NULL,
  BYTEARRAY_ID_       VARCHAR(64)      NULL,
  DOUBLE_             DOUBLE           NULL,
  LONG_               BIGINT           NULL,
  TEXT_               VARCHAR(4000)   NULL,
  TEXT2_              VARCHAR(4000)   NULL,
  CREATE_TIME_        DATETIME(3)      NULL,
  LAST_UPDATED_TIME_  DATETIME(3)      NULL,
  PRIMARY KEY (ID_)
) ENGINE=INNODB COMMENT = '历史变量实例表';

-- ----------------------------
-- 历史详情表
-- ----------------------------
CREATE TABLE act_hi_detail (
  ID_            VARCHAR(64)      NOT NULL,
  REV_           INT              NULL,
  TYPE_          VARCHAR(255)     NOT NULL,
  PROC_INST_ID_  VARCHAR(64)      NULL,
  EXECUTION_ID_  VARCHAR(64)      NULL,
  TASK_ID_       VARCHAR(64)      NULL,
  ACT_INST_ID_   VARCHAR(64)      NULL,
  NAME_          VARCHAR(255)     NULL,
  VAR_TYPE_      VARCHAR(255)     NULL,
  REV_           INT              NULL,
  TIME_          DATETIME(3)      NOT NULL,
  BYTEARRAY_ID_  VARCHAR(64)      NULL,
  DOUBLE_        DOUBLE           NULL,
  LONG_          BIGINT           NULL,
  TEXT_          VARCHAR(4000)   NULL,
  TEXT2_         VARCHAR(4000)   NULL,
  PRIMARY KEY (ID_)
) ENGINE=INNODB COMMENT = '历史详情表';

-- ----------------------------
-- 历史身份链接表
-- ----------------------------
CREATE TABLE act_hi_identitylink (
  ID_                    VARCHAR(64)      NOT NULL,
  GROUP_ID_              VARCHAR(255)     NULL,
  TYPE_                  VARCHAR(255)     NULL,
  USER_ID_               VARCHAR(255)     NULL,
  TASK_ID_               VARCHAR(64)      NULL,
  PROC_INST_ID_          VARCHAR(64)      NULL,
  SCOPE_ID_              VARCHAR(255)     NULL,
  SUB_SCOPE_ID_          VARCHAR(255)     NULL,
  SCOPE_TYPE_            VARCHAR(255)     NULL,
  SCOPE_DEFINITION_ID_   VARCHAR(255)     NULL,
  PRIMARY KEY (ID_)
) ENGINE=INNODB COMMENT = '历史身份链接表';

-- ----------------------------
-- 历史评论表
-- ----------------------------
CREATE TABLE act_hi_comment (
  ID_            VARCHAR(64)      NOT NULL,
  REV_           INT              NULL,
  TYPE_          VARCHAR(255)     NULL,
  TIME_          DATETIME(3)      NOT NULL,
  USER_ID_       VARCHAR(255)     NULL,
  TASK_ID_       VARCHAR(64)      NULL,
  PROC_INST_ID_  VARCHAR(64)      NULL,
  ACTION_        VARCHAR(255)     NULL,
  MESSAGE_       VARCHAR(4000)   NULL,
  FULL_MSG_      LONGBLOB         NULL,
  PRIMARY KEY (ID_)
) ENGINE=INNODB COMMENT = '历史评论表';

-- ----------------------------
-- 历史附件表
-- ----------------------------
CREATE TABLE act_hi_attachment (
  ID_            VARCHAR(64)      NOT NULL,
  REV_           INT              NULL,
  USER_ID_       VARCHAR(255)     NULL,
  NAME_          VARCHAR(255)     NULL,
  DESCRIPTION_   VARCHAR(4000)   NULL,
  TYPE_          VARCHAR(255)     NULL,
  TASK_ID_       VARCHAR(64)      NULL,
  PROC_INST_ID_  VARCHAR(64)      NULL,
  URL_           VARCHAR(4000)   NULL,
  CONTENT_ID_    VARCHAR(64)      NULL,
  TIME_          DATETIME(3)      NULL,
  PRIMARY KEY (ID_)
) ENGINE=INNODB COMMENT = '历史附件表';

-- ============================================================
-- 5. 初始化属性数据
-- ============================================================

-- 插入Flowable引擎版本信息
INSERT INTO act_ge_property (NAME_, VALUE_, REV_) VALUES ('schema.version', '7.2.0.0', 1);
INSERT INTO act_ge_property (NAME_, VALUE_, REV_) VALUES ('schema.history', 'create(7.2.0.0)', 1);
INSERT INTO act_ge_property (NAME_, VALUE_, REV_) VALUES ('next.dbid', '1', 1);

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- 说明
-- ============================================================
-- 此脚本为Flowable 7.2.0的MySQL数据库表初始化脚本
-- 包含以下类型的表：
-- 1. ACT_GE_*: 通用数据表 (2张)
-- 2. ACT_RE_*: 流程定义存储表 (3张)
-- 3. ACT_RU_*: 运行时流程实例表 (9张)
-- 4. ACT_HI_*: 历史流程实例表 (8张)
-- 
-- 注意：
-- - 此脚本适用于MySQL 5.7及以上版本
-- - 已在脚本开头禁用外键检查，确保表可以按任意顺序创建
-- - 已按依赖关系逆序删除所有旧表，确保清理干净
-- - 所有表都不包含外键约束，避免创建顺序问题
-- - Flowable引擎在运行时会自动管理数据关系
-- - 如需要IDM（身份管理）模块，请单独执行相关脚本