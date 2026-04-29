package com.ruoyi.flowable.config;

import com.ruoyi.flowable.listener.GlobalEventListener;
import org.flowable.common.engine.api.delegate.event.FlowableEngineEventType;
import org.flowable.engine.RuntimeService;
import org.springframework.context.ApplicationListener;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.event.ContextRefreshedEvent;

/**
 * flowable全局监听配置
 *
 * @author ssc
 */
@Configuration
public class GlobalEventListenerConfig implements ApplicationListener<ContextRefreshedEvent> {

	private RuntimeService runtimeService;
	private GlobalEventListener globalEventListener;

	@Bean
	public GlobalEventListener globalEventListener(RuntimeService runtimeService) {
		this.runtimeService = runtimeService;
		this.globalEventListener = new GlobalEventListener(runtimeService);
		return this.globalEventListener;
	}

	@Override
	public void onApplicationEvent(ContextRefreshedEvent event) {
		if (runtimeService != null && globalEventListener != null) {
			runtimeService.addEventListener(globalEventListener, FlowableEngineEventType.PROCESS_COMPLETED);
		}
	}
}
