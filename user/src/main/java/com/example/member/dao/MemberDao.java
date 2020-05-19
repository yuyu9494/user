package com.example.member.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

@Repository
public class MemberDao {
	
	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSessionTemplate sqlSessionTemplate;
	
	private static final String NAMESPACE = "com.example.member.dao.MemberMapper.";
	
	public List<Map<String, String>> getMemberList() {
		return sqlSessionTemplate.selectList(NAMESPACE.concat("getMemberList"));
	}
	
	public int insertMember(Map<String, Object> body) {
		return sqlSessionTemplate.insert(NAMESPACE.concat("insertMember"), body);
	}
}
