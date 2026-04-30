SET NAMES utf8mb4;

-- ----------------------------
-- Flowable 7.2.0 数据库表初始化脚本
-- 适用于 MySQL 5.7+
-- ----------------------------

-- ============================================================
-- 1. 通用数据表 (ACT_GE_*)
-- ============================================================

-- ----------------------------
-- 通用属性表
-- ----------------------------
drop table if exists act_ge_property;
create table act_ge_property (
  NAME_          varchar(64)      not null,
  VALUE_         varchar(300)     null,
  REV_           int              null,
  primary key (NAME_)
) engine=innodb comment = '通用属性表';

-- ----------------------------
-- 通用资源表
-- ----------------------------
drop table if exists act_ge_bytearray;
create table act_ge_bytearray (
  ID_            varchar(64)      not null,
  REV_           int              null,
  NAME_          varchar(255)     null,
  DEPLOYMENT_ID_ varchar(64)      null,
  BYTES_         longblob         null,
  GENERATED_     tinyint          null,
  primary key (ID_)
) engine=innodb comment = '通用资源表';

-- ============================================================
-- 2. 流程定义存储表 (ACT_RE_*)
-- ============================================================

-- ----------------------------
-- 流程部署表
-- ----------------------------
drop table if exists act_re_deployment;
create table act_re_deployment (
  ID_                     varchar(64)      not null,
  NAME_                   varchar(255)     null,
  CATEGORY_               varchar(255)     null,
  KEY_                    varchar(255)     null,
  TENANT_ID_              varchar(255)     default '',
  DEPLOY_TIME_            datetime(3)      null,
  DERIVED_FROM_           varchar(64)      null,
  DERIVED_FROM_ROOT_      varchar(64)      null,
  PARENT_DEPLOYMENT_ID_   varchar(64)      null,
  ENGINE_VERSION_         varchar(255)     null,
  primary key (ID_)
) engine=innodb comment = '流程部署表';

-- ----------------------------
-- 流程定义表
-- ----------------------------
drop table if exists act_re_procdef;
create table act_re_procdef (
  ID_                     varchar(64)      not null,
  REV_                    int              null,
  CATEGORY_               varchar(255)     null,
  NAME_                   varchar(255)     null,
  KEY_                    varchar(255)     not null,
  VERSION_                int              not null,
  DEPLOYMENT_ID_          varchar(64)      null,
  RESOURCE_NAME_          varchar(4000)   null,
  DGRM_RESOURCE_NAME_     varchar(4000)   null,
  DESCRIPTION_            varchar(4000)   null,
  HAS_START_FORM_KEY_     tinyint          null,
  HAS_GRAPHICAL_NOTATION_ tinyint          null,
  SUSPENSION_STATE_       int              null,
  TENANT_ID_              varchar(255)     default '',
  ENGINE_VERSION_         varchar(255)     null,
  DERIVED_FROM_           varchar(64)      null,
  DERIVED_FROM_ROOT_      varchar(64)      null,
  DERIVED_VERSION_        int              default 0,
  primary key (ID_),
  unique key ACT_UNIQ_PROCDEF (KEY_, VERSION_, TENANT_ID_, DERIVED_VERSION_)
) engine=innodb comment = '流程定义表';

-- ----------------------------
-- 流程模型表
-- ----------------------------
drop table if exists act_re_model;
create table act_re_model (
  ID_                          varchar(64)      not null,
  REV_                         int              null,
  NAME_                        varchar(255)     null,
  KEY_                         varchar(255)     null,
  CATEGORY_                    varchar(255)     null,
  CREATE_TIME_                 datetime(3)      null,
  LAST_UPDATE_TIME_            datetime(3)      null,
  VERSION_                     int              null,
  META_INFO_                   varchar(4000)   null,
  DEPLOYMENT_ID_               varchar(64)      null,
  EDITOR_SOURCE_VALUE_ID_      varchar(64)      null,
  EDITOR_SOURCE_EXTRA_VALUE_ID_ varchar(64)     null,
  TENANT_ID_                   varchar(255)     default '',
  primary key (ID_)
) engine=innodb comment = '流程模型表';

-- ============================================================
-- 3. 运行时流程表 (ACT_RU_*)
-- ============================================================

