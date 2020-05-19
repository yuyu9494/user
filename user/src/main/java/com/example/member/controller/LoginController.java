//package com.example.member.controller;
//
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpSession;
//
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Controller;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RestController;
//import org.springframework.web.servlet.ModelAndView;
//import org.springframework.web.servlet.mvc.support.RedirectAttributes;
//
//import com.example.member.entity.Member;
//import com.example.member.service.MemberService;
//
//@Controller
//public class LoginController {
//	
//	private static final Logger logger = LoggerFactory.getLogger(MemberContoller.class);
//	
//	@Autowired
//	private MemberService memberService;
//	
//	/**
//	 * 로그인
//	 */
//	@GetMapping("/login")
//	public void login() {
//		// 로그인 페이지 이동
//	}
//	
//	@PostMapping("/login")
//	public ModelAndView login(Member members, HttpServletRequest req, RedirectAttributes rttr) throws Exception{
//		logger.info("post login");
//		
//		HttpSession session = req.getSession();
//		
//		Member login = memberService.loginMember(members);
//		
//		if(login == null) {
//			session.setAttribute("member", null);
//			rttr.addFlashAttribute("msg", false);
//		}else {
//			session.setAttribute("member", login);
//		}
//		
//		return new ModelAndView("redirect:/login");
//	}
//	
//	@GetMapping("/logout")
//	public String logout(HttpSession session) throws Exception {
//		session.invalidate();
//		
//		return "redirect:/login";
//	}
//	
//	/**
//	 * 회원 정보 수정
//	 */
//	@GetMapping("/update")
//	public String updateView() throws Exception {
//		return "update";
//	}
//	
//	@PostMapping("/update")
//	public String updateMember(String id, Member member, HttpSession session) throws Exception {
//		memberService.updateMember(id, member);
//		
//		session.invalidate();
//		
//		return "redirect:/login";
//	}
//}
