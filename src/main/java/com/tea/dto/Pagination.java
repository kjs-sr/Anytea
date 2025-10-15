package com.tea.dto;

public class Pagination {
    private int currentPage;    // 현재 페이지 번호
    private int totalPosts;     // 전체 게시물 수
    private int postsPerPage;   // 페이지당 게시물 수
    private int pagesPerBlock;  // 한 번에 표시할 페이지 번호 수

    private int totalPages;     // 전체 페이지 수
    private int startPage;      // 현재 블록의 시작 페이지 번호
    private int endPage;        // 현재 블록의 끝 페이지 번호
    private boolean prev;       // 이전 블록으로 가는 링크 유무
    private boolean next;       // 다음 블록으로 가는 링크 유무
    
    // [추가] 처음/마지막 블록인지 확인하는 변수
    private boolean first;
    private boolean last;

    public Pagination(int currentPage, int totalPosts, int postsPerPage, int pagesPerBlock) {
        this.currentPage = currentPage;
        this.totalPosts = totalPosts;
        this.postsPerPage = postsPerPage;
        this.pagesPerBlock = pagesPerBlock;

        this.totalPages = (int) Math.ceil((double) totalPosts / postsPerPage);
        
        int halfBlock = pagesPerBlock / 2;
        this.startPage = currentPage - halfBlock;
        this.endPage = currentPage + halfBlock;

        if (this.startPage < 1) {
            this.startPage = 1;
            this.endPage = Math.min(pagesPerBlock, this.totalPages);
        }

        if (this.endPage > this.totalPages) {
            this.endPage = this.totalPages;
            this.startPage = Math.max(1, this.endPage - pagesPerBlock + 1);
        }

        this.prev = this.startPage > 1;
        this.next = this.endPage < this.totalPages;
        
        // [추가] 현재 블록이 처음 또는 마지막 블록인지 계산
        this.first = this.startPage == 1;
        this.last = this.endPage == this.totalPages;
    }

    // Getters
    public int getCurrentPage() { return currentPage; }
    public int getTotalPages() { return totalPages; }
    public int getStartPage() { return startPage; }
    public int getEndPage() { return endPage; }
    public boolean isPrev() { return prev; }
    public boolean isNext() { return next; }
    
    // [추가] 새로운 Getter
    public boolean isFirst() { return first; }
    public boolean isLast() { return last; }
}