-- ----------------------------
-- 运行时流程实例表
-- ----------------------------
drop table if exists act_ru_execution;
create table act_ru_execution (
  ID_                    varchar(64)      not null,
  REV_                   int              null,
  PROC_INST_ID_          varchar(64)      null,
  BUSINESS_KEY_          varchar(255)     null,
  PARENT_ID_             varchar(64)      null,
  PROC_DEF_ID_           varchar(64)      null,
  SUPER_EXEC_            varchar(64)      null,
  ROOT_PROC_INST_ID_     varchar(64)      null,
  ACT_ID_                varchar(255)     null,
  IS_ACTIVE_             tinyint          null,
  IS_CONCURRENT_         tinyint          null,
  IS_SCOPE_              tinyint          null,
  IS_EVENT_SCOPE_        tinyint          null,
  IS_MI_ROOT_            tinyint          null,
  SUSPENSION_STATE_      int              null,
  CACHED_ENT_STATE_      int              null,
  TENANT_ID_             varchar(255)     default '',
  NAME_                  varchar(255)     null,
  START_TIME_            datetime(3)      null,
  START_USER_ID_         varchar(255)     null,
  LOCK_TIME_             datetime(3)      null,
  LOCK_OWNER_            varchar(255)     null,
  IS_COUNT_ENABLED_      tinyint          null,
  EVT_SUBSCR_COUNT_      int              null,
  TASK_COUNT_            int              null,
  JOB_COUNT_             int              null,
  TIMER_JOB_COUNT_       int              null,
  SUSP_JOB_COUNT_        int              null,
  DEADLETTER_JOB_COUNT_  int              null,
  VAR_COUNT_             int              null,
  ID_LINK_COUNT_         int              null,
  primary key (ID_)
) engine=innodb comment = '运行时流程实例表';

-- ----------------------------
-- 运行时任务表
-- ----------------------------
drop table if exists act_ru_task;
create table act_ru_task (
  ID_                   varchar(64)      not null,
  REV_                  int              null,
  EXECUTION_ID_         varchar(64)      null,
  PROC_INST_ID_         varchar(64)      null,
  PROC_DEF_ID_          varchar(64)      null,
  TASK_DEF_ID_          varchar(64)      null,
  SCOPE_ID_             varchar(255)     null,
  SUB_SCOPE_ID_         varchar(255)     null,
  SCOPE_TYPE_           varchar(255)     null,
  SCOPE_DEFINITION_ID_  varchar(255)     null,
  NAME_                 varchar(255)     null,
  PARENT_TASK_ID_       varchar(64)      null,
  DESCRIPTION_          varchar(4000)   null,
  TASK_DEF_KEY_         varchar(255)     null,
  OWNER_                varchar(255)     null,
  ASSIGNEE_             varchar(255)     null,
  DELEGATION_           varchar(64)      null,
  PRIORITY_             int              null,
  CREATE_TIME_          datetime(3)      null,
  DUE_DATE_             datetime(3)      null,
  CATEGORY_             varchar(255)     null,
  SUSPENSION_STATE_     int              null,
  TENANT_ID_            varchar(255)     default '',
  FORM_KEY_             varchar(255)     null,
  CLAIM_TIME_           datetime(3)      null,
  IS_COUNT_ENABLED_     tinyint          null,
  VAR_COUNT_            int              null,
  ID_LINK_COUNT_        int              null,
  SUB_TASK_COUNT_       int              null,
  primary key (ID_)
) engine=innodb comment = '运行时任务表';

-- ----------------------------
-- 运行时变量表
-- ----------------------------
drop table if exists act_ru_variable;
create table act_ru_variable (
  ID_              varchar(64)      not null,
  REV_             int              null,
  TYPE_            varchar(255)     not null,
  NAME_            varchar(255)     not null,
  EXECUTION_ID_    varchar(64)      null,
  PROC_INST_ID_    varchar(64)      null,
  TASK_ID_         varchar(64)      null,
  SCOPE_ID_        varchar(255)     null,
  SUB_SCOPE_ID_    varchar(255)     null,
  SCOPE_TYPE_      varchar(255)     null,
  BYTEARRAY_ID_    varchar(64)      null,
  DOUBLE_          double           null,
  LONG_            bigint           null,
  TEXT_            varchar(4000)   null,
  TEXT2_           varchar(4000)   null,
  primary key (ID_)
) engine=innodb comment = '运行时变量表';

