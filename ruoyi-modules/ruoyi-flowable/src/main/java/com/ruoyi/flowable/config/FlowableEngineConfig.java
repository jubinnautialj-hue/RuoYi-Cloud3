package com.ruoyi.flowable.config;

import jakarta.annotation.Resource;
import javax.sql.DataSource;

import org.flowable.spring.SpringProcessEngineConfiguration;
import org.flowable.spring.boot.EngineConfigurationConfigurer;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.PlatformTransactionManager;

/**
 * Flowable引擎配置
 * 配置Flowable使用独立的数据源和事务管理器
 * 
 * @author ruoyi
 */
@Configuration
public class FlowableEngineConfig implements EngineConfigurationConfigurer<SpringProcessEngineConfiguration>
{
    @Resource(name = "flowableDataSource")
    private DataSource flowableDataSource;

    @Resource(name = "flowableTransactionManager")
    private PlatformTransactionManager flowableTransactionManager;

    @Override
    public void configure(SpringProcessEngineConfiguration configuration)
    {
        configuration.setDataSource(flowableDataSource);
        configuration.setTransactionManager(flowableTransactionManager);
        configuration.setDatabaseSchemaUpdate("true");
        configuration.setActivityFontName("宋体");
        configuration.setLabelFontName("宋体");
        configuration.setAnnotationFontName("宋体");
    }
}
