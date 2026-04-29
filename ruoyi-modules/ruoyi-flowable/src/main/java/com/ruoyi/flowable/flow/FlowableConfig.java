package com.ruoyi.flowable.flow;

import org.flowable.spring.SpringProcessEngineConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.DependsOn;
import org.springframework.context.annotation.Lazy;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;

import javax.sql.DataSource;

/**
 * Flowable 配置类
 * 手动配置 ProcessEngine，确保在动态数据源初始化之后再初始化
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

    @Bean
    @Lazy
    public PlatformTransactionManager transactionManager() {
        return new DataSourceTransactionManager(dataSource);
    }

    @Bean
    @Lazy
    @DependsOn("transactionManager")
    public SpringProcessEngineConfiguration springProcessEngineConfiguration(
            PlatformTransactionManager transactionManager) {
        SpringProcessEngineConfiguration configuration = new SpringProcessEngineConfiguration();
        configuration.setDataSource(dataSource);
        configuration.setTransactionManager(transactionManager);
        configuration.setDatabaseSchemaUpdate("true");
        configuration.setActivityFontName("宋体");
        configuration.setLabelFontName("宋体");
        configuration.setAnnotationFontName("宋体");
        return configuration;
    }
}
