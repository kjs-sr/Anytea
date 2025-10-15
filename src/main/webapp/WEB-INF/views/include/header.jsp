<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- 
    [최종 수정본]
    이 파일은 웹사이트의 헤더 및 모든 공통 CSS를 담당합니다.
    - 모든 배너가 초기에 보이지 않도록 수정되었습니다.
--%>
<%
    long timestamp = System.currentTimeMillis();
%>
<style>
    /* Global Styles */
    body { 
        font-family: 'Noto Sans KR', sans-serif; 
    }

    /* Accordion Menu Styles */
    .accordion-content {
        display: grid;
        grid-template-rows: 0fr;
        transition: grid-template-rows 300ms ease-in-out;
        overflow: hidden;
    }
    .accordion-content.is-open {
        grid-template-rows: 1fr;
    }
    .accordion-content > div {
        overflow: hidden;
        min-height: 0;
    }
    .arrow-icon {
        transition: transform 300ms ease-in-out;
    }
    .arrow-icon.rotate-180 {
        transform: rotate(180deg);
    }
    
    /* Header Animation Styles */
    @keyframes continuous-pan-extended {
        0%   { transform: scale(1.2) translate(0, 0); }
        25%  { transform: scale(1.2) translate(-8%, 8%); }
        50%  { transform: scale(1.2) translate(8%, -8%); }
        75%  { transform: scale(1.2) translate(5%, 7%); }
        100% { transform: scale(1.2) translate(0, 0); }
    }
    
    @keyframes logo-spin {
        from { transform: rotate(20deg); }
        to   { transform: rotate(380deg); } /* 20deg + 360deg */
    }
    .animate-logo-spin {
        animation: logo-spin 15s linear infinite;
    }
    
    .animate-continuous-pan {
        animation: continuous-pan-extended 50s ease-in-out infinite;
    }
    #header-slideshow {
        background-color: #e4f0e2;
    }
</style>

<header class="relative">
    <div id="header-slideshow" class="h-96 overflow-hidden relative">
        <%-- [수정] 첫 번째 배너의 opacity-100을 opacity-0으로 변경 --%>
        <div class="header-slide absolute top-0 left-0 w-full h-full bg-cover bg-center transition-opacity duration-1000 ease-in-out opacity-0" 
             style="background-image: url('${pageContext.request.contextPath}/resources/images/banner1.jpg?v=<%= timestamp %>')"></div>
        <div class="header-slide absolute top-0 left-0 w-full h-full bg-cover bg-center transition-opacity duration-1000 ease-in-out opacity-0" 
             style="background-image: url('${pageContext.request.contextPath}/resources/images/banner2.jpg?v=<%= timestamp %>')"></div>
        <div class="header-slide absolute top-0 left-0 w-full h-full bg-cover bg-center transition-opacity duration-1000 ease-in-out opacity-0" 
             style="background-image: url('${pageContext.request.contextPath}/resources/images/banner3.jpg?v=<%= timestamp %>')"></div>
        <div class="header-slide absolute top-0 left-0 w-full h-full bg-cover bg-center transition-opacity duration-1000 ease-in-out opacity-0" 
             style="background-image: url('${pageContext.request.contextPath}/resources/images/banner4.jpg?v=<%= timestamp %>')"></div>
        <div class="header-slide absolute top-0 left-0 w-full h-full bg-cover bg-center transition-opacity duration-1000 ease-in-out opacity-0" 
             style="background-image: url('${pageContext.request.contextPath}/resources/images/banner5.jpg?v=<%= timestamp %>')"></div>
        <div class="header-slide absolute top-0 left-0 w-full h-full bg-cover bg-center transition-opacity duration-1000 ease-in-out opacity-0" 
             style="background-image: url('${pageContext.request.contextPath}/resources/images/banner6.jpg?v=<%= timestamp %>')"></div>
    </div>
    
    <div class="absolute top-4 left-4 bg-white bg-opacity-80 p-6 rounded-lg shadow-md z-10">
        <a href="${pageContext.request.contextPath}/" 
           id="logo-link"
           class="group text-4xl font-bold text-green-700 flex items-center transition-colors duration-300 hover:text-green-500">
            <img src="${pageContext.request.contextPath}/resources/images/logo_icon.png" 
                 id="logo-image"
                 alt="여차저차 로고 아이콘" 
                 class="h-10 w-10 mr-3 transition-transform duration-300 ease-in-out">
            <span>여차저차</span>
        </a>
    </div>
</header>

