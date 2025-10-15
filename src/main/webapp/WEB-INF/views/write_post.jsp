<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>커뮤니티 글 작성 - 여차저차</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.css" rel="stylesheet">
    <style> body { font-family: 'Noto Sans KR', sans-serif; } </style>
</head>
<body class="bg-gray-100 flex flex-col min-h-screen">

    <jsp:include page="/WEB-INF/views/include/header.jsp" />

    <%-- [수정] 메뉴가 없는 중앙 정렬 레이아웃으로 변경 --%>
    <div class="w-full max-w-[2100px] mx-auto px-6 mt-8 flex-grow">
        <div class="flex justify-center gap-6">
            <%-- 왼쪽 여백 --%>
            <div class="hidden lg:block w-44 flex-shrink-0"></div>

            <main class="min-w-0 lg:flex-1">
                <div class="bg-white p-8 rounded-lg shadow-md">
                    <h1 class="text-3xl font-bold mb-6 border-b pb-4">커뮤니티 글 작성</h1>
                
                    <form action="${pageContext.request.contextPath}/writePost" method="post" class="space-y-6">
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div>
                                <label for="tag_main" class="block text-sm font-medium text-gray-700">카테고리 <span class="text-red-500">*</span></label>
                                <select id="tag_main" name="tag_main" class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm" required>
                                    <option value="">-- 선택 --</option>
                                    <option value="정보">정보</option>
                                    <option value="추천">추천</option>
                                    <option value="리뷰">리뷰</option>
                                </select>
                            </div>
                             <div>
                                <label for="tag_tea" class="block text-sm font-medium text-gray-700">차 종류</label>
                                <select id="tag_tea" name="tag_tea" class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm">
                                    <option value="">-- 선택 안함 --</option>
                                    <option value="녹차">녹차</option>
                                    <option value="청차">청차</option>
                                    <option value="홍차">홍차</option>
                                    <option value="흑차">흑차</option>
                                    <option value="백차">백차</option>
                                    <option value="대용차">대용차</option>
                                </select>
                            </div>
                            <div>
                                <label for="tag_region" class="block text-sm font-medium text-gray-700">지역</label>
                                <select id="tag_region" name="tag_region" class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm">
                                    <option value="">-- 선택 안함 --</option>
                                    <option value="아시아">아시아</option>
                                    <option value="유럽">유럽</option>
                                    <option value="아메리카">아메리카</option>
                                    <option value="아프리카">아프리카</option>
                                </select>
                            </div>
                        </div>

                        <div>
                            <label for="title" class="block text-sm font-medium text-gray-700">제목 <span class="text-red-500">*</span></label>
                            <input type="text" id="title" name="title" class="mt-1 block w-full py-2 px-3 border border-gray-300 rounded-md shadow-sm" required>
                        </div>

                        <div>
                            <label for="contents" class="block text-sm font-medium text-gray-700">내용 <span class="text-red-500">*</span></label>
                            <textarea id="summernote" name="contents"></textarea>
                        </div>

                        <div class="flex justify-end space-x-4">
                             <a href="javascript:history.back()" class="bg-gray-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded">목록으로</a>
                            <button type="submit" class="bg-green-700 hover:bg-green-800 text-white font-bold py-2 px-4 rounded">작성하기</button>
                        </div>
                    </form>
                </div>
            </main>

            <%-- 오른쪽 여백 --%>
            <div class="hidden lg:block w-44 flex-shrink-0"></div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/include/footer.jsp" />
    
    <script>
        $(document).ready(function() {
            // [수정] Summernote 에디터에 placeholder 옵션 추가
            $('#summernote').summernote({
                height: 400,
                lang: "ko-KR",
                placeholder: '여기에 글 내용을 작성하세요...'
            });
        });
    </script>
</body>
</html>

