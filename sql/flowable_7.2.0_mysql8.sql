-- ============================================================
-- Flowable 7.2.0 数据库表初始化脚本
-- 适用于 MySQL 8.0+
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;

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
DROP TABLE IF EXISTS act_ru_entitylink;
DROP TABLE IF EXISTS act_ru_deadletter_job;
DROP TABLE IF EXISTS act_ru_suspended_job;
DROP TABLE IF EXISTS act_ru_timer_job;
DROP TABLE IF EXISTS act_ru_history_job;
DROP TABLE IF EXISTS act_ru_job;
DROP TABLE IF EXISTS act_ru_event_subscr;
DROP TABLE IF EXISTS act_ru_variable;
DROP TABLE IF EXISTS act_ru_task;
DROP TABLE IF EXISTS act_ru_actinst;
DROP TABLE IF EXISTS act_ru_execution;

-- 流程定义存储表
DROP TABLE IF EXISTS act_re_model;
DROP TABLE IF EXISTS act_re_procdef;
DROP TABLE IF EXISTS act_re_deployment;

-- 通用表
DROP TABLE IF EXISTS act_ge_bytearray;
DROP TABLE IF EXISTS act_ge_property;
DROP TABLE IF EXISTS act_ge_schema_log;

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
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='通用属性表';

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
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='通用资源表';

