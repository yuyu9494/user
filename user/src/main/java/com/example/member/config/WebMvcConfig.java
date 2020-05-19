package com.example.member.config;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.example.member.filter.SimpleCorsFilter;
import com.querydsl.jpa.impl.JPAQueryFactory;

@Configuration
public class WebMvcConfig {
	private static final Logger logger = LoggerFactory.getLogger(WebMvcConfig.class);
	
	@Autowired
	private ApplicationContext context;
	
	/**
	 * CORS filter 적용
	 * 
	 * @return
	 */
	@Bean
	public FilterRegistrationBean<SimpleCorsFilter> simpleCorsFilter() {
		FilterRegistrationBean<SimpleCorsFilter> bean = new FilterRegistrationBean<SimpleCorsFilter>();
		bean.setFilter(new SimpleCorsFilter());
		bean.addUrlPatterns("/*");

		return bean;
	}
	
	/**
	 *  EntityManager & JPAQueryFactory
	 */
	@PersistenceContext
	EntityManager em;
	
	@Bean
	public JPAQueryFactory queryFactory() {
	//return new JPAQueryFactory(JPQLTemplates.DEFAULT, em);
	return new JPAQueryFactory(em);
	}
}
