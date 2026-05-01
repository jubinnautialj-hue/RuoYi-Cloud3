package com.ruoyi.flowable.config;

import jakarta.annotation.Resource;
import javax.sql.DataSource;

import org.flowable.app.spring.SpringAppEngineConfiguration;
import org.flowable.spring.boot.EngineConfigurationConfigurer;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.PlatformTransactionManager;

/**
 * Flowable引擎配置
 * 配置Flowable使用独立的数据源和事务管理器
 * 注意：字体配置（activity-font-name等）通过application.yml属性配置
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
        configuration.setDatabaseSchemaUpdate("true");
    }
}
