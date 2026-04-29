package com.ruoyi.flowable.flow;

import com.baomidou.dynamic.datasource.DynamicRoutingDataSource;
import org.flowable.engine.*;
import org.flowable.spring.ProcessEngineFactoryBean;
import org.flowable.spring.SpringProcessEngineConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.DependsOn;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;

import javax.sql.DataSource;

/**
 * Flowable 配置类
 * 手动配置所有 Flowable Bean，避免自动配置的问题
 * 
 * @author XuanXuan
 * @date 2021/4/5 01:32
 */
@Configuration
@DependsOn("dataSource")
public class FlowableConfig {

    private final DataSource dataSource;

    public FlowableConfig(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Bean(name = "flowableTransactionManager")
    public PlatformTransactionManager transactionManager() {
        DataSource actualDataSource = getActualDataSource();
        return new DataSourceTransactionManager(actualDataSource);
    }

    @Bean
    @DependsOn("dataSource")
    public SpringProcessEngineConfiguration springProcessEngineConfiguration() {
        SpringProcessEngineConfiguration configuration = new SpringProcessEngineConfiguration();
        
        DataSource actualDataSource = getActualDataSource();
        configuration.setDataSource(actualDataSource);
        configuration.setTransactionManager(transactionManager());
        
        configuration.setDatabaseSchemaUpdate("false");
        configuration.setActivityFontName("宋体");
        configuration.setLabelFontName("宋体");
        configuration.setAnnotationFontName("宋体");
        
        configuration.setHistoryLevel(org.flowable.engine.impl.history.HistoryLevel.AUDIT);
        configuration.setJobExecutorActivate(false);
        configuration.setAsyncExecutorActivate(false);
        
        return configuration;
    }

    @Bean(name = "processEngine")
    @DependsOn("springProcessEngineConfiguration")
    public ProcessEngineFactoryBean processEngineFactoryBean() {
        ProcessEngineFactoryBean factoryBean = new ProcessEngineFactoryBean();
        factoryBean.setProcessEngineConfiguration(springProcessEngineConfiguration());
        return factoryBean;
    }

    @Bean
    @DependsOn("processEngine")
    public RepositoryService repositoryService(ProcessEngine processEngine) {
        return processEngine.getRepositoryService();
    }

    @Bean
    @DependsOn("processEngine")
    public RuntimeService runtimeService(ProcessEngine processEngine) {
        return processEngine.getRuntimeService();
    }

    @Bean
    @DependsOn("processEngine")
    public TaskService taskService(ProcessEngine processEngine) {
        return processEngine.getTaskService();
    }

    @Bean
    @DependsOn("processEngine")
    public HistoryService historyService(ProcessEngine processEngine) {
        return processEngine.getHistoryService();
    }

    @Bean
    @DependsOn("processEngine")
    public ManagementService managementService(ProcessEngine processEngine) {
        return processEngine.getManagementService();
    }

    @Bean
    @DependsOn("processEngine")
    public FormService formService(ProcessEngine processEngine) {
        return processEngine.getFormService();
    }

    @Bean
    @DependsOn("processEngine")
    public IdentityService identityService(ProcessEngine processEngine) {
        return processEngine.getIdentityService();
    }

    private DataSource getActualDataSource() {
        if (dataSource instanceof DynamicRoutingDataSource) {
            DynamicRoutingDataSource dynamicRoutingDataSource = (DynamicRoutingDataSource) dataSource;
            DataSource masterDataSource = dynamicRoutingDataSource.getDataSource("master");
            if (masterDataSource != null) {
                return masterDataSource;
            }
        }
        return dataSource;
    }
}
