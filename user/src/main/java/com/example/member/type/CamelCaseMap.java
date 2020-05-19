package com.example.member.type;

import java.util.HashMap;

import org.springframework.jdbc.support.JdbcUtils;

public class CamelCaseMap extends HashMap {
	public Object put(Object key, Object value) {
		
		return super.put(JdbcUtils.convertUnderscoreNameToPropertyName((String)key), value);
	}
}
