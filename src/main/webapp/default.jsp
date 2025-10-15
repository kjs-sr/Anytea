<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>여차저차 - 차 정보 공유 게시판</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
        }
        .accordion-content {
            display: grid;
            grid-template-rows: 0fr;
            transition: grid-template-rows 0.5s ease-in-out;
        }
        .accordion-content.is-open {
            grid-template-rows: 1fr;
        }
    </style>
</head>
<%--
    [수정 사항]
    flex, flex-col, min-h-screen 클래스를 추가하여 "Sticky Footer" 레이아웃을 구현합니다.
    이제 body는 flex 컨테이너가 되어 내부 요소를 수직으로 정렬하고, 최소한 화면 전체 높이를 차지합니다.
--%>
<body class="bg-gray-100 text-gray-800 flex flex-col min-h-screen">

    <%-- 헤더 파일을 포함합니다. --%>
    <jsp:include page="/WEB-INF/views/include/header.jsp" />

    <%--
        [수정 사항]
        flex-grow 클래스를 추가하여 이 div가 남은 수직 공간을 모두 차지하도록 합니다.
        이것이 푸터를 화면 맨 아래로 밀어내는 핵심적인 역할을 합니다.
    --%>
    <div class="w-full max-w-[2100px] mx-auto px-6 mt-8 flex-grow">
        <div class="flex justify-center gap-6">
            <%-- 메뉴 파일을 포함합니다. --%>
            <jsp:include page="/WEB-INF/views/include/menu.jsp" />

            <main class="min-w-0 lg:flex-1">
                <div class="bg-white p-8 rounded-lg shadow-md">
                    <h1 class="text-3xl font-bold">홈페이지 본문 영역</h1>
                    <p class="mt-4">이 공간에 웹사이트의 주요 콘텐츠가 표시됩니다.</p>
                    
                    <div class="space-y-4 mt-8 text-gray-500">
                        <p>더미 내용입니다.</p>
                        <div class="bg-gray-200 h-48 rounded-md flex items-center justify-center">Dummy Content 1</div>
                        <div class="bg-gray-200 h-48 rounded-md flex items-center justify-center">Dummy Content 2</div>
                        <div class="bg-gray-200 h-48 rounded-md flex items-center justify-center">Dummy Content 3</div>
                        <div class="bg-gray-200 h-48 rounded-md flex items-center justify-center">Dummy Content 4</div>
                        <div class="bg-gray-200 h-48 rounded-md flex items-center justify-center">Dummy Content 5</div>
                        <div class="bg-gray-200 h-48 rounded-md flex items-center justify-center">Dummy Content 6</div>
                        <div class="bg-gray-200 h-48 rounded-md flex items-center justify-center">Dummy Content 7</div>
                    </div>
                </div>
            </main>

            <div class="hidden lg:block w-44 flex-shrink-0"></div>
        </div>
    </div>

    <%-- 푸터 파일을 포함합니다. --%>
    <jsp:include page="/WEB-INF/views/include/footer.jsp" />

</body>
</html>

