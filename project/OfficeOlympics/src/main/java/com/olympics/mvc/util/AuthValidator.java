package com.olympics.mvc.util;

import jakarta.servlet.http.HttpSession;

public class AuthValidator {
	/**
     * 현재 userId와 세션 내 userId 일치 여부 검증 로직
     * 
     * @param session 현재 사용자 세션
     * @param userId  검증할 사용자 ID
     */
    public static void isSameUserAsSession(HttpSession session, int userId) {
    	Integer sessionUserId = (Integer) session.getAttribute("loginUserId");
    	if (sessionUserId == null || !sessionUserId.equals(userId)){
            throw new RuntimeException("인증된 사용자가 아닙니다.");
        }
    }
}
