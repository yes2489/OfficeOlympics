# Office Olympics - 댓글 시스템

## 목차
- [Office Olympics - 댓글 시스템](#office-olympics---댓글-시스템)
  - [목차](#목차)
  - [1. 기본 구조 이해하기](#1-기본-구조-이해하기)
    - [1.1 기본 사용법](#11-기본-사용법)
    - [1.2 주요 개념](#12-주요-개념)
    - [1.3 유용한 팁](#13-유용한-팁)
  - [2. 개요](#2-개요)
  - [3. 댓글 상태 관리 (Comment Store)](#3-댓글-상태-관리-comment-store)
    - [3.1 기본 구조](#31-기본-구조)
    - [3.2 주요 기능](#32-주요-기능)
  - [4. 댓글 CRUD 기능](#4-댓글-crud-기능)
    - [4.1 댓글 조회](#41-댓글-조회)
    - [4.2 댓글 작성](#42-댓글-작성)
    - [4.3 댓글 수정](#43-댓글-수정)
    - [4.4 댓글 삭제](#44-댓글-삭제)
  - [5. 댓글 컴포넌트 (Comments.vue)](#5-댓글-컴포넌트-commentsvue)
    - [5.1 주요 기능](#51-주요-기능)
    - [5.2 데이터 구조](#52-데이터-구조)
  - [6. 답글 기능](#6-답글-기능)
    - [6.1 답글 구조](#61-답글-구조)
    - [6.2 답글 표시](#62-답글-표시)
  - [7. 오류 처리](#7-오류-처리)
  - [8. 성능 최적화](#8-성능-최적화)

## 1. 기본 구조 이해하기

### 1.1 기본 사용법
1. 댓글 작성하기
   - 텍스트 입력
   - "등록" 버튼 클릭
   
2. 답글 작성하기
   - "답글 달기" 버튼 클릭
   - 답글 입력
   - "등록" 버튼 클릭

3. 댓글 수정하기
   - "수정" 버튼 클릭
   - 내용 수정
   - "저장" 버튼 클릭

### 1.2 주요 개념
1. **상태 관리**
   - Pinia store로 댓글 데이터 관리
   - 실시간 업데이트

2. **컴포넌트 구조**
   - Comments.vue: 메인 댓글 컴포넌트
   - CommentItem.vue: 개별 댓글 표시
   - CommentForm.vue: 댓글 입력 폼

3. **데이터 흐름**
```
사용자 입력 → Comment Store → API 요청 → 데이터 업데이트 → UI 반영
```

### 1.3 유용한 팁
- 댓글 작성 전 로그인 필요
- 자신의 댓글만 수정/삭제 가능
- 답글은 한 단계까지만 가능
- 긴 댓글은 자동으로 줄바꿈

## 2. 개요
댓글 시스템은 사용자들이 챌린지에 대해 자유롭게 소통할 수 있는 기능을 제공합니다. 기본적인 CRUD(생성, 읽기, 수정, 삭제) 기능과 답글 기능을 포함하고 있습니다.

## 3. 댓글 상태 관리 (Comment Store)

### 3.1 기본 구조
Pinia store를 활용하여 댓글 상태를 효율적으로 관리합니다:

```32:36:office-olympics-fe/src/stores/comment.js
  state: () => ({
    comments: [],
    loading: false,
    error: null
  }),
```

### 3.2 주요 기능
1. **댓글 조회**: 특정 챌린지의 모든 댓글을 가져옵니다. (사용 컴포넌트: `Comments.vue`)
2. **댓글 작성**: 새로운 댓글을 추가합니다. (사용 컴포넌트: `CommentForm.vue`)
3. **댓글 수정**: 기존 댓글을 수정합니다. (사용 컴포넌트: `CommentItem.vue`)
4. **댓글 삭제**: 댓글을 삭제합니다. (사용 컴포넌트: `CommentItem.vue`)

## 4. 댓글 CRUD 기능

### 4.1 댓글 조회

```55:78:office-olympics-fe/src/stores/comment.js
    async fetchComments(challengeId) {
      try {
        this.loading = true;
        const response = await getChallengeComments(challengeId);
        this.comments = response.data.map(comment => ({
          ...comment,
          commentId: comment.commentId,
          commentGroup: comment.commentGroup,
          commentDepth: comment.commentDepth,
          commentText: comment.commentText,
          regDate: comment.regDate,
          updateDate: comment.updateDate,
          nickname: comment.nickname,
          userId: comment.userId,
          imgSrc: comment.imgSrc
        }));
        console.log('Mapped comments:', this.comments);
      } catch (error) {
        this.setError(error.response?.data || '댓글을 불러오는데 실패했습니다');
        throw error;
      } finally {
        this.loading = false;
      }
    },
```

### 4.2 댓글 작성

```86:95:office-olympics-fe/src/stores/comment.js
    async addComment(challengeId, commentData) {
      try {
        const response = await addChallengeComment(challengeId, commentData);
        await this.fetchComments(challengeId);
        return response.data;
      } catch (error) {
        this.setError(error.response?.data || '댓글 추가에 실패했습니다');
        throw error;
      }
    },
```

### 4.3 댓글 수정

```104:114:office-olympics-fe/src/stores/comment.js
    async updateComment(challengeId, commentId, commentData) {
      try {
        const response = await updateChallengeComment(challengeId, commentId, commentData);
        await this.fetchComments(challengeId);
        return response.data;
      } catch (error) {
        const message = handleApiError(error);
        this.setError(message);
        throw error;
      }
    },
```

### 4.4 댓글 삭제

```122:132:office-olympics-fe/src/stores/comment.js
    async deleteComment(challengeId, commentId) {
      try {
        const response = await deleteChallengeComment(challengeId, commentId);
        await this.fetchComments(challengeId);
        return response.data;
      } catch (error) {
        const message = handleApiError(error);
        this.setError(message);
        throw error;
      }
    },
```

## 5. 댓글 컴포넌트 (Comments.vue)

### 5.1 주요 기능
- 댓글 목록 표시 (사용 컴포넌트: `Comments.vue`)
- 댓글 작성 폼 (사용 컴포넌트: `CommentForm.vue`)
- 답글 작성 기능 (사용 컴포넌트: `CommentItem.vue`)
- 수정/삭제 버튼 (사용 컴포넌트: `CommentItem.vue`)
- 로딩 상태 표시 (사용 컴포넌트: `Comments.vue`)
- 에러 처리 (사용 컴포넌트: `Comments.vue`)

### 5.2 데이터 구조
```javascript
댓글 객체 = {
  commentId: number,      // 댓글 식별자
  commentGroup: number,   // 답글 그룹
  commentDepth: number,   // 답글 깊이
  commentText: string,    // 댓글 내용
  regDate: string,       // 작성일
  updateDate: string,    // 수정일
  nickname: string,      // 작성자 닉네임
  userId: number,        // 작성자 ID
  imgSrc: string        // 프로필 이미지
}
```

## 6. 답글 기능

### 6.1 답글 구조
- commentGroup: 같은 그룹의 답글들을 묶음
- commentDepth: 답글의 깊이 (0: 원댓글, 1: 답글)

### 6.2 답글 표시
- 들여쓰기로 계층 구조 표현
- 원댓글과 구분되는 스타일링
- "답글 달기" 버튼으로 답글 작성 UI 토글

## 7. 오류 처리
- 네트워크 오류
- 권한 부족
- 입력값 유효성 검사
- 서버 오류

## 8. 성능 최적화
- 댓글 페이지네이션
- 답글 지연 로딩
- 캐싱 전략
- 불필요한 리렌더링 방지
