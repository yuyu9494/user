package com.example.member.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.member.entity.Member;
import com.example.member.service.MemberService;
import com.example.member.vo.PageVO;
import com.example.member.vo.zip_codeVO;
import com.google.gson.Gson;

@RestController
public class MemberContoller {

	// 인증키
	public static final String ZIPCODE_API_KEY = "cb17126a123cd7fb81586688111998";
	// api를 쓰기 위한 주소
	// http://biz.epost.go.kr/KpostPortal/openapi2 - 인코딩 : UTF-8
	public static final String ZIPCODE_API_URL = "http://biz.epost.go.kr/KpostPortal/openapi2";

	private static final Logger logger = LoggerFactory.getLogger(MemberContoller.class);

	@Autowired
	private MemberService memberService;

	/**
	 * 로그인
	 * 
	 * @return
	 */
	@GetMapping("/login")
	public ModelAndView login(ModelAndView model) {
		System.out.println("login view controller");
		model.setViewName("login");
		return model;
	}

	@PostMapping("/login")
	public ModelAndView login(Member members, HttpServletRequest req, RedirectAttributes rttr) throws Exception {
		logger.info("post login");

		HttpSession session = req.getSession();

		Member login = memberService.loginMember(members);

		if (login == null) {
			session.setAttribute("member", null);
			rttr.addFlashAttribute("msg", false);
		} else {
			session.setAttribute("member", login);
		}

		return new ModelAndView("redirect:/login");
	}

	@GetMapping("/logout")
	public ModelAndView logout(HttpSession session) throws Exception {
		session.invalidate();

		return new ModelAndView("redirect:/login");
	}

	/**
	 * 회원 정보 수정
	 */
	@GetMapping("/update")
	public ModelAndView updateView() throws Exception {
		return new ModelAndView("update");
	}

	@PostMapping("/update")
	public ModelAndView updateMember(String id, Member member, HttpSession session) throws Exception {
		memberService.updateMember(id, member);
		session.setAttribute("member", member); // session에 수정된 회원 정보값을 저장

//		memberService.updateMember(id, member);
//		session.invalidate();

		return new ModelAndView("redirect:/login");
	}

	/**
	 * 회원 탈퇴
	 */
	@PostMapping("/delete")
	public ModelAndView deleteMember(String id, HttpSession session) throws Exception {
		memberService.deleteMember(id);
		session.invalidate();

//		Member member = (Member)session.getAttribute("member");
//		
//		if(member != null) {
//			System.out.println(member.toString());
//		}

		return new ModelAndView("redirect:/login");
	}
	
//	@GetMapping("/listup")
//	public String listUpdate(@RequestParam("id") String id, Member member) throws Exception {
//		memberService.updateMember(id, member);
//		member = memberService.findById(id).get();
//	}
	
	@GetMapping("/listdel")
	public ModelAndView listDelete(@RequestParam("id") String id) throws Exception {
		memberService.deleteMember(id);
		return new ModelAndView("redirect:/list");
	}
	
	

	@GetMapping("/list")
	public ModelAndView memberList() {

		ModelAndView model = new ModelAndView("list");
		List<Member> memberList = memberService.getMemberAll();
		model.addObject("member", memberList);

		return model;
	}

	@GetMapping("/signup")
	public ModelAndView signupMember() {

		ModelAndView model = new ModelAndView();

		Member member = new Member();
		model.addObject("memberForm", member);
		model.setViewName("signup");

		return model;
	}

	@Transactional
	@PostMapping("/signup")
	public ModelAndView insertMember(@ModelAttribute("memberForm") Member member) throws Exception {
		logger.info("post sign up");

		long result = memberService.idCheck(member);

		try {
			if (result == 1) {
				return new ModelAndView("/signup");
			} else if (result == 0) {
				memberService.insertMember(member);
			}
		} catch (Exception e) {
			throw new RuntimeException();
		}

//		memberService.insertMember(member);

		return new ModelAndView("redirect:/login");
	}

	@ResponseBody
	@PostMapping("/check")
	public long idCheck(Member members) throws Exception {

		long result = memberService.idCheck(members);

		logger.info("post id check", result);

		return result;
	}

	@RequestMapping(value = "/zip_codeList", method = RequestMethod.POST, produces = "text/planin;charset=UTF-8")
	public @ResponseBody String zip_codeList(@RequestParam("query") String query) throws Exception {
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		StringBuilder queryUrl = new StringBuilder();
		queryUrl.append(ZIPCODE_API_URL);
		queryUrl.append("?regkey=" + ZIPCODE_API_KEY + "&target=postNew&query=");
		queryUrl.append(query.replaceAll(" ", "")); // " " => "" 띄어쓰기 제거
		queryUrl.append("&countPerPage=50");

		// document 선언 : URL에 접속하여 결과를 받음
		Document document = Jsoup.connect(queryUrl.toString()).get();
		// errorCode 선언
		String errorCode = document.select("error_code").text();

		if (null == errorCode || "".equals(errorCode)) {
			Elements elements = document.select("item");
			Elements pageinfo = document.select("pageinfo");

			List<zip_codeVO> list = new ArrayList<zip_codeVO>();
			zip_codeVO zip_codeVO = null;

			for (Element element : elements) {
				zip_codeVO = new zip_codeVO();
				// postcd:우편번호
				zip_codeVO.setZipcode(element.select("postcd").text());
				// address:주소(도로명) *addrjibun:주소(지번)
				zip_codeVO.setAddress(element.select("address").text());

				list.add(zip_codeVO);
			}
			
			PageVO pageVO = new PageVO();
			pageVO.setTotalCount(pageinfo.select("totalCount").text());
			pageVO.setTotalPage(pageinfo.select("totalPage").text());
			pageVO.setCountPerPage(pageinfo.select("countPerPage").text());
			pageVO.setCurrentPage(pageinfo.select("currentPage").text());
			
			// list 결과 put
			paramMap.put("list", list);

			paramMap.put("plist", pageVO);
		} else {
			String errorMessage = document.select("message").text();
			paramMap.put("errorCode", errorCode);
			paramMap.put("errorMessage", errorMessage);
		}

		// Gson형태로 paramMap 리턴
		return (new Gson()).toJson(paramMap);
	}

}
