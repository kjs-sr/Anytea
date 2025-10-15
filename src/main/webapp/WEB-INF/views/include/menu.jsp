<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tea.dto.UserDTO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- 데스크탑용 메뉴 --%>
<aside class="hidden lg:block w-44 flex-shrink-0">
    <div class="sticky top-8 bg-white p-4 rounded-lg shadow-md">
        <div class="space-y-3 mb-6">
            <c:choose>
                <c:when test="${empty sessionScope.loginUser}">
                    <a href="${pageContext.request.contextPath}/login" class="block w-full text-center px-4 py-2 rounded-md transition text-sm bg-green-700 text-white hover:bg-green-800">로그인</a>
                    <a href="${pageContext.request.contextPath}/register" class="block w-full text-center px-4 py-2 rounded-md transition text-sm bg-gray-200 text-gray-800 hover:bg-gray-300">회원가입</a>
                </c:when>
                <c:otherwise>
                    <div class="text-center p-2">
                        <p class="font-bold text-gray-800 truncate">${sessionScope.loginUser.nickname}<span class="text-sm font-normal">님</span></p>
                        <p class="text-xs text-gray-500">환영합니다!</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/checkPassword?action=editProfile" class="block w-full text-center px-4 py-2 rounded-md transition text-sm bg-gray-200 text-gray-800 hover:bg-gray-300">회원정보 수정</a>
                    <a href="${pageContext.request.contextPath}/logout" class="block w-full text-center px-4 py-2 rounded-md transition text-sm bg-green-700 text-white hover:bg-green-800">로그아웃</a>
                </c:otherwise>
            </c:choose>
        </div>
        <nav class="flex flex-col space-y-1">
            <div>
                <button class="accordion-toggle font-medium text-gray-600 hover:text-green-700 p-2 rounded-md hover:bg-green-50 w-full flex justify-between items-center text-left text-base">
                    <span>차 정보</span>
                    <svg class="arrow-icon w-4 h-4 transition-transform duration-300" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" /></svg>
                </button>
                <div class="accordion-content ${not empty param.category or not empty param.region ? 'is-open' : ''}">
                    <div class="overflow-hidden">
                        <div class="pl-4 mt-2 space-y-1 border-l-2 border-green-100">
                             <div class="group/type">
                                <div class="text-base text-gray-500 hover:text-green-600 w-full text-left cursor-pointer p-2 rounded-md hover:bg-green-50"><span>차 종류</span></div>
                                <div class="grid ${not empty param.category ? 'grid-rows-[1fr]' : 'grid-rows-[0fr]'} group-hover/type:grid-rows-[1fr] transition-all duration-500 ease-in-out">
                                    <div class="overflow-hidden pl-4 mt-1 space-y-1 border-l-2 border-gray-100">
                                        <a href="${pageContext.request.contextPath}/teatype?category=녹차" class="block text-base p-2 rounded-md ${param.category == '녹차' ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">녹차</a>
                                        <a href="${pageContext.request.contextPath}/teatype?category=청차" class="block text-base p-2 rounded-md ${param.category == '청차' ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">청차</a>
                                        <a href="${pageContext.request.contextPath}/teatype?category=홍차" class="block text-base p-2 rounded-md ${param.category == '홍차' ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">홍차</a>
                                        <a href="${pageContext.request.contextPath}/teatype?category=흑차" class="block text-base p-2 rounded-md ${param.category == '흑차' ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">흑차</a>
                                        <a href="${pageContext.request.contextPath}/teatype?category=백차" class="block text-base p-2 rounded-md ${param.category == '백차' ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">백차</a>
                                        <a href="${pageContext.request.contextPath}/teatype?category=대용차" class="block text-base p-2 rounded-md ${param.category == '대용차' ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">대용차</a>
                                    </div>
                                </div>
                            </div>
                            <div class="group/region">
                                <div class="text-base text-gray-500 hover:text-green-600 w-full text-left cursor-pointer p-2 rounded-md hover:bg-green-50"><span>지역 별</span></div>
                                <div class="grid ${not empty param.region ? 'grid-rows-[1fr]' : 'grid-rows-[0fr]'} group-hover/region:grid-rows-[1fr] transition-all duration-500 ease-in-out">
                                     <div class="overflow-hidden pl-4 mt-1 space-y-1 border-l-2 border-gray-100">
                                        <a href="${pageContext.request.contextPath}/regiontype?region=아시아" class="block text-base p-2 rounded-md ${param.region == '아시아' ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">아시아</a>
                                        <a href="${pageContext.request.contextPath}/regiontype?region=유럽" class="block text-base p-2 rounded-md ${param.region == '유럽' ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">유럽</a>
                                        <a href="${pageContext.request.contextPath}/regiontype?region=아메리카" class="block text-base p-2 rounded-md ${param.region == '아메리카' ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">아메리카</a>
                                        <a href="${pageContext.request.contextPath}/regiontype?region=아프리카" class="block text-base p-2 rounded-md ${param.region == '아프리카' ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">아프리카</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="group">
                 <a href="${pageContext.request.contextPath}/community" class="font-medium p-2 rounded-md block text-base w-full text-left 
                    ${pageContext.request.servletPath == '/community' ? 'text-green-700 bg-green-50' : 'text-gray-600 hover:text-green-700 hover:bg-green-50'}">커뮤니티</a>
                 <%-- [수정] source 파라미터가 없을 때만 메뉴가 열리도록 수정 --%>
                 <div class="grid ${not empty param.tag_main and empty param.source ? 'grid-rows-[1fr]' : 'grid-rows-[0fr]'} group-hover:grid-rows-[1fr] transition-all duration-500 ease-in-out">
                    <div class="overflow-hidden">
                        <div class="pl-4 mt-2 space-y-1 border-l-2 border-green-100">
                             <%-- [수정] source 파라미터가 없을 때만 하이라이트 되도록 수정 --%>
                             <a href="${pageContext.request.contextPath}/community?tag_main=정보" class="block text-base p-2 rounded-md ${param.tag_main == '정보' and empty param.source ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">정보</a>
                            <a href="${pageContext.request.contextPath}/community?tag_main=추천" class="block text-base p-2 rounded-md ${param.tag_main == '추천' and empty param.source ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">추천</a>
                            <a href="${pageContext.request.contextPath}/community?tag_main=리뷰" class="block text-base p-2 rounded-md ${param.tag_main == '리뷰' and empty param.source ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">리뷰</a>
                        </div>
                    </div>
                </div>
            </div>
        </nav>
    </div>
