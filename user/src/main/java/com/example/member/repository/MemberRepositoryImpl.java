package com.example.member.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.support.QuerydslRepositorySupport;

import com.example.member.entity.Member;
import com.example.member.entity.QMember;
import com.querydsl.jpa.impl.JPAQueryFactory;

public class MemberRepositoryImpl extends QuerydslRepositorySupport implements MemberRepositoryOverride {
	
	@Autowired
	private JPAQueryFactory jpaFactory;
	
	public MemberRepositoryImpl() {
		super(Member.class);
		// TODO Auto-generated constructor stub
	}
	
	public Member loginMember(Member members) {
		QMember member = QMember.member;
		
		return jpaFactory.selectFrom(member)
		.where(member.id.eq(members.getId()), member.password.eq(members.getPassword()))
		.fetchOne();
	}
	
	public long idCheck(Member members) {
		QMember member = QMember.member;
		
		return jpaFactory.select(member.id)
				.from(member)
				.where(member.id.eq(members.getId()))
				.fetchCount();
	}

}
