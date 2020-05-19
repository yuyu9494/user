package com.example.member.vo;

import lombok.Data;

@Data
public class PageVO {
	private String totalCount; // 검색 결과 전체 건수
	private String totalPage; // 검색 결과 전체 페이지 수
	private String countPerPage; // 페이지당 조회 건수
	private String currentPage; // 현재 조회 페이지
}
