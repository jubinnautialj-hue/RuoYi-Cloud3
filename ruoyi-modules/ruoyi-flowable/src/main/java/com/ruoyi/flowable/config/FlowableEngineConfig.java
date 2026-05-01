package com.ruoyi.flowable.config;

import jakarta.annotation.Resource;
import javax.sql.DataSource;

import org.flowable.common.engine.impl.cfg.ProcessEngineConfiguration;
import org.flowable.spring.boot.EngineConfigurationConfigurer;
import org.flowable.spring.boot.app.SpringAppEngineConfiguration;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.PlatformTransactionManager;

/**
 * Flowable引擎配置
 * 配置Flowable使用独立的数据源和事务管理器
 * 
 * @author ruoyi
 */
@Configuration
public class FlowableEngineConfig implements EngineConfigurationConfigurer<SpringAppEngineConfiguration>
{
    @Resource(name = "flowableDataSource")
    private DataSource flowableDataSource;

    @Resource(name = "flowableTransactionManager")
    private PlatformTransactionManager flowableTransactionManager;

    @Override
    public void configure(SpringAppEngineConfiguration configuration)
    {
        configuration.setDataSource(flowableDataSource);
        configuration.setTransactionManager(flowableTransactionManager);
        configuration.setDatabaseSchemaUpdate(ProcessEngineConfiguration.DB_SCHEMA_UPDATE_TRUE);
        configuration.setActivityFontName("宋体");
        configuration.setLabelFontName("宋体");
        configuration.setAnnotationFontName("宋体");
    }
}