-- ----------------------------
-- 运行时事件订阅表
-- ----------------------------
drop table if exists act_ru_event_subscr;
create table act_ru_event_subscr (
  ID_                    varchar(64)      not null,
  REV_                   int              null,
  EVENT_TYPE_            varchar(255)     not null,
  EVENT_NAME_            varchar(255)     null,
  EXECUTION_ID_          varchar(64)      null,
  PROC_INST_ID_          varchar(64)      null,
  ACTIVITY_ID_           varchar(255)     null,
  CONFIGURATION_         varchar(255)     null,
  CREATED_               datetime(3)      not null,
  PROC_DEF_ID_           varchar(64)      null,
  TENANT_ID_             varchar(255)     default '',
  SCOPE_ID_              varchar(255)     null,
  SUB_SCOPE_ID_          varchar(255)     null,
  SCOPE_TYPE_            varchar(255)     null,
  SCOPE_DEFINITION_ID_   varchar(255)     null,
  primary key (ID_)
) engine=innodb comment = '运行时事件订阅表';

-- ----------------------------
-- 运行时作业表
-- ----------------------------
drop table if exists act_ru_job;
create table act_ru_job (
  ID_                    varchar(64)      not null,
  REV_                   int              null,
  TYPE_                  varchar(255)     not null,
  LOCK_EXP_TIME_         datetime(3)      null,
  LOCK_OWNER_            varchar(255)     null,
  EXCLUSIVE_             tinyint          null,
  EXECUTION_ID_          varchar(64)      null,
  PROCESS_INSTANCE_ID_   varchar(64)      null,
  PROC_DEF_ID_           varchar(64)      null,
  SCOPE_ID_              varchar(255)     null,
  SUB_SCOPE_ID_          varchar(255)     null,
  SCOPE_TYPE_            varchar(255)     null,
  ELEMENT_ID_            varchar(255)     null,
  ELEMENT_NAME_          varchar(255)     null,
  SCOPE_DEFINITION_ID_   varchar(255)     null,
  RETRIES_               int              null,
  EXCEPTION_STACK_ID_    varchar(64)      null,
  EXCEPTION_MSG_         varchar(4000)   null,
  DUEDATE_               datetime(3)      null,
  REPEAT_                varchar(255)     null,
  HANDLER_TYPE_          varchar(255)     null,
  HANDLER_CFG_           varchar(4000)   null,
  CUSTOM_VALUES_ID_      varchar(64)      null,
  CREATE_TIME_           datetime(3)      null,
  TENANT_ID_             varchar(255)     default '',
  primary key (ID_)
) engine=innodb comment = '运行时作业表';

-- ----------------------------
-- 运行时定时作业表
-- ----------------------------
drop table if exists act_ru_timer_job;
create table act_ru_timer_job (
  ID_                    varchar(64)      not null,
  REV_                   int              null,
  TYPE_                  varchar(255)     not null,
  LOCK_EXP_TIME_         datetime(3)      null,
  LOCK_OWNER_            varchar(255)     null,
  EXCLUSIVE_             tinyint          null,
  EXECUTION_ID_          varchar(64)      null,
  PROCESS_INSTANCE_ID_   varchar(64)      null,
  PROC_DEF_ID_           varchar(64)      null,
  SCOPE_ID_              varchar(255)     null,
  SUB_SCOPE_ID_          varchar(255)     null,
  SCOPE_TYPE_            varchar(255)     null,
  ELEMENT_ID_            varchar(255)     null,
  ELEMENT_NAME_          varchar(255)     null,
  SCOPE_DEFINITION_ID_   varchar(255)     null,
  RETRIES_               int              null,
  EXCEPTION_STACK_ID_    varchar(64)      null,
  EXCEPTION_MSG_         varchar(4000)   null,
  DUEDATE_               datetime(3)      null,
  REPEAT_                varchar(255)     null,
  HANDLER_TYPE_          varchar(255)     null,
  HANDLER_CFG_           varchar(4000)   null,
  CUSTOM_VALUES_ID_      varchar(64)      null,
  CREATE_TIME_           datetime(3)      null,
  TENANT_ID_             varchar(255)     default '',
  primary key (ID_)
) engine=innodb comment = '运行时定时作业表';

