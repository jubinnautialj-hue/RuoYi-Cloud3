package com.ruoyi.flowable.config;

import javax.sql.DataSource;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;

import com.alibaba.druid.spring.boot3.autoconfigure.DruidDataSourceBuilder;

/**
 * Flowable独立数据源配置
 * 
 * @author ruoyi
 */
@Configuration
public class FlowableDataSourceConfig
{
    @Bean(name = "flowableDataSource")
    @ConfigurationProperties(prefix = "spring.datasource.druid.flowable")
    public DataSource flowableDataSource()
    {
        return DruidDataSourceBuilder.create().build();
    }

    @Bean(name = "flowableTransactionManager")
    public PlatformTransactionManager flowableTransactionManager(DataSource flowableDataSource)
    {
        return new DataSourceTransactionManager(flowableDataSource);
    }
}
