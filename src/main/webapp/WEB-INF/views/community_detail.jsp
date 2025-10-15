<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${post.title} - 여차저차</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style> body { font-family: 'Noto Sans KR', sans-serif; } </style>
</head>
<body class="bg-gray-100 text-gray-800 flex flex-col min-h-screen">

    <%-- 삭제 확인 모달 --%>
    <div id="delete-modal" class="hidden fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
        <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
            <div class="mt-3 text-center">
                <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100">
                    <svg class="h-6 w-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path></svg>
                </div>
                <h3 class="text-lg leading-6 font-medium text-gray-900 mt-2">게시글 삭제</h3>
                <div class="mt-2 px-7 py-3">
                    <p class="text-sm text-gray-500">정말 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.</p>
                </div>
                <div class="items-center px-4 py-3">
                    <button id="cancel-btn" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300 mr-2">취소</button>
                    <button id="confirm-delete-btn" class="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700">예, 삭제합니다</button>
                </div>
            </div>
        </div>
    </div>
    
    <%-- 좋아요 알림 팝업 --%>
    <div id="toast-alert" class="opacity-0 pointer-events-none fixed top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-gray-800 text-white px-6 py-3 rounded-lg shadow-lg z-50 transition-opacity duration-500">
        이미 좋아요를 누른 게시글입니다.
    </div>

    <jsp:include page="/WEB-INF/views/include/header.jsp" />

    <div class="w-full max-w-[2100px] mx-auto px-6 mt-8 flex-grow">
        <div class="flex justify-center gap-6">
            <jsp:include page="/WEB-INF/views/include/menu.jsp" />

            <main class="min-w-0 lg:flex-1">
                <div class="bg-white p-6 sm:p-8 rounded-lg shadow-md">
                    <c:choose>
                        <c:when test="${not empty post}">
                            <div class="border-b pb-4 mb-6">
                                <div class="flex justify-between items-start">
                                    <div>
                                        <div class="flex items-center gap-2 mb-2">
                                             <span class="text-sm font-semibold py-1 px-2 rounded-full text-blue-600 bg-blue-200">${post.tagMain}</span>
                                             <c:if test="${not empty post.tagTea}"><span class="text-sm font-semibold py-1 px-2 rounded-full text-green-600 bg-green-200">${post.tagTea}</span></c:if>
                                             <c:if test="${not empty post.tagRegion}"><span class="text-sm font-semibold py-1 px-2 rounded-full text-purple-600 bg-purple-200">${post.tagRegion}</span></c:if>
                                        </div>
                                        <h1 class="text-3xl font-bold text-gray-900">${post.title}</h1>
                                    </div>
                                    <c:if test="${sessionScope.loginUser.userNo == post.userNo}">
                                        <div class="flex-shrink-0 flex items-center gap-2">
                                            <a href="${pageContext.request.contextPath}/postAction?action=edit&no=${post.postNo}" class="text-xs bg-gray-200 hover:bg-gray-300 text-gray-700 font-semibold py-1 px-3 rounded-md transition">수정</a>
                                            <button onclick="openDeleteModal(${post.postNo})" class="text-xs bg-red-100 hover:bg-red-200 text-red-700 font-semibold py-1 px-3 rounded-md transition">삭제</button>
                                        </div>
                                    </c:if>
                                </div>
                                <div class="flex flex-wrap justify-between items-center mt-3 text-sm text-gray-500">
                                    <div>
                                        <span class="font-bold">${post.nickname}</span>
                                    </div>
                                    <div class="text-right">
                                        <div>
                                            <span>작성일: <fmt:formatDate value="${post.date}" pattern="yyyy.MM.dd HH:mm"/></span>
                                             <c:if test="${post.modifyDate.time - post.date.time > 60000}">
                                                <span class="ml-3">마지막 수정일: <fmt:formatDate value="${post.modifyDate}" pattern="yyyy.MM.dd HH:mm"/></span>
                                            </c:if>
                                        </div>
                                        <span>조회수 ${post.views}</span>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="prose max-w-none mb-8">${post.contents}</div>

                            <div class="flex justify-center items-center my-8">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.loginUser}">
                                        <c:if test="${userHasLiked}">
                                            <a href="javascript:void(0);" onclick="showLikeAlert()" class="bg-pink-100 text-pink-700 font-bold py-2 px-4 rounded-full flex items-center gap-2 transition">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd" /></svg>
                                                <span>좋아요 ${post.likes}</span>
                                            </a>
                                        </c:if>
                                        <c:if test="${!userHasLiked}">
                                            <a href="${pageContext.request.contextPath}/likePost?no=${post.postNo}" class="border border-red-500 text-red-500 font-bold py-2 px-4 rounded-full flex items-center gap-2 hover:bg-red-50 transition">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd" /></svg>
                                                <span>좋아요 ${post.likes}</span>
                                            </a>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/login" class="border border-red-500 text-red-500 font-bold py-2 px-4 rounded-full flex items-center gap-2 hover:bg-red-50 transition">
                                             <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd" /></svg>
                                            <span>좋아요 ${post.likes}</span>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <%-- 댓글 섹션 전체 수정 --%>
		                    <div>
		                        <h2 class="text-xl font-bold mb-4">댓글 ${commentList.size()}개</h2>
		                        
		                        <%-- [수정] 구분선과 댓글 목록 사이의 간격(mb-4)을 줄임 --%>
		                        <hr class="mb-4 border-gray-300">
		
		                        <div class="space-y-4">
		                            <c:forEach var="comment" items="${commentList}">
		                                <div id="comment-section-${comment.cmtNo}" style="margin-left: ${ (comment.level - 1) * 2.5 }rem;">
		                                    <div class="flex gap-3">
		                                        <c:if test="${comment.level > 1}"><div class="flex-shrink-0 w-4 h-4 mt-1 text-gray-400">└</div></c:if>
		                                        <div class="flex-grow">
		                                            <%-- [수정] 댓글 상태에 따라 다르게 표시 --%>
		                                            <c:choose>
		                                                <%-- 삭제된 댓글일 경우 --%>
		                                                <c:when test="${comment.cmtStatus == 'deleted'}">
		                                                    <p class="text-gray-400 italic mt-1">삭제된 댓글입니다.</p>
		                                                </c:when>
		                                                <%-- 정상 댓글일 경우 --%>
		                                                <c:otherwise>
		                                                    <div class="flex items-center justify-between">
		                                                        <span class="font-bold text-sm">${comment.nickname}</span>
		                                                        <div class="flex items-center gap-3 text-xs">
		                                                            <span class="text-gray-500"><fmt:formatDate value="${comment.date}" pattern="yyyy.MM.dd HH:mm"/></span>
		                                                            <c:if test="${sessionScope.loginUser.userNo == comment.userNo}">
		                                                                <button onclick="toggleEditForm(${comment.cmtNo}, `${comment.contents}`)" class="font-semibold text-blue-600 hover:text-blue-800">수정</button>
		                                                                <form id="delete-comment-form-${comment.cmtNo}" action="${pageContext.request.contextPath}/commentAction" method="post" class="inline">
		                                                                    <input type="hidden" name="action" value="delete">
		                                                                    <input type="hidden" name="postNo" value="${post.postNo}">
		                                                                    <input type="hidden" name="cmtNo" value="${comment.cmtNo}">
		                                                                    <button type="button" onclick="confirmDelete(${comment.cmtNo})" class="font-semibold text-red-600 hover:text-red-800">삭제</button>
		                                                                </form>
		                                                            </c:if>
		                                                        </div>
		                                                    </div>
		                                                    <div id="comment-content-${comment.cmtNo}">
		                                                        <p class="text-gray-700 mt-1">${comment.contents}</p>
		                                                        <div class="mt-2">
		                                                            <c:if test="${not empty sessionScope.loginUser and comment.level < 5}">
		                                                                 <button onclick="toggleReplyForm(${comment.cmtNo})" class="text-xs text-gray-500 hover:text-gray-800">답글</button>
		                                                            </c:if>
		                                                        </div>
		                                                    </div>
		                                                </c:otherwise>
		                                            </c:choose>
		                                        </div>
		                                    </div>
		                                </div>
		                            </c:forEach>
		                        </div>
		
		                        <%-- 댓글 작성 폼 --%>
		                        <div class="mt-8">
		                            <c:choose>
		                                <c:when test="${not empty sessionScope.loginUser}">
		                                    <form action="${pageContext.request.contextPath}/commentAction" method="post">
		                                        <input type="hidden" name="action" value="add">
		                                        <input type="hidden" name="postNo" value="${post.postNo}">
		                                        <textarea name="contents" class="w-full border rounded-md p-3" rows="3" placeholder="댓글을 입력하세요..." required></textarea>
		                                        <div class="text-right mt-2">
		                                            <button type="submit" class="bg-green-700 text-white px-4 py-2 rounded-md text-sm hover:bg-green-800">댓글 작성</button>
		                                        </div>
		                                    </form>
		                                </c:when>
		                                <c:otherwise>
		                                    <div class="text-center border rounded-md p-6 bg-gray-50">
		                                        <p class="text-gray-600">로그인한 경우에만 댓글 작성이 가능합니다.</p>
		                                    </div>
		                                </c:otherwise>
		                            </c:choose>
		                        </div>
		                    </div>
		                </c:when>
		                <c:otherwise>
		                    <p class="text-center text-gray-500 py-16">게시글을 찾을 수 없습니다.</p>
		                </c:otherwise>
		            </c:choose>
		            <div class="text-center mt-8">
		                <a href="javascript:history.back()" class="bg-gray-200 text-gray-800 px-6 py-2 rounded-md text-sm hover:bg-gray-300">목록으로</a>
		            </div>
		        </div>
		    </main>
            
            <div class="hidden lg:block w-44 flex-shrink-0"></div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/include/footer.jsp" />

    <script>
        const deleteModal = document.getElementById('delete-modal');
        const confirmDeleteBtn = document.getElementById('confirm-delete-btn');
        const cancelBtn = document.getElementById('cancel-btn');

        function openDeleteModal(postNo) {
            confirmDeleteBtn.onclick = function() {
                const form = document.createElement('form');
                form.method = 'post';
                form.action = `${pageContext.request.contextPath}/postAction`;
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                form.appendChild(actionInput);

                const noInput = document.createElement('input');
                noInput.type = 'hidden';
                noInput.name = 'no';
                noInput.value = postNo;
                form.appendChild(noInput);
                
                document.body.appendChild(form);
                form.submit();
            };
            deleteModal.classList.remove('hidden');
        }

        function closeDeleteModal() {
            deleteModal.classList.add('hidden');
        }

        cancelBtn.onclick = closeDeleteModal;
        window.onclick = function(event) {
            if (event.target == deleteModal) {
                closeDeleteModal();
            }
        }

        let isAlertShowing = false;
        function showLikeAlert() {
            if (isAlertShowing) return;
            const alert = document.getElementById('toast-alert');
            isAlertShowing = true;
            alert.classList.remove('opacity-0', 'pointer-events-none');
            setTimeout(() => {
                alert.classList.add('opacity-0');
            }, 1500);
            setTimeout(() => {
                 alert.classList.add('pointer-events-none');
                 isAlertShowing = false;
            }, 2000);
        }
        
     	// [추가] 답글 폼을 동적으로 생성/제거하는 스크립트
        function toggleReplyForm(parentCmtNo) {
            const existingForm = document.getElementById('reply-form');
            if (existingForm) {
                existingForm.remove();
            }

            const targetSection = document.getElementById('comment-section-' + parentCmtNo);
            if (!targetSection) return;

            // [수정] JavaScript 변수인 parentCmtNo가 form에 올바르게 전달되도록 수정
            const formHtml = `
                <div id="reply-form" class="ml-8 mt-4">
                    <form action="${pageContext.request.contextPath}/commentAction" method="post">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="postNo" value="${post.postNo}">
                        <input type="hidden" name="parentCmtNo" value="` + parentCmtNo + `">
                        <textarea name="contents" class="w-full border rounded-md p-3" rows="2" placeholder="답글을 입력하세요..." required></textarea>
                        <div class="text-right mt-2 space-x-2">
                            <button type="button" onclick="this.closest('#reply-form').remove()" class="bg-gray-200 text-gray-700 px-3 py-1 rounded-md text-xs hover:bg-gray-300">취소</button>
                            <button type="submit" class="bg-green-700 text-white px-3 py-1 rounded-md text-xs hover:bg-green-800">답글 작성</button>
                        </div>
                    </form>
                </div>
            `;
            
            targetSection.insertAdjacentHTML('beforeend', formHtml);
        }
     	// [수정] 댓글 삭제 확인 스크립트 (window.confirm 사용)
        function confirmDelete(cmtNo) {
            if (confirm("댓글을 삭제하시겠습니까?")) {
                document.getElementById('delete-comment-form-' + cmtNo).submit();
            }
        }

        // [수정] 댓글 수정 폼 토글 스크립트 버그 수정
        function toggleEditForm(cmtNo, currentContents) {
            // 다른 수정/답글 폼이 열려있으면 모두 닫기
            document.querySelectorAll('.edit-form, #reply-form').forEach(form => form.remove());
            document.querySelectorAll('[id^="comment-content-"]').forEach(content => content.style.display = 'block');

            const contentDiv = document.getElementById('comment-content-' + cmtNo);
            
            // 현재 내가 클릭한 댓글의 수정 폼이 이미 열려있는지 확인
            const existingForm = document.getElementById('edit-form-' + cmtNo);

            if (existingForm) {
                // 이미 열려있다면 (즉, '취소'를 누른 경우), 폼을 닫고 원래 내용을 보여줌
                existingForm.remove();
                contentDiv.style.display = 'block';
            } else {
                // 열려있지 않다면 (즉, '수정'을 처음 누른 경우), 새로운 수정 폼 생성
                // JSP EL과 JavaScript 변수의 충돌을 피하기 위해 문자열 연결 방식으로 변경
                const formHtml =
                    '<div id="edit-form-' + cmtNo + '" class="mt-2 edit-form">' +
                        '<form action="${pageContext.request.contextPath}/commentAction" method="post">' +
                            '<input type="hidden" name="action" value="edit">' +
                            '<input type="hidden" name="postNo" value="' + ${post.postNo} + '">' +
                            '<input type="hidden" name="cmtNo" value="' + cmtNo + '">' +
                            '<textarea name="contents" class="w-full border rounded-md p-2 text-sm" required>' + currentContents + '</textarea>' +
                            '<div class="text-right mt-2 space-x-2">' +
                                '<button type="button" onclick="toggleEditForm(' + cmtNo + ')" class="bg-gray-200 text-gray-700 px-3 py-1 rounded-md text-xs hover:bg-gray-300">취소</button>' +
                                '<button type="submit" class="bg-indigo-600 text-white px-3 py-1 rounded-md text-xs hover:bg-indigo-700">수정 완료</button>' +
                            '</div>' +
                        '</form>' +
                    '</div>';

                // 원래 내용은 숨기고, 그 바로 뒤에 수정 폼을 삽입
                contentDiv.style.display = 'none';
                contentDiv.insertAdjacentHTML('afterend', formHtml);
            }
        }
    </script>
</body>
</html>