-- ----------------------------
-- 运行时挂起作业表
-- ----------------------------
drop table if exists act_ru_suspended_job;
create table act_ru_suspended_job (
  ID_                    varchar(64)      not null,
  REV_                   int              null,
  TYPE_                  varchar(255)     not null,
  LOCK_EXP_TIME_         datetime(3)      null,
  LOCK_OWNER_            varchar(255)     null,
  EXCLUSIVE_             tinyint          null,
  EXECUTION_ID_          varchar(64)      null,
  PROCESS_INSTANCE_ID_   varchar(64)      null,
  PROC_DEF_ID_           varchar(64)      null,
  SCOPE_ID_              varchar(255)     null,
  SUB_SCOPE_ID_          varchar(255)     null,
  SCOPE_TYPE_            varchar(255)     null,
  ELEMENT_ID_            varchar(255)     null,
  ELEMENT_NAME_          varchar(255)     null,
  SCOPE_DEFINITION_ID_   varchar(255)     null,
  RETRIES_               int              null,
  EXCEPTION_STACK_ID_    varchar(64)      null,
  EXCEPTION_MSG_         varchar(4000)   null,
  DUEDATE_               datetime(3)      null,
  REPEAT_                varchar(255)     null,
  HANDLER_TYPE_          varchar(255)     null,
  HANDLER_CFG_           varchar(4000)   null,
  CUSTOM_VALUES_ID_      varchar(64)      null,
  CREATE_TIME_           datetime(3)      null,
  TENANT_ID_             varchar(255)     default '',
  primary key (ID_)
) engine=innodb comment = '运行时挂起作业表';

-- ----------------------------
-- 运行时死信作业表
-- ----------------------------
drop table if exists act_ru_deadletter_job;
create table act_ru_deadletter_job (
  ID_                    varchar(64)      not null,
  REV_                   int              null,
  TYPE_                  varchar(255)     not null,
  LOCK_EXP_TIME_         datetime(3)      null,
  LOCK_OWNER_            varchar(255)     null,
  EXCLUSIVE_             tinyint          null,
  EXECUTION_ID_          varchar(64)      null,
  PROCESS_INSTANCE_ID_   varchar(64)      null,
  PROC_DEF_ID_           varchar(64)      null,
  SCOPE_ID_              varchar(255)     null,
  SUB_SCOPE_ID_          varchar(255)     null,
  SCOPE_TYPE_            varchar(255)     null,
  ELEMENT_ID_            varchar(255)     null,
  ELEMENT_NAME_          varchar(255)     null,
  SCOPE_DEFINITION_ID_   varchar(255)     null,
  RETRIES_               int              null,
  EXCEPTION_STACK_ID_    varchar(64)      null,
  EXCEPTION_MSG_         varchar(4000)   null,
  DUEDATE_               datetime(3)      null,
  REPEAT_                varchar(255)     null,
  HANDLER_TYPE_          varchar(255)     null,
  HANDLER_CFG_           varchar(4000)   null,
  CUSTOM_VALUES_ID_      varchar(64)      null,
  CREATE_TIME_           datetime(3)      null,
  TENANT_ID_             varchar(255)     default '',
  primary key (ID_)
) engine=innodb comment = '运行时死信作业表';

-- ----------------------------
-- 运行时身份链接表
-- ----------------------------
drop table if exists act_ru_identitylink;
create table act_ru_identitylink (
  ID_                    varchar(64)      not null,
  REV_                   int              null,
  GROUP_ID_              varchar(255)     null,
  TYPE_                  varchar(255)     null,
  USER_ID_               varchar(255)     null,
  TASK_ID_               varchar(64)      null,
  PROC_INST_ID_          varchar(64)      null,
  PROC_DEF_ID_           varchar(64)      null,
  SCOPE_ID_              varchar(255)     null,
  SUB_SCOPE_ID_          varchar(255)     null,
  SCOPE_TYPE_            varchar(255)     null,
  SCOPE_DEFINITION_ID_   varchar(255)     null,
  primary key (ID_)
) engine=innodb comment = '运行时身份链接表';

-- ============================================================
-- 4. 历史流程表 (ACT_HI_*)
-- ============================================================

