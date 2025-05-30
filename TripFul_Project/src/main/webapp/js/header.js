document.addEventListener('DOMContentLoaded', function() {
    const input = document.getElementById('searchInput');
    const suggestions = document.getElementById('suggestions');
    const searchForm = input.closest('form');
    const mainMenu = document.getElementById('mainMenu');
    const navLinks = mainMenu.querySelectorAll('.nav-link');

    let isComposing = false;
    let latestQuery = "";
    let focusedSuggestionIndex = -1; // 현재 포커스된 추천 항목의 인덱스

    input.addEventListener('compositionstart', () => {
        isComposing = true;
    });

    input.addEventListener('compositionend', () => {
        isComposing = false;
        triggerSearch(false);
    });

    input.addEventListener('input', () => {
        if (isComposing) {
            triggerSearch(true);
        } else {
            setTimeout(() => triggerSearch(false), 0);
        }
        focusedSuggestionIndex = -1; // 입력 시 포커스 초기화
    });

    input.addEventListener('focus', () => {
        if (suggestions.children.length > 0) {
            suggestions.style.display = 'block';
        }
    });

    input.addEventListener('blur', () => {
        // blur 시 바로 숨기지 않고 약간의 지연을 줘서 클릭 이벤트가 발생할 시간을 줍니다.
        setTimeout(() => {
            suggestions.style.display = 'none';
            focusedSuggestionIndex = -1; // 숨길 때 포커스 초기화
            removeSuggestionFocus();
        }, 150);
    });

    function triggerSearch(isDraft = false) {
        const query = input.value.trim();
        if (query.length === 0) {
            suggestions.style.display = 'none';
            suggestions.innerHTML = '';
            latestQuery = "";
            return;
        }
        if (query === latestQuery) return;
        latestQuery = query;

        fetch('page/searchSuggestions.jsp?keyword=' + encodeURIComponent(query) + '&draft=' + isDraft)
            .then(res => res.json())
            .then(data => {
                suggestions.innerHTML = '';
                if (!data || data.length === 0) {
                    suggestions.style.display = 'none';
                    return;
                }

                data.forEach((name, index) => {
                    const li = document.createElement('li');
                    li.textContent = name;
                    li.style.padding = '8px 12px';
                    li.style.cursor = 'pointer';
                    li.setAttribute('data-index', index); // 인덱스 저장

                    li.addEventListener('mousedown', (e) => {
                        e.preventDefault(); // blur 이벤트가 먼저 발생하지 않도록 방지

                        input.blur(); // input 포커스 해제

                        setTimeout(() => {
                            input.value = name;
                            suggestions.style.display = 'none';
                            input.focus(); // input 포커스 다시 설정 (검색어 확인용)

                            // 폼 제출
                            setTimeout(() => {
                                searchForm.submit();
                            }, 100);
                        }, 10);
                    });

                    li.addEventListener('mouseover', () => {
                        removeSuggestionFocus();
                        li.style.backgroundColor = '#eee';
                        focusedSuggestionIndex = parseInt(li.getAttribute('data-index'));
                    });
                    li.addEventListener('mouseout', () => {
                        li.style.backgroundColor = 'transparent';
                    });

                    suggestions.appendChild(li);
                });

                suggestions.style.display = 'block';
                focusedSuggestionIndex = -1; // 새 목록이 로드되면 포커스 초기화
            })
            .catch(() => {
                suggestions.style.display = 'none';
            });
    }

    // 추천 항목에 포커스 스타일을 적용하는 함수
    function applySuggestionFocus(index) {
        const items = suggestions.children;
        if (items.length === 0) return;

        removeSuggestionFocus(); // 기존 포커스 제거

        if (index >= 0 && index < items.length) {
            items[index].style.backgroundColor = '#eee';
            items[index].scrollIntoView({ block: 'nearest', behavior: 'smooth' }); // 스크롤 이동
            focusedSuggestionIndex = index;
        }
    }

    // 모든 추천 항목에서 포커스 스타일을 제거하는 함수
    function removeSuggestionFocus() {
        const items = suggestions.children;
        for (let i = 0; i < items.length; i++) {
            items[i].style.backgroundColor = 'transparent';
        }
    }

    // 키보드 이벤트 리스너 추가
    input.addEventListener('keydown', (event) => {
        const items = suggestions.children;
        if (items.length === 0 || suggestions.style.display === 'none') {
            return; // 추천 목록이 없거나 숨겨져 있으면 아무것도 하지 않음
        }

        if (event.key === 'ArrowDown') {
            event.preventDefault(); // 커서 이동 방지
            focusedSuggestionIndex = (focusedSuggestionIndex + 1) % items.length;
            applySuggestionFocus(focusedSuggestionIndex);
            input.value = items[focusedSuggestionIndex].textContent; // input에 추천어 채우기
        } else if (event.key === 'ArrowUp') {
            event.preventDefault(); // 커서 이동 방지
            focusedSuggestionIndex = (focusedSuggestionIndex - 1 + items.length) % items.length;
            applySuggestionFocus(focusedSuggestionIndex);
            input.value = items[focusedSuggestionIndex].textContent; // input에 추천어 채우기
        } else if (event.key === 'Enter') {
            event.preventDefault(); // 기본 폼 제출 방지 (엔터는 검색으로 사용)
            if (focusedSuggestionIndex !== -1) {
                // 포커스된 항목이 있으면 선택하여 폼 제출
                input.value = items[focusedSuggestionIndex].textContent;
                suggestions.style.display = 'none';
                searchForm.submit();
            } else if (input.value.trim().length > 0) {
                // 포커스된 항목이 없지만 입력값이 있으면 일반 검색
                suggestions.style.display = 'none';
                searchForm.submit();
            }
        }
    });

    searchForm.querySelector('button[type="submit"]').addEventListener('click', (event) => {
        event.preventDefault();
        if (input.value.trim().length > 0) {
            searchForm.submit();
        }
    });

    // 햄버거 메뉴 닫힘 로직
    navLinks.forEach(link => {
        link.addEventListener('click', () => {
            if (mainMenu.classList.contains('show')) {
                const bsCollapse = new bootstrap.Collapse(mainMenu, {
                    toggle: false
                });
                bsCollapse.hide();
            }
        });
    });
});