-- ----------------------------
-- Schema 日志表
-- ----------------------------
CREATE TABLE act_ge_schema_log (
  ID_            VARCHAR(64)      NOT NULL,
  TIMESTAMP_     DATETIME(3)      NULL,
  VERSION_       VARCHAR(255)     NULL,
  PRIMARY KEY (ID_)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='Schema日志表';

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
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='流程部署表';

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
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='流程定义表';

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
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='流程模型表';

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
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='运行时流程实例表';

-- ----------------------------
-- 运行时活动实例表
-- ----------------------------
CREATE TABLE act_ru_actinst (
  ID_                    VARCHAR(64)      NOT NULL,
  REV_                   INT              NULL,
  PROC_DEF_ID_           VARCHAR(64)      NOT NULL,
  PROC_INST_ID_          VARCHAR(64)      NOT NULL,
  EXECUTION_ID_          VARCHAR(64)      NOT NULL,
  ACT_ID_                VARCHAR(255)     NOT NULL,
  TASK_ID_               VARCHAR(64)      NULL,
  CALL_PROC_INST_ID_     VARCHAR(64)      NULL,
  ACT_NAME_              VARCHAR(255)     NULL,
  ACT_TYPE_              VARCHAR(255)     NOT NULL,
  ASSIGNEE_              VARCHAR(255)     NULL,
  START_TIME_            DATETIME(3)      NOT NULL,
  END_TIME_              DATETIME(3)      NULL,
  DURATION_              BIGINT           NULL,
  DELETE_REASON_         VARCHAR(4000)   NULL,
  TENANT_ID_             VARCHAR(255)     DEFAULT '',
  PRIMARY KEY (ID_)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='运行时活动实例表';

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
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='运行时任务表';

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
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='运行时变量表';

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
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='运行时事件订阅表';

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
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='运行时作业表';

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
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='运行时定时作业表';

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
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='运行时挂起作业表';

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
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='运行时死信作业表';

-- ----------------------------
-- 运行时历史作业表
-- ----------------------------
CREATE TABLE act_ru_history_job (
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
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='运行时历史作业表';

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
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='运行时身份链接表';

-- ----------------------------
-- 运行时实体链接表
-- ----------------------------
CREATE TABLE act_ru_entitylink (
  ID_                    VARCHAR(64)      NOT NULL,
  REV_                   INT              NULL,
  CREATE_TIME_           DATETIME(3)      NULL,
  SCOPE_ID_              VARCHAR(255)     NULL,
  SUB_SCOPE_ID_          VARCHAR(255)     NULL,
  SCOPE_TYPE_            VARCHAR(255)     NULL,
  SCOPE_DEFINITION_ID_   VARCHAR(255)     NULL,
  PARENT_ELEMENT_ID_     VARCHAR(255)     NULL,
  ROOT_SCOPE_ID_         VARCHAR(255)     NULL,
  HIERARCHY_TYPE_        VARCHAR(255)     NULL,
  REFERENCE_ID_          VARCHAR(255)     NULL,
  REFERENCE_TYPE_        VARCHAR(255)     NULL,
  REFERENCE_SCOPE_ID_    VARCHAR(255)     NULL,
  REFERENCE_SCOPE_TYPE_  VARCHAR(255)     NULL,
  ROOT_PROC_INST_ID_     VARCHAR(64)      NULL,
  PROC_DEF_ID_           VARCHAR(64)      NULL,
  TENANT_ID_             VARCHAR(255)     DEFAULT '',
  PRIMARY KEY (ID_)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='运行时实体链接表';

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
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='历史流程实例表';

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
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='历史活动实例表';

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
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='历史任务实例表';

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
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='历史变量实例表';

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
  TIME_          DATETIME(3)      NOT NULL,
  BYTEARRAY_ID_  VARCHAR(64)      NULL,
  DOUBLE_        DOUBLE           NULL,
  LONG_          BIGINT           NULL,
  TEXT_          VARCHAR(4000)   NULL,
  TEXT2_         VARCHAR(4000)   NULL,
  PRIMARY KEY (ID_)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='历史详情表';

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
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='历史身份链接表';

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
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='历史评论表';

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
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='历史附件表';

-- ============================================================
-- 5. 创建索引
-- ============================================================

-- 流程定义表索引
CREATE INDEX ACT_IDX_PROCDEF_DEPLOYMENT_ID ON act_re_procdef(DEPLOYMENT_ID_);

-- 部署表索引（无额外索引）

-- 执行实例表索引
CREATE INDEX ACT_IDX_EXEC_BUSKEY ON act_ru_execution(BUSINESS_KEY_);
CREATE INDEX ACT_IDX_EXEC_TENANT_ID ON act_ru_execution(TENANT_ID_);
CREATE INDEX ACT_IDX_EXEC_PARENT ON act_ru_execution(PARENT_ID_);
CREATE INDEX ACT_IDX_EXEC_PROC_INST ON act_ru_execution(PROC_INST_ID_);
CREATE INDEX ACT_IDX_EXEC_SUPER ON act_ru_execution(SUPER_EXEC_);
CREATE INDEX ACT_IDX_EXEC_ROOT ON act_ru_execution(ROOT_PROC_INST_ID_);

-- 活动实例表索引
CREATE INDEX ACT_IDX_RU_ACTI_PROC_INST ON act_ru_actinst(PROC_INST_ID_);
CREATE INDEX ACT_IDX_RU_ACTI_EXEC ON act_ru_actinst(EXECUTION_ID_);
CREATE INDEX ACT_IDX_RU_ACTI_PROC_DEF ON act_ru_actinst(PROC_DEF_ID_);
CREATE INDEX ACT_IDX_RU_ACTI_TASK ON act_ru_actinst(TASK_ID_);
CREATE INDEX ACT_IDX_RU_ACTI_PROC ON act_ru_actinst(PROC_INST_ID_, EXECUTION_ID_);

-- 任务表索引
CREATE INDEX ACT_IDX_TASK_EXEC ON act_ru_task(EXECUTION_ID_);
CREATE INDEX ACT_IDX_TASK_PROC_INST ON act_ru_task(PROC_INST_ID_);
CREATE INDEX ACT_IDX_TASK_PROC_DEF_ID ON act_ru_task(PROC_DEF_ID_);
CREATE INDEX ACT_IDX_TASK_SCOPE ON act_ru_task(SCOPE_ID_);
CREATE INDEX ACT_IDX_TASK_SUB_SCOPE ON act_ru_task(SUB_SCOPE_ID_);
CREATE INDEX ACT_IDX_TASK_SCOPE_TYPE ON act_ru_task(SCOPE_TYPE_);
CREATE INDEX ACT_IDX_TASK_CREATE ON act_ru_task(CREATE_TIME_);
CREATE INDEX ACT_IDX_TASK_ASSIGNEE ON act_ru_task(ASSIGNEE_);
CREATE INDEX ACT_IDX_TASK_OWNER ON act_ru_task(OWNER_);
CREATE INDEX ACT_IDX_TASK_TENANT_ID ON act_ru_task(TENANT_ID_);

-- 变量表索引
CREATE INDEX ACT_IDX_VARIABLE_EXEC ON act_ru_variable(EXECUTION_ID_);
CREATE INDEX ACT_IDX_VARIABLE_PROC_INST ON act_ru_variable(PROC_INST_ID_);
CREATE INDEX ACT_IDX_VARIABLE_TASK ON act_ru_variable(TASK_ID_);
CREATE INDEX ACT_IDX_VARIABLE_SCOPE ON act_ru_variable(SCOPE_ID_);
CREATE INDEX ACT_IDX_VARIABLE_SUB_SCOPE ON act_ru_variable(SUB_SCOPE_ID_);
CREATE INDEX ACT_IDX_VARIABLE_SCOPE_TYPE ON act_ru_variable(SCOPE_TYPE_);
CREATE INDEX ACT_IDX_VARIABLE_BA ON act_ru_variable(BYTEARRAY_ID_);

-- 事件订阅表索引
CREATE INDEX ACT_IDX_EVENT_SUBSCR_EXEC ON act_ru_event_subscr(EXECUTION_ID_);
CREATE INDEX ACT_IDX_EVENT_SUBSCR_PROC_INST ON act_ru_event_subscr(PROC_INST_ID_);
CREATE INDEX ACT_IDX_EVENT_SUBSCR_CONFIG ON act_ru_event_subscr(CONFIGURATION_);
CREATE INDEX ACT_IDX_EVENT_SUBSCR_SCOPE ON act_ru_event_subscr(SCOPE_ID_);
CREATE INDEX ACT_IDX_EVENT_SUBSCR_SUB_SCOPE ON act_ru_event_subscr(SUB_SCOPE_ID_);
CREATE INDEX ACT_IDX_EVENT_SUBSCR_SCOPE_TYPE ON act_ru_event_subscr(SCOPE_TYPE_);

-- 作业表索引
CREATE INDEX ACT_IDX_JOB_EXECUTION_ID ON act_ru_job(EXECUTION_ID_);
CREATE INDEX ACT_IDX_JOB_PROC_INST_ID ON act_ru_job(PROCESS_INSTANCE_ID_);
CREATE INDEX ACT_IDX_JOB_PROC_DEF_ID ON act_ru_job(PROC_DEF_ID_);
CREATE INDEX ACT_IDX_JOB_SCOPE_ID ON act_ru_job(SCOPE_ID_);
CREATE INDEX ACT_IDX_JOB_SUB_SCOPE_ID ON act_ru_job(SUB_SCOPE_ID_);
CREATE INDEX ACT_IDX_JOB_SCOPE_TYPE ON act_ru_job(SCOPE_TYPE_);
CREATE INDEX ACT_IDX_JOB_EXCEPTION_STACK ON act_ru_job(EXCEPTION_STACK_ID_);
CREATE INDEX ACT_IDX_JOB_CUSTOM_VALUES ON act_ru_job(CUSTOM_VALUES_ID_);
CREATE INDEX ACT_IDX_JOB_DUEDATE ON act_ru_job(DUEDATE_);
CREATE INDEX ACT_IDX_JOB_TENANT_ID ON act_ru_job(TENANT_ID_);
CREATE INDEX ACT_IDX_JOB_LOCK_EXP_TIME ON act_ru_job(LOCK_EXP_TIME_);

-- 定时作业表索引
CREATE INDEX ACT_IDX_TIMER_JOB_EXECUTION_ID ON act_ru_timer_job(EXECUTION_ID_);
CREATE INDEX ACT_IDX_TIMER_JOB_PROC_INST_ID ON act_ru_timer_job(PROCESS_INSTANCE_ID_);
CREATE INDEX ACT_IDX_TIMER_JOB_PROC_DEF_ID ON act_ru_timer_job(PROC_DEF_ID_);
CREATE INDEX ACT_IDX_TIMER_JOB_SCOPE_ID ON act_ru_timer_job(SCOPE_ID_);
CREATE INDEX ACT_IDX_TIMER_JOB_SUB_SCOPE_ID ON act_ru_timer_job(SUB_SCOPE_ID_);
CREATE INDEX ACT_IDX_TIMER_JOB_SCOPE_TYPE ON act_ru_timer_job(SCOPE_TYPE_);
CREATE INDEX ACT_IDX_TIMER_JOB_EXCEPTION_STACK ON act_ru_timer_job(EXCEPTION_STACK_ID_);
CREATE INDEX ACT_IDX_TIMER_JOB_CUSTOM_VALUES ON act_ru_timer_job(CUSTOM_VALUES_ID_);
CREATE INDEX ACT_IDX_TIMER_JOB_DUEDATE ON act_ru_timer_job(DUEDATE_);
CREATE INDEX ACT_IDX_TIMER_JOB_TENANT_ID ON act_ru_timer_job(TENANT_ID_);
CREATE INDEX ACT_IDX_TIMER_JOB_LOCK_EXP_TIME ON act_ru_timer_job(LOCK_EXP_TIME_);

-- 挂起作业表索引
CREATE INDEX ACT_IDX_SUSPENDED_JOB_EXECUTION_ID ON act_ru_suspended_job(EXECUTION_ID_);
CREATE INDEX ACT_IDX_SUSPENDED_JOB_PROC_INST_ID ON act_ru_suspended_job(PROCESS_INSTANCE_ID_);
CREATE INDEX ACT_IDX_SUSPENDED_JOB_PROC_DEF_ID ON act_ru_suspended_job(PROC_DEF_ID_);
CREATE INDEX ACT_IDX_SUSPENDED_JOB_SCOPE_ID ON act_ru_suspended_job(SCOPE_ID_);
CREATE INDEX ACT_IDX_SUSPENDED_JOB_SUB_SCOPE_ID ON act_ru_suspended_job(SUB_SCOPE_ID_);
CREATE INDEX ACT_IDX_SUSPENDED_JOB_SCOPE_TYPE ON act_ru_suspended_job(SCOPE_TYPE_);
CREATE INDEX ACT_IDX_SUSPENDED_JOB_EXCEPTION_STACK ON act_ru_suspended_job(EXCEPTION_STACK_ID_);
CREATE INDEX ACT_IDX_SUSPENDED_JOB_CUSTOM_VALUES ON act_ru_suspended_job(CUSTOM_VALUES_ID_);
CREATE INDEX ACT_IDX_SUSPENDED_JOB_DUEDATE ON act_ru_suspended_job(DUEDATE_);
CREATE INDEX ACT_IDX_SUSPENDED_JOB_TENANT_ID ON act_ru_suspended_job(TENANT_ID_);

-- 死信作业表索引
CREATE INDEX ACT_IDX_DEADLETTER_JOB_EXECUTION_ID ON act_ru_deadletter_job(EXECUTION_ID_);
CREATE INDEX ACT_IDX_DEADLETTER_JOB_PROC_INST_ID ON act_ru_deadletter_job(PROCESS_INSTANCE_ID_);
CREATE INDEX ACT_IDX_DEADLETTER_JOB_PROC_DEF_ID ON act_ru_deadletter_job(PROC_DEF_ID_);
CREATE INDEX ACT_IDX_DEADLETTER_JOB_SCOPE_ID ON act_ru_deadletter_job(SCOPE_ID_);
CREATE INDEX ACT_IDX_DEADLETTER_JOB_SUB_SCOPE_ID ON act_ru_deadletter_job(SUB_SCOPE_ID_);
CREATE INDEX ACT_IDX_DEADLETTER_JOB_SCOPE_TYPE ON act_ru_deadletter_job(SCOPE_TYPE_);
CREATE INDEX ACT_IDX_DEADLETTER_JOB_EXCEPTION_STACK ON act_ru_deadletter_job(EXCEPTION_STACK_ID_);
CREATE INDEX ACT_IDX_DEADLETTER_JOB_CUSTOM_VALUES ON act_ru_deadletter_job(CUSTOM_VALUES_ID_);
CREATE INDEX ACT_IDX_DEADLETTER_JOB_DUEDATE ON act_ru_deadletter_job(DUEDATE_);
CREATE INDEX ACT_IDX_DEADLETTER_JOB_TENANT_ID ON act_ru_deadletter_job(TENANT_ID_);

-- 历史作业表索引
CREATE INDEX ACT_IDX_HISTORY_JOB_EXECUTION_ID ON act_ru_history_job(EXECUTION_ID_);
CREATE INDEX ACT_IDX_HISTORY_JOB_PROC_INST_ID ON act_ru_history_job(PROCESS_INSTANCE_ID_);
CREATE INDEX ACT_IDX_HISTORY_JOB_PROC_DEF_ID ON act_ru_history_job(PROC_DEF_ID_);
CREATE INDEX ACT_IDX_HISTORY_JOB_SCOPE_ID ON act_ru_history_job(SCOPE_ID_);
CREATE INDEX ACT_IDX_HISTORY_JOB_SUB_SCOPE_ID ON act_ru_history_job(SUB_SCOPE_ID_);
CREATE INDEX ACT_IDX_HISTORY_JOB_SCOPE_TYPE ON act_ru_history_job(SCOPE_TYPE_);
CREATE INDEX ACT_IDX_HISTORY_JOB_EXCEPTION_STACK ON act_ru_history_job(EXCEPTION_STACK_ID_);
CREATE INDEX ACT_IDX_HISTORY_JOB_CUSTOM_VALUES ON act_ru_history_job(CUSTOM_VALUES_ID_);
CREATE INDEX ACT_IDX_HISTORY_JOB_DUEDATE ON act_ru_history_job(DUEDATE_);
CREATE INDEX ACT_IDX_HISTORY_JOB_TENANT_ID ON act_ru_history_job(TENANT_ID_);

-- 身份链接表索引
CREATE INDEX ACT_IDX_IDENT_LNK_TASK ON act_ru_identitylink(TASK_ID_);
CREATE INDEX ACT_IDX_IDENT_LNK_PROC_INST ON act_ru_identitylink(PROC_INST_ID_);
CREATE INDEX ACT_IDX_IDENT_LNK_USER ON act_ru_identitylink(USER_ID_);
CREATE INDEX ACT_IDX_IDENT_LNK_GROUP ON act_ru_identitylink(GROUP_ID_);
CREATE INDEX ACT_IDX_IDENT_LNK_SCOPE ON act_ru_identitylink(SCOPE_ID_);
CREATE INDEX ACT_IDX_IDENT_LNK_SUB_SCOPE ON act_ru_identitylink(SUB_SCOPE_ID_);
CREATE INDEX ACT_IDX_IDENT_LNK_SCOPE_TYPE ON act_ru_identitylink(SCOPE_TYPE_);
CREATE INDEX ACT_IDX_IDENT_LNK_PROC_DEF ON act_ru_identitylink(PROC_DEF_ID_);

-- 实体链接表索引
CREATE INDEX ACT_IDX_ENT_LNK_SCOPE ON act_ru_entitylink(SCOPE_ID_, SCOPE_TYPE_);
CREATE INDEX ACT_IDX_ENT_LNK_SUB_SCOPE ON act_ru_entitylink(SUB_SCOPE_ID_, SCOPE_TYPE_);
CREATE INDEX ACT_IDX_ENT_LNK_ROOT_SCOPE ON act_ru_entitylink(ROOT_SCOPE_ID_);
CREATE INDEX ACT_IDX_ENT_LNK_REF_SCOPE ON act_ru_entitylink(REFERENCE_SCOPE_ID_, REFERENCE_SCOPE_TYPE_);
CREATE INDEX ACT_IDX_ENT_LNK_ROOT_PROC_INST ON act_ru_entitylink(ROOT_PROC_INST_ID_);

-- 二进制表索引
CREATE INDEX ACT_IDX_BYTEAR_DEPL ON act_ge_bytearray(DEPLOYMENT_ID_);

-- 历史流程实例表索引
CREATE INDEX ACT_IDX_HI_PRO_INST_END ON act_hi_procinst(END_TIME_);
CREATE INDEX ACT_IDX_HI_PRO_I_BUSKEY ON act_hi_procinst(BUSINESS_KEY_);
CREATE INDEX ACT_IDX_HI_PRO_INST_PROC_DEF ON act_hi_procinst(PROC_DEF_ID_);
CREATE INDEX ACT_IDX_HI_PRO_INST_TENANT_ID ON act_hi_procinst(TENANT_ID_);

-- 历史活动实例表索引
CREATE INDEX ACT_IDX_HI_ACT_INST_START ON act_hi_actinst(START_TIME_);
CREATE INDEX ACT_IDX_HI_ACT_INST_END ON act_hi_actinst(END_TIME_);
CREATE INDEX ACT_IDX_HI_ACT_INST_PROCINST ON act_hi_actinst(PROC_INST_ID_, ACT_ID_);
CREATE INDEX ACT_IDX_HI_ACT_INST_EXEC ON act_hi_actinst(EXECUTION_ID_, ACT_ID_);
CREATE INDEX ACT_IDX_HI_ACT_INST_PROC_DEF ON act_hi_actinst(PROC_DEF_ID_);
CREATE INDEX ACT_IDX_HI_ACT_INST_TENANT_ID ON act_hi_actinst(TENANT_ID_);

-- 历史任务实例表索引
CREATE INDEX ACT_IDX_HI_TASK_INST_PROCINST ON act_hi_taskinst(PROC_INST_ID_);
CREATE INDEX ACT_IDX_HI_TASK_INST_PROC_DEF ON act_hi_taskinst(PROC_DEF_ID_);
CREATE INDEX ACT_IDX_HI_TASK_INST_EXEC ON act_hi_taskinst(EXECUTION_ID_);
CREATE INDEX ACT_IDX_HI_TASK_INST_TASK_DEF_KEY ON act_hi_taskinst(TASK_DEF_KEY_);
CREATE INDEX ACT_IDX_HI_TASK_INST_SCOPE ON act_hi_taskinst(SCOPE_ID_);
CREATE INDEX ACT_IDX_HI_TASK_INST_SUB_SCOPE ON act_hi_taskinst(SUB_SCOPE_ID_);
CREATE INDEX ACT_IDX_HI_TASK_INST_SCOPE_TYPE ON act_hi_taskinst(SCOPE_TYPE_);
CREATE INDEX ACT_IDX_HI_TASK_INST_CREATE ON act_hi_taskinst(CREATE_TIME_);
CREATE INDEX ACT_IDX_HI_TASK_INST_END ON act_hi_taskinst(END_TIME_);
CREATE INDEX ACT_IDX_HI_TASK_INST_ASSIGNEE ON act_hi_taskinst(ASSIGNEE_);
CREATE INDEX ACT_IDX_HI_TASK_INST_OWNER ON act_hi_taskinst(OWNER_);
CREATE INDEX ACT_IDX_HI_TASK_INST_TENANT_ID ON act_hi_taskinst(TENANT_ID_);

-- 历史变量实例表索引
CREATE INDEX ACT_IDX_HI_PROCVAR_PROC_INST ON act_hi_varinst(PROC_INST_ID_);
CREATE INDEX ACT_IDX_HI_PROCVAR_EXEC ON act_hi_varinst(EXECUTION_ID_);
CREATE INDEX ACT_IDX_HI_PROCVAR_TASK ON act_hi_varinst(TASK_ID_);
CREATE INDEX ACT_IDX_HI_PROCVAR_SCOPE ON act_hi_varinst(SCOPE_ID_);
CREATE INDEX ACT_IDX_HI_PROCVAR_SUB_SCOPE ON act_hi_varinst(SUB_SCOPE_ID_);
CREATE INDEX ACT_IDX_HI_PROCVAR_SCOPE_TYPE ON act_hi_varinst(SCOPE_TYPE_);
CREATE INDEX ACT_IDX_HI_PROCVAR_NAME_TYPE ON act_hi_varinst(NAME_, VAR_TYPE_);
CREATE INDEX ACT_IDX_HI_PROCVAR_BA ON act_hi_varinst(BYTEARRAY_ID_);

-- 历史详情表索引
CREATE INDEX ACT_IDX_HI_DETAIL_PROC_INST ON act_hi_detail(PROC_INST_ID_);
CREATE INDEX ACT_IDX_HI_DETAIL_EXEC ON act_hi_detail(EXECUTION_ID_);
CREATE INDEX ACT_IDX_HI_DETAIL_TASK ON act_hi_detail(TASK_ID_);
CREATE INDEX ACT_IDX_HI_DETAIL_ACT_INST ON act_hi_detail(ACT_INST_ID_);
CREATE INDEX ACT_IDX_HI_DETAIL_TIME ON act_hi_detail(TIME_);
CREATE INDEX ACT_IDX_HI_DETAIL_NAME ON act_hi_detail(NAME_);
CREATE INDEX ACT_IDX_HI_DETAIL_PROC_INST_NAME ON act_hi_detail(PROC_INST_ID_, NAME_);
CREATE INDEX ACT_IDX_HI_DETAIL_BA ON act_hi_detail(BYTEARRAY_ID_);

-- 历史身份链接表索引
CREATE INDEX ACT_IDX_HI_IDENT_LNK_TASK ON act_hi_identitylink(TASK_ID_);
CREATE INDEX ACT_IDX_HI_IDENT_LNK_PROC_INST ON act_hi_identitylink(PROC_INST_ID_);
CREATE INDEX ACT_IDX_HI_IDENT_LNK_USER ON act_hi_identitylink(USER_ID_);
CREATE INDEX ACT_IDX_HI_IDENT_LNK_GROUP ON act_hi_identitylink(GROUP_ID_);
CREATE INDEX ACT_IDX_HI_IDENT_LNK_SCOPE ON act_hi_identitylink(SCOPE_ID_);
CREATE INDEX ACT_IDX_HI_IDENT_LNK_SUB_SCOPE ON act_hi_identitylink(SUB_SCOPE_ID_);
CREATE INDEX ACT_IDX_HI_IDENT_LNK_SCOPE_TYPE ON act_hi_identitylink(SCOPE_TYPE_);

-- 历史评论表索引
CREATE INDEX ACT_IDX_HI_COMMENT_TASK ON act_hi_comment(TASK_ID_);
CREATE INDEX ACT_IDX_HI_COMMENT_PROCINST ON act_hi_comment(PROC_INST_ID_);
CREATE INDEX ACT_IDX_HI_COMMENT_TIME ON act_hi_comment(TIME_);

-- 历史附件表索引
CREATE INDEX ACT_IDX_HI_ATTACHMENT_TASK ON act_hi_attachment(TASK_ID_);
CREATE INDEX ACT_IDX_HI_ATTACHMENT_PROCINST ON act_hi_attachment(PROC_INST_ID_);
CREATE INDEX ACT_IDX_HI_ATTACHMENT_TIME ON act_hi_attachment(TIME_);

-- ============================================================
-- 6. 初始化属性数据
-- ============================================================

-- 插入Flowable引擎版本信息 (7.2.0.2 是官方最新版本)
INSERT INTO act_ge_property (NAME_, VALUE_, REV_) VALUES ('schema.version', '7.2.0.2', 1);
INSERT INTO act_ge_property (NAME_, VALUE_, REV_) VALUES ('schema.history', 'create(7.2.0.2)', 1);
INSERT INTO act_ge_property (NAME_, VALUE_, REV_) VALUES ('next.dbid', '1', 1);

-- 插入 schema 日志
INSERT INTO act_ge_schema_log (ID_, TIMESTAMP_, VERSION_) VALUES ('0', NOW(3), '7.2.0.2');

SET FOREIGN_KEY_CHECKS = 1;
SET UNIQUE_CHECKS = 1;

-- ============================================================
-- 说明
-- ============================================================
-- 此脚本为Flowable 7.2.0的MySQL 8.0+数据库表初始化脚本
-- 包含以下类型的表（共26张核心表）：
-- 1. ACT_GE_*: 通用数据表 (3张)
-- 2. ACT_RE_*: 流程定义存储表 (3张)
-- 3. ACT_RU_*: 运行时流程实例表 (12张)
-- 4. ACT_HI_*: 历史流程实例表 (8张)
-- 
-- 主要更新内容：
-- 1. 添加了缺失的表：ACT_RU_ACTINST, ACT_RU_ENTITYLINK, ACT_RU_HISTORY_JOB
-- 2. 添加了完整的索引（超过100个）
-- 3. 使用了正确的schema版本 7.2.0.2
-- 4. 使用 utf8mb4 字符集和 utf8mb4_bin 排序规则，兼容 MySQL 8.0+
-- 5. 添加了 ACT_GE_SCHEMA_LOG 表
-- 6. 所有表都指定了 ENGINE=INNODB
-- 
-- 注意：
-- - 此脚本适用于MySQL 8.0及以上版本
-- - 已在脚本开头禁用外键检查，确保表可以按任意顺序创建
-- - 已按依赖关系逆序删除所有旧表，确保清理干净
-- - 所有表都不包含外键约束，避免创建顺序问题
-- - Flowable引擎在运行时会自动管理数据关系
-- - 如需要IDM（身份管理）模块，请单独执行相关脚本
-- 
-- 执行前请确保：
-- 1. 数据库已创建
-- 2. 数据库用户有足够权限（CREATE TABLE, CREATE INDEX, DROP TABLE等）
-- 3. JDBC连接参数包含 nullCatalogMeansCurrent=true
--    示例：jdbc:mysql://localhost:3306/flowable_db?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai&nullCatalogMeansCurrent=true