-- ----------------------------
-- 历史流程实例表
-- ----------------------------
drop table if exists act_hi_procinst;
create table act_hi_procinst (
  ID_                         varchar(64)      not null,
  REV_                        int              null,
  PROC_INST_ID_               varchar(64)      not null,
  BUSINESS_KEY_               varchar(255)     null,
  PROC_DEF_ID_                varchar(64)      not null,
  START_TIME_                 datetime(3)      not null,
  END_TIME_                   datetime(3)      null,
  DURATION_                   bigint           null,
  START_USER_ID_              varchar(255)     null,
  START_ACT_ID_               varchar(255)     null,
  END_ACT_ID_                 varchar(255)     null,
  SUPER_PROCESS_INSTANCE_ID_  varchar(64)      null,
  DELETE_REASON_              varchar(4000)   null,
  TENANT_ID_                  varchar(255)     default '',
  NAME_                       varchar(255)     null,
  CALLBACK_ID_                varchar(255)     null,
  CALLBACK_TYPE_              varchar(255)     null,
  REFERENCE_ID_               varchar(255)     null,
  REFERENCE_TYPE_             varchar(255)     null,
  PROPAGATED_STAGE_INST_ID_   varchar(255)     null,
  BUSINESS_STATUS_            varchar(255)     null,
  primary key (ID_),
  unique key ACT_UNIQ_HI_PROC_INST (PROC_INST_ID_)
) engine=innodb comment = '历史流程实例表';

-- ----------------------------
-- 历史活动实例表
-- ----------------------------
drop table if exists act_hi_actinst;
create table act_hi_actinst (
  ID_                varchar(64)      not null,
  REV_               int              null,
  PROC_DEF_ID_       varchar(64)      not null,
  PROC_INST_ID_      varchar(64)      not null,
  EXECUTION_ID_      varchar(64)      not null,
  ACT_ID_            varchar(255)     not null,
  TASK_ID_           varchar(64)      null,
  CALL_PROC_INST_ID_ varchar(64)      null,
  ACT_NAME_          varchar(255)     null,
  ACT_TYPE_          varchar(255)     not null,
  ASSIGNEE_          varchar(255)     null,
  START_TIME_        datetime(3)      not null,
  END_TIME_          datetime(3)      null,
  DURATION_          bigint           null,
  DELETE_REASON_     varchar(4000)   null,
  TENANT_ID_         varchar(255)     default '',
  primary key (ID_)
) engine=innodb comment = '历史活动实例表';

-- ----------------------------
-- 历史任务实例表
-- ----------------------------
drop table if exists act_hi_taskinst;
create table act_hi_taskinst (
  ID_                     varchar(64)      not null,
  REV_                    int              null,
  PROC_DEF_ID_            varchar(64)      null,
  TASK_DEF_ID_            varchar(64)      null,
  TASK_DEF_KEY_           varchar(255)     null,
  PROC_INST_ID_           varchar(64)      null,
  EXECUTION_ID_           varchar(64)      null,
  SCOPE_ID_               varchar(255)     null,
  SUB_SCOPE_ID_           varchar(255)     null,
  SCOPE_TYPE_             varchar(255)     null,
  SCOPE_DEFINITION_ID_    varchar(255)     null,
  NAME_                   varchar(255)     null,
  PARENT_TASK_ID_         varchar(64)      null,
  DESCRIPTION_            varchar(4000)   null,
  OWNER_                  varchar(255)     null,
  ASSIGNEE_               varchar(255)     null,
  DELEGATION_             varchar(64)      null,
  PRIORITY_               int              null,
  CREATE_TIME_            datetime(3)      not null,
  CLAIM_TIME_             datetime(3)      null,
  END_TIME_               datetime(3)      null,
  DURATION_               bigint           null,
  DELETE_REASON_          varchar(4000)   null,
  FORM_KEY_               varchar(255)     null,
  CATEGORY_               varchar(255)     null,
  TENANT_ID_              varchar(255)     default '',
  LAST_UPDATED_TIME_      datetime(3)      null,
  QUERY_COUNT_            int              default 0,
  AD_HOC_                 tinyint          null,
  AD_HOC_ORDER_           int              null,
  AD_HOC_REMOVED_         tinyint          null,
  primary key (ID_)
) engine=innodb comment = '历史任务实例表';

-- ----------------------------
-- 历史变量实例表
-- ----------------------------
drop table if exists act_hi_varinst;
create table act_hi_varinst (
  ID_                 varchar(64)      not null,
  REV_                int              null,
  PROC_INST_ID_       varchar(64)      null,
  EXECUTION_ID_       varchar(64)      null,
  TASK_ID_            varchar(64)      null,
  SCOPE_ID_           varchar(255)     null,
  SUB_SCOPE_ID_       varchar(255)     null,
  SCOPE_TYPE_         varchar(255)     null,
  NAME_               varchar(255)     not null,
  VAR_TYPE_           varchar(100)     null,
  BYTEARRAY_ID_       varchar(64)      null,
  DOUBLE_             double           null,
  LONG_               bigint           null,
  TEXT_               varchar(4000)   null,
  TEXT2_              varchar(4000)   null,
  CREATE_TIME_        datetime(3)      null,
  LAST_UPDATED_TIME_  datetime(3)      null,
  primary key (ID_)
) engine=innodb comment = '历史变量实例表';

