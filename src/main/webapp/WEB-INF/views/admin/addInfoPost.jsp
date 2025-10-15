<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>정보글 데이터 등록 (관리자용)</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <%-- Summernote 에디터 라이브러리 추가 --%>
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.css" rel="stylesheet">
</head>
<body class="bg-gray-100 p-8">
    <div class="max-w-4xl mx-auto bg-white p-8 rounded-lg shadow-md">
        <h1 class="text-2xl font-bold mb-6 text-center">정보글 등록 페이지</h1>

        <%-- 폼 데이터를 AddInfoPostController로 전송 --%>
        <form action="${pageContext.request.contextPath}/addInfoPost" method="post">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                <%-- 정보 글 구분 --%>
                <div>
                    <label for="division" class="block text-sm font-medium text-gray-700 mb-1">정보 글 구분</label>
                    <select id="division" name="division" required class="w-full p-2 border border-gray-300 rounded-md">
                        <option value="INTRO">INTRO (소개글)</option>
                        <option value="INFO" selected>INFO (일반 정보글)</option>
                    </select>
                </div>
                <%-- 차 태그 --%>
                <div>
                    <label for="tag_tea" class="block text-sm font-medium text-gray-700 mb-1">차 태그</label>
                    <select id="tag_tea" name="tag_tea" required class="w-full p-2 border border-gray-300 rounded-md">
                        <option value="녹차">녹차</option>
                        <option value="청차">청차</option>
                        <option value="홍차">홍차</option>
                        <option value="흑차">흑차</option>
                        <option value="백차">백차</option>
                        <option value="대용차">대용차</option>
                    </select>
                </div>
                <%-- 지역 태그 --%>
                <div>
                    <label for="tag_region" class="block text-sm font-medium text-gray-700 mb-1">지역 태그 (선택)</label>
                    <select id="tag_region" name="tag_region" class="w-full p-2 border border-gray-300 rounded-md">
                        <option value="">-- 선택 안함 --</option>
                        <option value="아시아">아시아</option>
                        <option value="유럽">유럽</option>
                        <option value="아프리카">아프리카</option>
                        <option value="아메리카">아메리카</option>
                        <option value="오세아니아">오세아니아</option>
                    </select>
                </div>
                 <%-- 이미지 경로 --%>
                <div>
                    <label for="image_addr" class="block text-sm font-medium text-gray-700 mb-1">이미지 경로 (파일명.확장자)</label>
                    <input type="text" id="image_addr" name="image_addr" required placeholder="예: green_tea.jpg" class="w-full p-2 border border-gray-300 rounded-md">
                </div>
            </div>

            <%-- 제목 --%>
            <div class="mb-6">
                <label for="title" class="block text-sm font-medium text-gray-700 mb-1">제목</label>
                <input type="text" id="title" name="title" required class="w-full p-2 border border-gray-300 rounded-md">
            </div>

            <%-- 내용 (Summernote 에디터) --%>
            <div class="mb-6">
                <label for="summernote" class="block text-sm font-medium text-gray-700 mb-1">내용</label>
                <textarea id="summernote" name="contents"></textarea>
            </div>

            <%-- 제출 버튼 --%>
            <div class="text-center">
                <button type="submit" class="bg-green-700 text-white font-bold py-2 px-6 rounded-md hover:bg-green-800 transition">
                    데이터 저장
                </button>
            </div>
        </form>
    </div>

    <script>
        // Summernote 에디터 초기화
        $(document).ready(function() {
            $('#summernote').summernote({
                height: 400,
                placeholder: '여기에 게시글 내용을 입력하세요...',
                lang: 'ko-KR' // 한글 지원
            });
        });
    </script>
</body>
</html>
