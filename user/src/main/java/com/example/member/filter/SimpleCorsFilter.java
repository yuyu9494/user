package com.example.member.filter;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.filter.OncePerRequestFilter;

public class SimpleCorsFilter extends OncePerRequestFilter {
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException {

		HttpServletResponse res = (HttpServletResponse) response;
		HttpServletRequest req = (HttpServletRequest) request;

		// Simple Request가 아니고 요청 URL이 외부 도메인일 경우 웹 브라우저는 preflight 요청을 먼저 날린다. preflight 요청은 실제로 요청하려는 경로와
		// 같은 URL에 대해 OPTIONS 메소드를 미리 날려 요청할 수 있는 권한이 있는지 확인한다. 서버로 넘어온 preflight 요청을
		// 처리하여 웹 브라우저에서 실제 요청을 날릴 수 있도록 접근 허용 설정을 해줘야 한다. 권한이 없으면 에러를 발생시키고 권한이 있으면 실제
		// 요청을 처리 해준다.

		// 요청을 허용하는 출처. * 인 경우, 모든 도메인의 요청을 허용한다.
		res.setHeader("Access-Control-Allow-Origin", "*");
		// res.addHeader("Access-Control-Allow-Origin", "http://s1.test.co.kr");
		// res.addHeader("Access-Control-Allow-Origin", "http://s2.test.co.kr");
		// 요청을 허용하는 메소드 종류. 헤더 값에 해당하는 메소드만 접근 허용한다. (default : GET, POST)
		res.setHeader("Access-Control-Allow-Methods", "GET, POST, DELETE, PUT, PATCH, OPTIONS");
		// 요청을 허용하는 헤더 이름, preflight 요청시 다음 실제요청에서 다음값을 요구하겠다고 알린다.
		res.setHeader("Access-Control-Allow-Headers",
				"Origin, X-Requested-With, Content-Type, Accept, Accept-Encoding, Accept-Language, Host, Referer, Connection, User-Agent, Authorization");
		// 브라우저 측에서 접근할 수 있게 허용해주는 헤더
		res.setHeader("Access-Control-Expose-Headers", "Authorization");

		// preflighted 요청은 특별한 목적을 가지는 요청으로 method = OPTIONS 으로 전송
		if (req.getMethod().equals("OPTIONS")) {
			res.setStatus(HttpServletResponse.SC_OK);
			return;
		}
		filterChain.doFilter(request, response);
	}
}
