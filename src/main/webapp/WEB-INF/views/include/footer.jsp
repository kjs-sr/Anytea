<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    [최종 수정본]
    이 파일은 웹사이트의 푸터(하단 정보) 및 모든 공통 스크립트를 담당합니다.
    - 헤더 슬라이드쇼가 랜덤 이미지부터 시작되도록 수정되었습니다.
--%>
<footer class="bg-gray-800 text-white mt-12 py-8 text-center">
    <p>&copy; 2025 여차저차. All rights reserved.</p>
    <p class="text-sm text-gray-400">본 사이트는 포트폴리오 목적으로 제작되었습니다.</p>
</footer>

<script>
document.addEventListener('DOMContentLoaded', function() {
    
    // [수정] 1. 헤더 슬라이드쇼 기능
    const slides = document.querySelectorAll('.header-slide');
    if (slides.length > 1) {
        const intervalTime = 12000;
        let currentIndex = 0;

        slides.forEach(slide => {
            slide.classList.add('animate-continuous-pan');
        });

        function saveState() {
            sessionStorage.setItem('slideshowIndex', currentIndex);
            sessionStorage.setItem('slideshowTimestamp', Date.now());
        }

        function changeSlide() {
            const currentSlide = slides[currentIndex];
            const nextIndex = (currentIndex + 1) % slides.length;
            const nextSlide = slides[nextIndex];

            nextSlide.style.opacity = '1';
            currentSlide.style.opacity = '0';

            currentIndex = nextIndex;
            saveState();
        }
        
        function initSlideshow() {
            const savedIndex = sessionStorage.getItem('slideshowIndex');
            const savedTimestamp = sessionStorage.getItem('slideshowTimestamp');

            if (savedIndex !== null && savedTimestamp !== null) {
                currentIndex = parseInt(savedIndex, 10);
                const timeElapsed = Date.now() - parseInt(savedTimestamp, 10);
                let timeRemaining = intervalTime - timeElapsed;
                if (timeRemaining < 0) timeRemaining = 0;

                slides.forEach((slide, index) => {
                    slide.style.opacity = (index === currentIndex) ? '1' : '0';
                });
                
                setTimeout(() => {
                    changeSlide();
                    setInterval(changeSlide, intervalTime);
                }, timeRemaining);
            } else {
                // 저장된 세션이 없으면 랜덤 슬라이드부터 시작
                const randomIndex = Math.floor(Math.random() * slides.length);
                currentIndex = randomIndex;
                slides[currentIndex].style.opacity = '1';
                
                saveState();
                setInterval(changeSlide, intervalTime);
            }
        }
        initSlideshow();
    }

 	// 2. 메뉴 아코디언 기능
    const accordionToggles = document.querySelectorAll('.accordion-toggle');
    
    accordionToggles.forEach(toggle => {
        const content = toggle.nextElementSibling;
        const arrow = toggle.querySelector('.arrow-icon');
        
        if (content && content.classList.contains('is-open')) {
            if (arrow) {
                arrow.classList.add('rotate-180');
            }
        }
        
        toggle.addEventListener('click', () => {
            content.classList.toggle('is-open');
            
            if (arrow) {
                arrow.classList.toggle('rotate-180');
            }
        });
    });

    // 3. 로고 호버 애니메이션 기능
    const logoLink = document.getElementById('logo-link');
    const logoImage = document.getElementById('logo-image');
    let hoverTimeout;

    if (logoLink && logoImage) {
        logoLink.addEventListener('mouseenter', () => {
            logoImage.style.transition = 'transform 300ms ease-in-out';
            logoImage.style.transform = 'rotate(20deg)';

            hoverTimeout = setTimeout(() => {
                logoImage.style.transition = 'none';
                logoImage.classList.add('animate-logo-spin');
            }, 4000);
        });

        logoLink.addEventListener('mouseleave', () => {
            clearTimeout(hoverTimeout);
            logoImage.classList.remove('animate-logo-spin');
            
            logoImage.style.transition = ''; 
            logoImage.style.transform = '';
        });
    }
});
</script>
</body>
</html>

