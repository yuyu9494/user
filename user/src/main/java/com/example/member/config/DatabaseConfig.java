//package com.example.member.config;
//
//import java.io.IOException;
//
//import javax.sql.DataSource;
//
//import org.apache.ibatis.session.SqlSessionFactory;
//import org.apache.ibatis.type.JdbcType;
//import org.mybatis.spring.SqlSessionFactoryBean;
//import org.mybatis.spring.SqlSessionTemplate;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.beans.factory.annotation.Qualifier;
//import org.springframework.context.ApplicationContext;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.jdbc.datasource.DataSourceTransactionManager;
//
//import com.example.member.type.CamelCaseMap;
//
//@Configuration
//public class DatabaseConfig {
//	private static final Logger logger = LoggerFactory.getLogger(DatabaseConfig.class);
//	
//	@Autowired
//	private DataSource dataSource;
//	
//	@Bean(name = "sqlSessionFactoryBean")
//	public SqlSessionFactoryBean mainSqlSessionFactoryBean(DataSource dataSource,
//			ApplicationContext applicationContext) throws IOException {
//
//		// MyBatis 설정
//		org.apache.ibatis.session.Configuration configuration = new org.apache.ibatis.session.Configuration();
//		// callSettersOnNulls: 가져온 값이 null일때 setter나 맵의 put 메소드를 호출할지를 명시 Map.keySet()
//		// 이나 null값을 초기화할때 유용하다.
//		// int, boolean 등과 같은 원시타입은 null을 설정할 수 없다는 점은 알아두면 좋다
//		configuration.setCallSettersOnNulls(true);
//		// jdbcTypeForNull: JDBC타입을 파라미터에 제공하지 않을때 null값을 처리한 JDBC타입을 명시한다.
//		// 일부 드라이버는 칼럼의 JDBC타입을 정의하도록 요구하지만 대부분은 NULL, VARCHAR 나 OTHER 처럼 일반적인 값을 사용해서
//		// 동작한다.
//		configuration.setJdbcTypeForNull(JdbcType.VARCHAR);
//		// org.apache.ibatis.type.TypeAliasRegistry 참조
//		configuration.getTypeAliasRegistry().registerAlias("camelcasemap", CamelCaseMap.class);
//		//configuration.getTypeAliasRegistry().registerAlias(CamelCaseMap.class);
//		// mapUnderscoreToCamelCase: 전통적인 데이터베이스 칼럼명 형태인 A_COLUMN을 CamelCase형태의 자바 프로퍼티명 형태인 aColumn으로 자동으로 매핑하도록 함
//		// 이건 자바 객체를 만들었을때 적용된다.
//		//configuration.setMapUnderscoreToCamelCase(true);
//
//		// MyBatis SqlSessionFactory 생성,
//		// FactoryBean의 Type이 SqlSessionFactory.. getObject()를 찾아 추적해보면
//		// org.apache.ibatis.session.defaults.DefaultSqlSessionFactory 를 생성시키는것을 확인할 수
//		// 있다.
//		SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
//		sqlSessionFactoryBean.setDataSource(dataSource);
//		sqlSessionFactoryBean.setConfiguration(configuration);
//		//sqlSessionFactoryBean.setTypeAliasesPackage("kr.co.starlabs.model");
//		//sqlSessionFactoryBean.setTypeAliases(new Class<?>[] { Message.class, Device.class });
//		//sqlSessionFactoryBean.setTypeAliases(new Class<?>[] { Memo.class });
//		//sqlSessionFactoryBean.setTypeAliases(new Class<?>[] { CamelCaseMap.class });
//		
//		//sqlSessionFactoryBean.setMapperLocations(applicationContext.getResources("classpath:kr/co/starlabs/dao/member/Member.xml"));
//		sqlSessionFactoryBean.setMapperLocations(applicationContext.getResources("classpath:com/example/member/dao/MemberMapper.xml"));
//
//		return sqlSessionFactoryBean;
//	}
//	
//	@Bean(name = "sqlSessionTemplate")
//	public SqlSessionTemplate mainSqlSessionTemplate(
//			@Qualifier("sqlSessionFactoryBean") SqlSessionFactory sqlSessionFactory) {
//		return new SqlSessionTemplate(sqlSessionFactory);
//	}
//
//	// @Transactional(value="transactionManager") 사용하기 위해
//	@Bean(name = "transactionManager")
//	// @Qualifier("transactionManager")
//	public DataSourceTransactionManager dataSourceTransactionManager() {
//		return new DataSourceTransactionManager(dataSource);
//	}
//}
