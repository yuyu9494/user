package com.example.member.repository;

import com.example.member.entity.Member;

public interface MemberRepositoryOverride {
	Member loginMember(Member members);
	
	long idCheck(Member members);
}
