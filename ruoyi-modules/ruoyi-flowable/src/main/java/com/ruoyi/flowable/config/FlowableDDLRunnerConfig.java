package com.ruoyi.flowable.config;

import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

/**
 * Flowable DDL Runner 配置类
 * 用于覆盖 Flowable 自动配置创建的问题 Bean ddlApplicationRunner
 * 
 * 问题描述：
 * Flowable 自动配置中的 ddlApplicationRunner Bean 在某些条件下返回 NullBean，
 * 导致 Spring Boot 在 callRunners 时出现类型不匹配错误：
 * "Bean named 'ddlApplicationRunner' is expected to be of type 'org.springframework.boot.Runner' 
 * but was actually of type 'org.springframework.beans.factory.support.NullBean'"
 * 
 * 解决方案：
 * 创建一个空的 ddlApplicationRunner Bean 来覆盖问题的 Bean。
 * 由于我们已经排除了 Flowable 自动配置并手动配置了所有 Flowable Bean，
 * 这个 DDL Runner 实际上不需要执行任何操作。
 */
@Configuration
public class FlowableDDLRunnerConfig {

    /**
     * 创建一个空的 ApplicationRunner Bean，名称为 ddlApplicationRunner
     * 用于覆盖 Flowable 自动配置创建的问题 Bean
     */
    @Bean(name = "ddlApplicationRunner")
    @Primary
    public ApplicationRunner ddlApplicationRunner() {
        return new ApplicationRunner() {
            @Override
            public void run(ApplicationArguments args) throws Exception {
                // 空实现，什么都不做
                // 因为我们已经手动配置了 Flowable，不需要自动 DDL 操作
            }
        };
    }
}
