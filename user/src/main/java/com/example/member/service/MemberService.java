package com.example.member.service;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.member.entity.Member;
import com.example.member.repository.MemberRepository;

@Service
public class MemberService {
	private static final Logger logger = LoggerFactory.getLogger(MemberService.class);
	
	@Autowired
	private MemberRepository memberRepository;
	
	// 목록
	public List<Member> getMemberAll() {
		return memberRepository.findAll();
	}
	
	// 로그인
	public Member loginMember(Member members) {
		return memberRepository.loginMember(members);
	}
	
	// 아이디 중복 확인
	public long idCheck(Member members) {
		return memberRepository.idCheck(members);
//		Optional<Member> memberid = memberRepository.findById(id);
//		return memberRepository.getOne(memberid);
	}
	
	// 작성
	public Member insertMember(Member member) {
		return memberRepository.save(member);
	}
	
	// 수정
	public void updateMember(String id, Member member) {
		Optional<Member> memberid = memberRepository.findById(id);
		
		memberid.ifPresent(selectMember -> {
			selectMember.setId(member.getId());
			selectMember.setPassword(member.getPassword());
			selectMember.setName(member.getName());
			selectMember.setZipcode(member.getZipcode());
			selectMember.setAddress1(member.getAddress1());
			selectMember.setAddress2(member.getAddress2());
			
			memberRepository.save(selectMember);
		});
	}
	
	// 삭제
	public void deleteMember(String id) {
		memberRepository.deleteById(id);
	}
	
	
	// findById
	public void findById(String id) {
		memberRepository.findById(id);
	}
}