-- ----------------------------
-- 历史详情表
-- ----------------------------
drop table if exists act_hi_detail;
create table act_hi_detail (
  ID_            varchar(64)      not null,
  REV_           int              null,
  TYPE_          varchar(255)     not null,
  PROC_INST_ID_  varchar(64)      null,
  EXECUTION_ID_  varchar(64)      null,
  TASK_ID_       varchar(64)      null,
  ACT_INST_ID_   varchar(64)      null,
  NAME_          varchar(255)     null,
  VAR_TYPE_      varchar(255)     null,
  REV_           int              null,
  TIME_          datetime(3)      not null,
  BYTEARRAY_ID_  varchar(64)      null,
  DOUBLE_        double           null,
  LONG_          bigint           null,
  TEXT_          varchar(4000)   null,
  TEXT2_         varchar(4000)   null,
  primary key (ID_)
) engine=innodb comment = '历史详情表';

-- ----------------------------
-- 历史身份链接表
-- ----------------------------
drop table if exists act_hi_identitylink;
create table act_hi_identitylink (
  ID_                    varchar(64)      not null,
  GROUP_ID_              varchar(255)     null,
  TYPE_                  varchar(255)     null,
  USER_ID_               varchar(255)     null,
  TASK_ID_               varchar(64)      null,
  PROC_INST_ID_          varchar(64)      null,
  SCOPE_ID_              varchar(255)     null,
  SUB_SCOPE_ID_          varchar(255)     null,
  SCOPE_TYPE_            varchar(255)     null,
  SCOPE_DEFINITION_ID_   varchar(255)     null,
  primary key (ID_)
) engine=innodb comment = '历史身份链接表';

-- ----------------------------
-- 历史评论表
-- ----------------------------
drop table if exists act_hi_comment;
create table act_hi_comment (
  ID_            varchar(64)      not null,
  REV_           int              null,
  TYPE_          varchar(255)     null,
  TIME_          datetime(3)      not null,
  USER_ID_       varchar(255)     null,
  TASK_ID_       varchar(64)      null,
  PROC_INST_ID_  varchar(64)      null,
  ACTION_        varchar(255)     null,
  MESSAGE_       varchar(4000)   null,
  FULL_MSG_      longblob         null,
  primary key (ID_)
) engine=innodb comment = '历史评论表';

-- ----------------------------
-- 历史附件表
-- ----------------------------
drop table if exists act_hi_attachment;
create table act_hi_attachment (
  ID_            varchar(64)      not null,
  REV_           int              null,
  USER_ID_       varchar(255)     null,
  NAME_          varchar(255)     null,
  DESCRIPTION_   varchar(4000)   null,
  TYPE_          varchar(255)     null,
  TASK_ID_       varchar(64)      null,
  PROC_INST_ID_  varchar(64)      null,
  URL_           varchar(4000)   null,
  CONTENT_ID_    varchar(64)      null,
  TIME_          datetime(3)      null,
  primary key (ID_)
) engine=innodb comment = '历史附件表';

-- ============================================================
-- 5. 初始化属性数据
-- ============================================================

-- 插入Flowable引擎版本信息
insert into act_ge_property (NAME_, VALUE_, REV_) values ('schema.version', '7.2.0.0', 1);
insert into act_ge_property (NAME_, VALUE_, REV_) values ('schema.history', 'create(7.2.0.0)', 1);
insert into act_ge_property (NAME_, VALUE_, REV_) values ('next.dbid', '1', 1);

-- ============================================================
-- 说明
-- ============================================================
-- 此脚本为Flowable 7.2.0的MySQL数据库表初始化脚本
-- 包含以下类型的表：
-- 1. ACT_GE_*: 通用数据表
-- 2. ACT_RE_*: 流程定义存储表
-- 3. ACT_RU_*: 运行时流程实例表
-- 4. ACT_HI_*: 历史流程实例表
-- 
-- 注意：
-- - 此脚本适用于MySQL 5.7及以上版本
-- - 已移除所有外键约束，避免表创建顺序导致的问题
-- - Flowable引擎启动时会自动创建所需的索引
-- - 如需要IDM（身份管理）模块，请单独执行相关脚本