package com.olympics.mvc.util;

import org.springframework.web.multipart.MultipartFile;

public class FileValidator {
	
	/**
	 * 파일 확장자 확인
	 * @param file 사용자가 등록한 file
	 */
	public static void isValidImageFile(MultipartFile file) {
		
		// 1. 파일 확장자 확인
        String fileName = file.getOriginalFilename();
        if (fileName == null || !(fileName.toLowerCase().endsWith(".jpg") || fileName.toLowerCase().endsWith(".png"))) {
            throw new IllegalArgumentException("jpg 또는 png 파일만 업로드 가능합니다.");
        }
        
        // 2. MIME 타입 확인
		String contentType = file.getContentType();
        if (!"image/jpeg".equals(contentType) && !"image/png".equals(contentType)) {
            throw new IllegalArgumentException("jpg 또는 png 파일만 업로드 가능합니다.");
        }
	}
}