</aside>

<%-- 모바일용 메뉴 --%>
<aside class="lg:hidden w-full max-w-lg mx-auto mb-8">
    <div class="bg-white p-4 rounded-lg shadow-md">
        <div class="space-y-3 mb-6">
             <c:choose>
                <c:when test="${empty sessionScope.loginUser}">
                    <a href="${pageContext.request.contextPath}/login" class="block w-full text-center px-4 py-2 rounded-md transition text-sm bg-green-700 text-white hover:bg-green-800">로그인</a>
                    <a href="${pageContext.request.contextPath}/register" class="block w-full text-center px-4 py-2 rounded-md transition text-sm bg-gray-200 text-gray-800 hover:bg-gray-300">회원가입</a>
                </c:when>
                <c:otherwise>
                    <div class="text-center p-2">
                        <p class="font-bold text-gray-800 truncate">${sessionScope.loginUser.nickname}<span class="text-sm font-normal">님</span>, 환영합니다!</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/checkPassword?action=editProfile" class="block w-full text-center px-4 py-2 rounded-md transition text-sm bg-gray-200 text-gray-800 hover:bg-gray-300">회원정보 수정</a>
                    <a href="${pageContext.request.contextPath}/logout" class="block w-full text-center px-4 py-2 rounded-md transition text-sm bg-green-700 text-white hover:bg-green-800">로그아웃</a>
                </c:otherwise>
            </c:choose>
        </div>
        <nav class="flex flex-col space-y-1">
            <div>
                <button class="accordion-toggle font-medium text-gray-600 hover:text-green-700 p-2 rounded-md hover:bg-green-50 w-full flex justify-between items-center text-left text-base">
                    <span>차 정보</span>
                    <svg class="arrow-icon w-4 h-4 transition-transform duration-300" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" /></svg>
                </button>
                <div class="accordion-content ${not empty param.category or not empty param.region ? 'is-open' : ''}">
                    <div class="overflow-hidden">
                        <div class="pl-4 mt-2 space-y-1 border-l-2 border-green-100">
                            <div class="text-base text-gray-500 p-2 font-semibold">차 종류</div>
                            <div class="overflow-hidden pl-4 mt-1 space-y-1 border-l-2 border-gray-100">
                                <a href="${pageContext.request.contextPath}/teatype?category=녹차" class="block text-base p-2 rounded-md ${param.category == '녹차' ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">녹차</a>
                                <a href="${pageContext.request.contextPath}/teatype?category=청차" class="block text-base p-2 rounded-md ${param.category == '청차' ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">청차</a>
                                <a href="${pageContext.request.contextPath}/teatype?category=홍차" class="block text-base p-2 rounded-md ${param.category == '홍차' ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">홍차</a>
                                <a href="${pageContext.request.contextPath}/teatype?category=흑차" class="block text-base p-2 rounded-md ${param.category == '흑차' ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">흑차</a>
                                <a href="${pageContext.request.contextPath}/teatype?category=백차" class="block text-base p-2 rounded-md ${param.category == '백차' ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">백차</a>
                                <a href="${pageContext.request.contextPath}/teatype?category=대용차" class="block text-base p-2 rounded-md ${param.category == '대용차' ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">대용차</a>
                            </div>
                            <div class="text-base text-gray-500 p-2 font-semibold mt-2">지역 별</div>
                            <div class="pl-4 mt-1 space-y-1 border-l-2 border-gray-100">
                                <a href="${pageContext.request.contextPath}/regiontype?region=아시아" class="block text-base p-2 rounded-md ${param.region == '아시아' ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">아시아</a>
                                <a href="${pageContext.request.contextPath}/regiontype?region=유럽" class="block text-base p-2 rounded-md ${param.region == '유럽' ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">유럽</a>
                                <a href="${pageContext.request.contextPath}/regiontype?region=아메리카" class="block text-base p-2 rounded-md ${param.region == '아메리카' ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">아메리카</a>
                                <a href="${pageContext.request.contextPath}/regiontype?region=아프리카" class="block text-base p-2 rounded-md ${param.region == '아프리카' ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">아프리카</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div>
                 <button class="accordion-toggle font-medium text-gray-600 hover:text-green-700 p-2 rounded-md hover:bg-green-50 w-full flex justify-between items-center text-left text-base">
                   <span>커뮤니티</span>
                   <svg class="arrow-icon w-4 h-4 transition-transform duration-300" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" /></svg>
               </button>
                 <div class="accordion-content ${pageContext.request.servletPath == '/community' ? 'is-open' : ''}">
                     <div class="pl-4 mt-2 space-y-1 border-l-2 border-green-100">
                         <a href="${pageContext.request.contextPath}/community" class="block text-base p-2 rounded-md ${pageContext.request.servletPath == '/community' && empty param.tag_main ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">커뮤니티 홈</a>
                         <a href="${pageContext.request.contextPath}/community?tag_main=정보" class="block text-base p-2 rounded-md ${param.tag_main == '정보' and empty param.source ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">정보</a>
                        <a href="${pageContext.request.contextPath}/community?tag_main=추천" class="block text-base p-2 rounded-md ${param.tag_main == '추천' and empty param.source ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">추천</a>
                        <a href="${pageContext.request.contextPath}/community?tag_main=리뷰" class="block text-base p-2 rounded-md ${param.tag_main == '리뷰' and empty param.source ? 'font-bold text-green-700 bg-green-50' : 'text-gray-500 hover:text-green-600 hover:bg-green-50'}">리뷰</a>
                    </div>
                </div>
            </div>
        </nav>
    </div>
</aside>

