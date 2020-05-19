package com.example.member.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;

import com.example.member.entity.Member;

public interface MemberRepository extends JpaRepository<Member, String>, MemberRepositoryOverride, QuerydslPredicateExecutor<Member>{

}
