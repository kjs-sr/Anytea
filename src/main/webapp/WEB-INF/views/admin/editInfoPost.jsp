<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>정보글 수정</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.css" rel="stylesheet">
</head>
<body class="bg-gray-100 p-8">
    <div class="max-w-4xl mx-auto bg-white p-8 rounded-lg shadow-md">
        <h1 class="text-3xl font-bold mb-6 border-b pb-4">정보글 수정</h1>
        
        <form action="${pageContext.request.contextPath}/editInfoPost" method="post" class="space-y-6">
            
            <input type="hidden" name="info_no" value="${post.infoNo}">

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div>
                    <label for="division" class="block text-sm font-medium text-gray-700">정보 글 구분</label>
                    <select id="division" name="division" class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
                        <option value="INTRO" ${post.division == 'INTRO' ? 'selected' : ''}>INTRO</option>
                        <option value="INFO" ${post.division == 'INFO' ? 'selected' : ''}>INFO</option>
                    </select>
                </div>
                <div>
                    <label for="tag_tea" class="block text-sm font-medium text-gray-700">차 태그</label>
                    <select id="tag_tea" name="tag_tea" class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
                        <option value="녹차" ${post.tagTea == '녹차' ? 'selected' : ''}>녹차</option>
                        <option value="청차" ${post.tagTea == '청차' ? 'selected' : ''}>청차</option>
                        <option value="홍차" ${post.tagTea == '홍차' ? 'selected' : ''}>홍차</option>
                        <option value="흑차" ${post.tagTea == '흑차' ? 'selected' : ''}>흑차</option>
                        <option value="백차" ${post.tagTea == '백차' ? 'selected' : ''}>백차</option>
                        <option value="대용차" ${post.tagTea == '대용차' ? 'selected' : ''}>대용차</option>
                    </select>
                </div>
                <div>
                    <label for="tag_region" class="block text-sm font-medium text-gray-700">지역 태그</label>
                    <select id="tag_region" name="tag_region" class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
                        <option value="" ${empty post.tagRegion ? 'selected' : ''}>-- 선택 안함 --</option>
                        <option value="아시아" ${post.tagRegion == '아시아' ? 'selected' : ''}>아시아</option>
                        <option value="유럽" ${post.tagRegion == '유럽' ? 'selected' : ''}>유럽</option>
                        <option value="아프리카" ${post.tagRegion == '아프리카' ? 'selected' : ''}>아프리카</option>
                        <option value="아메리카" ${post.tagRegion == '아메리카' ? 'selected' : ''}>아메리카</option>
                    </select>
                </div>
            </div>

            <div>
                <label for="title" class="block text-sm font-medium text-gray-700">제목</label>
                <input type="text" id="title" name="title" value="${post.title}" class="mt-1 block w-full py-2 px-3 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm" required>
            </div>

            <div>
                <label for="contents" class="block text-sm font-medium text-gray-700">내용</label>
                <textarea id="summernote" name="contents">${post.contents}</textarea>
            </div>

            <div>
                <label for="image_addr" class="block text-sm font-medium text-gray-700">이미지 경로 (파일명.확장자)</label>
                <input type="text" id="image_addr" name="image_addr" value="${post.imageAddr}" class="mt-1 block w-full py-2 px-3 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm" required>
            </div>

            <div class="flex justify-end space-x-4">
                 <a href="${pageContext.request.contextPath}/editInfoPost" class="bg-gray-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded">
                    목록으로
                </a>
                <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded">
                    수정하기
                </button>
            </div>
        </form>
    </div>

    <script>
        $(document).ready(function() {
            $('#summernote').summernote({
                height: 400,
                lang: "ko-KR",
                toolbar: [
                    ['style', ['style']],
                    ['font', ['bold', 'underline', 'clear']],
                    ['color', ['color']],
                    ['para', ['ul', 'ol', 'paragraph']],
                    ['table', ['table']],
                    ['insert', ['link', 'picture', 'video']],
                    ['view', ['fullscreen', 'codeview', 'help']]
                ]
            });
        });
    </script>
</body>
</html>
