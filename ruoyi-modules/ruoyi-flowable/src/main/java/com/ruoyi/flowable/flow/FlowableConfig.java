package com.ruoyi.flowable.flow;

import com.baomidou.dynamic.datasource.DynamicRoutingDataSource;
import org.flowable.spring.SpringProcessEngineConfiguration;
import org.flowable.spring.boot.EngineConfigurationConfigurer;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.DependsOn;

import javax.sql.DataSource;

/**
 * Flowable 配置类
 * 确保在动态数据源初始化之后再配置 Flowable
 * 
 * @author XuanXuan
 * @date 2021/4/5 01:32
 */
@Configuration
@DependsOn("dataSource")
public class FlowableConfig implements EngineConfigurationConfigurer<SpringProcessEngineConfiguration> {

    private final DataSource dataSource;

    public FlowableConfig(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public void configure(SpringProcessEngineConfiguration engineConfiguration) {
        if (dataSource instanceof DynamicRoutingDataSource) {
            DynamicRoutingDataSource dynamicRoutingDataSource = (DynamicRoutingDataSource) dataSource;
            DataSource masterDataSource = dynamicRoutingDataSource.getDataSource("master");
            if (masterDataSource != null) {
                engineConfiguration.setDataSource(masterDataSource);
            }
        }
        
        engineConfiguration.setActivityFontName("宋体");
        engineConfiguration.setLabelFontName("宋体");
        engineConfiguration.setAnnotationFontName("宋体");
        engineConfiguration.setDatabaseSchemaUpdate("true");
    }
}
