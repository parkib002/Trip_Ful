<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<link rel="shortcut Icon" href="https://ssl.nexon.com/s2/game/fc/online/common/favicon.ico" type="image/x-icon">
<link rel="icon" href="https://ssl.nexon.com/s2/game/fc/online/common/favicon.ico" type="image/x-icon">
<link rel="canonical" href="https://fconline.nexon.com/main/index">
<link rel="stylesheet" href="https://js.nexon.com/s3/fc/online/obt/swiper.min.css">
<link rel="stylesheet" type="text/css" href="https://js.nexon.com/s3/fc/online/obt/fo4_ssl.css?2025052312" media="all">
<link rel="stylesheet" type="text/css" href="https://js.nexon.com/s3/fc/online/obt/fonts_ssl.css" media="all">
<link rel="stylesheet" type="text/css" href="https://fesdk.nexon.com/nexon-gnb-component/nexon-gnb-components-index.css">
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div id="divListPart">
                <div class="board_list">
                    <div class="header">
                        <div class="tit">게임공지</div>
                        <div class="utils">
                            <div class="search_form">
                                <div class="num">총 4,140개</div>
                                <div class="select_wrap">
                                    <select name="select" id="slcSearchType">
                                        <option value="Title">제목</option>
                                        <option value="Contents">본문</option>
                                        <option value="TitleContents">제목+본문</option>
                                    </select>
                                </div>
                                <div class="form_wrap">
                                    <input type="text" id="searchInput" placeholder="검색" value="">
                                    <button id="btnSearch" onclick="Article.ArticleList(this, 1, '#divListPart', $('#searchInput').val(), $('#slcSearchType').val(), 0, 0, '/news/notice');"><span class="ico ico_search"></span></button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab_list medium">
                        <ul>
                            <li class="active tab2"><a href="javascript:;">게임공지</a></li>                            
                            <li class="tab2"><a href="/news/nxnotice/list">넥슨공지</a></li>
                        </ul>
                    </div>
                    <div class="content">
                        <div class="page_list">
                            <div class="heading">
                                <div class="radio_wrap">
                                    <div>
                                        <input type="radio" id="radioSort01" name="radio" checked="">
                                        <label for="radioSort01"><span></span>전체</label>
                                    </div>
                                    <div>
                                        <input type="radio" id="radioSort02" name="radio" onclick="Article.ArticleList(this, 1, '#divListPart', '', 'Title', 1, 0, '/news/notice');">
                                        <label for="radioSort02"><span></span>공지</label>
                                    </div>
                                    <div>
                                        <input type="radio" id="radioSort03" name="radio" onclick="Article.ArticleList(this, 1, '#divListPart', '', 'Title', 2, 0, '/news/notice');">
                                        <label for="radioSort03"><span></span>점검</label>
                                    </div>
                                    <div>
                                        <input type="radio" id="radioSort04" name="radio" onclick="Article.ArticleList(this, 1, '#divListPart', '', 'Title', 3, 0, '/news/notice');">
                                        <label for="radioSort04"><span></span>업데이트</label>
                                    </div>
                                    <div>
                                        <input type="radio" id="radioSort05" name="radio" onclick="Article.ArticleList(this, 1, '#divListPart', '', 'Title', 4, 0, '/news/notice');">
                                        <label for="radioSort05"><span></span>이벤트</label>
                                    </div>
                                    <div>
                                        <input type="radio" id="radioSort06" name="radio" onclick="Article.ArticleList(this, 1, '#divListPart', '', 'Title', 5, 0, '/news/notice');">
                                        <label for="radioSort06"><span></span>GM소식</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="list_wrap">
                            <div class="thead">
                                <div class="tr">
                                    <span class="th sort">구분</span>
                                    <span class="th subject">제목</span>
                                    <span class="th date">작성일</span>
                                    <span class="th count">조회수</span>
                                </div>
                            </div>
                            <div class="tbody">
                                    <div class="tr notice">
                                        <a href="/news/notice/view?n4ArticleSN=5381">
                                            <span class="td sort">공지</span>
                                            <span class="td subject">(수상자 추가) 7th ANNIVERSARY AWARDS 수상자 발표  </span>
                                            <span class="td date">5.15(목)</span>
                                            <span class="td count">-</span>
                                        </a>
                                        <div class="hidden_desc" style="left: 394px; display: none;">
                                            <div class="text_box">
                                                (5/22(목) 오전 10시 19분에 추가된 내용입니다.)
 
개근상(2024) 수상 조건에 만족하나, 일부 구단주님께서 누락된 문제가 확인되어 다음과 같이 수정 작업이 진행되었습니다.
 
...
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tr notice">
                                        <a href="/news/notice/view?n4ArticleSN=5374">
                                            <span class="td sort">공지</span>
                                            <span class="td subject">[5/23(금) 갱신] 5월 유료화 상품 판매 안내  </span>
                                            <span class="td date">5.1(목)</span>
                                            <span class="td count">-</span>
                                        </a>
                                        <div class="hidden_desc" style="left: 394px; display: none;">
                                            <div class="text_box">
                                                안녕하세요. GM 리버풀입니다.
 
5월 23일(금) 판매중인 유료화 상품을 안내드립니다. 
하단에 안내 드리는 내용을 참고하시고, 신규 출시된 유료화 상품명과 상품별 판매 위치를...
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tr notice">
                                        <a href="/news/notice/view?n4ArticleSN=5347">
                                            <span class="td sort">이벤트</span>
                                            <span class="td subject">[5/12(월) 추가] 축구 좋아하세요? ‘판타지 리그’ 모두의 런칭 이벤트 사전 안내  </span>
                                            <span class="td date">4.24(목)</span>
                                            <span class="td count">-</span>
                                        </a>
                                        <div class="hidden_desc" style="left: 394px; display: none;">
                                            <div class="text_box">
                                                안녕하세요. GM 리버풀입니다.
 
(5/12(월) 오후 7시 5분에 추가된 내용입니다.)
‘판타지 리그' 모두의 런칭 이벤트에서 아래 내용이 오후 6시 46분경 수정 완료되어 안내드립니다...
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tr notice">
                                        <a href="/news/notice/view?n4ArticleSN=5351">
                                            <span class="td sort">공지</span>
                                            <span class="td subject">[5/14(수) 기준] 4/24(목) 업데이트 이후 모바일 환경에서 발생 중인 현상  </span>
                                            <span class="td date">4.24(목)</span>
                                            <span class="td count">-</span>
                                        </a>
                                        <div class="hidden_desc" style="left: 394px; display: none;">
                                            <div class="text_box">
                                                안녕하세요. GM 비올라입니다.
 
4/24(목) 정기점검 이후 FC ONLINE M에 추가된 판타지리그에서 발생 중인 현상에 대해 안내 드립니다.
최대한 빠르게 조치하여 수정되는...
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tr notice">
                                        <a href="/news/notice/view?n4ArticleSN=5284">
                                            <span class="td sort">공지</span>
                                            <span class="td subject">Jumping UP 이벤트 당첨자 발표  <span class="dday">D-222</span></span>
                                            <span class="td date">3.20(목)</span>
                                            <span class="td count">-</span>
                                        </a>
                                        <div class="hidden_desc" style="left: 394px; display: none;">
                                            <div class="text_box">
                                                안녕하세요. GM 네로입니다.
 
2024년 12월 19일(목) ~ 2025년 3월 12일(수) 진행된
Jumping up start festival 이벤트 넥슨캐시 당첨 구단주님을 안내해드립니다. [이벤트 바...
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tr notice">
                                        <a href="/news/notice/view?n4ArticleSN=4845">
                                            <span class="td sort">이벤트</span>
                                            <span class="td subject">FC 온라인 M X Google Play Pass 이벤트 연장 안내 (~ 25/5/28)  <span class="dday">D-5</span></span>
                                            <span class="td date">6.11(화)</span>
                                            <span class="td count">-</span>
                                        </a>
                                        <div class="hidden_desc" style="left: 394px; display: none;">
                                            <div class="text_box">
                                                안녕하세요. GM 리버풀입니다.
 
(3/20(목) 오전 11시 25분에 추가된 내용입니다.)
Google Play Pass 이벤트 기간이 25/5/28(수)까지 추가로 연장되어 안내드립니다.
상세 이벤...
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tr notice">
                                        <a href="/news/notice/view?n4ArticleSN=2729">
                                            <span class="td sort">공지</span>
                                            <span class="td subject">5/22(목) 현재 발생 중인 오류 안내  </span>
                                            <span class="td date">5.13(화)</span>
                                            <span class="td count">-</span>
                                        </a>
                                        <div class="hidden_desc" style="display:none;">
                                            <div class="text_box">
                                                안녕하세요. GM 비올라입니다.
 
현재 발생 중인 오류들을 안내 드립니다.
게임 내 오류로 인해 게임 이용에 불편을 끼쳐드려 죄송합니다.
 
오류 내용수정 일정
[일부 ...
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tr ">
                                        <a href="/news/notice/view?n4ArticleSN=5403">
                                            <span class="td sort">공지</span>
                                            <span class="td subject">7th ANNIVERSARY AWARDS 일부 수상자 대상 경품 배송 안내 <span class="ico ico_new">새 글</span> </span>
                                            <span class="td date">58분 전</span>
                                            <span class="td count">648</span>
                                        </a>
                                        <div class="hidden_desc" style="left: 394px; display: none;">
                                            <div class="text_box">
                                                안녕하세요. GM 네로입니다.
 
지난 7년 동안 FC 온라인에 변함없는 사랑과 응원을 보내주신 구단주 여러분께 감사의 마음을 전하기 위해,
이번 7th ANNIVERSARY A...
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tr ">
                                        <a href="/news/notice/view?n4ArticleSN=5402">
                                            <span class="td sort">이벤트</span>
                                            <span class="td subject">UEFA EUROPA LEAGUE 토트넘 우승 기념! 깜짝 접속 이벤트 안내  </span>
                                            <span class="td date">어제</span>
                                            <span class="td count">64,463</span>
                                        </a>
                                        <div class="hidden_desc" style="left: 394px; display: none;">
                                            <div class="text_box">
                                                안녕하세요. GM 리버풀입니다.
 
토트넘 홋스퍼의 UEFA EUROPA LEAGUE 우승을 기념하여, 깜짝 접속 이벤트가 정기점검 종료 후 진행될 예정입니다!
이벤트 기간 F...
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tr ">
                                        <a href="/news/notice/view?n4ArticleSN=5401">
                                            <span class="td sort">공지</span>
                                            <span class="td subject">5/21(수) 무점검 패치 안내 (PC 버전)  </span>
                                            <span class="td date">어제</span>
                                            <span class="td count">28,740</span>
                                        </a>
                                        <div class="hidden_desc" style="left: 394px; display: none;">
                                            <div class="text_box">
                                                안녕하세요. GM 비올라입니다.
 
아래 내용의 수정을 위한 무점검 패치가 5/21(수) 오후 6시 31분에 적용되어 안내 드립니다.
이후에는 동일한 문제로 불편을 겪으시지 않도록 최...
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tr ">
                                        <a href="/news/notice/view?n4ArticleSN=5400">
                                            <span class="td sort">점검</span>
                                            <span class="td subject">(완료) 5/22(목) 정기점검 (오전 2시 30분 ~ 오후 1시 30분)  </span>
                                            <span class="td date">2일 전</span>
                                            <span class="td count">96,416</span>
                                        </a>
                                        <div class="hidden_desc" style="left: 394px; display: none;">
                                            <div class="text_box">
                                                
 
안녕하세요. GM 비올라입니다.
5/22(목) FC ONLINE, FC ONLINE M 정기점검이 진행되어 안내 드립니다. (PC/모바일 점검 시간 동일)
 
■ 정기점검 내...
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tr ">
                                        <a href="/news/notice/view?n4ArticleSN=5399">
                                            <span class="td sort">이벤트</span>
                                            <span class="td subject">[TB, TT 11강 기회!] 백금빛 토요일! 접속 이벤트 사전 안내  </span>
                                            <span class="td date">2일 전</span>
                                            <span class="td count">134,655</span>
                                        </a>
                                        <div class="hidden_desc" style="left: 394px; display: none;">
                                            <div class="text_box">
                                                안녕하세요. GM 리버풀입니다.
 
접속만 해도 TB, TT 클래스 11강 획득 기회! ‘백금빛 토요일! 접속 이벤트’가 5/24(토) 하루 동안 진행될 예정입니다.
이벤트 기간 FC ...
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tr ">
                                        <a href="/news/notice/view?n4ArticleSN=5398">
                                            <span class="td sort">이벤트</span>
                                            <span class="td subject">(이벤트 기간 연장) UEFA EUROPA LEAGUE 결승 기념! 접속 이벤트 사전 안내  </span>
                                            <span class="td date">2일 전</span>
                                            <span class="td count">108,012</span>
                                        </a>
                                        <div class="hidden_desc" style="left: 394px; display: none;">
                                            <div class="text_box">
                                                안녕하세요. GM 리버풀입니다.
 
(5/21(수) 오후 3시 10분에 추가된 내용입니다.)
UEFA EUROPA LEAGUE 결승 기념! 접속 이벤트의 진행 기간이 연장되어 안내드립니다...
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tr ">
                                        <a href="/news/notice/view?n4ArticleSN=5397">
                                            <span class="td sort">이벤트</span>
                                            <span class="td subject">[1조 BP 기회!] FC 온라인 M(모바일) 특별 접속 이벤트 사전 안내  </span>
                                            <span class="td date">2일 전</span>
                                            <span class="td count">138,584</span>
                                        </a>
                                        <div class="hidden_desc" style="left: 394px; display: none;">
                                            <div class="text_box">
                                                안녕하세요. GM 리버풀입니다.
 
접속만 해도 최대 1조 BP 획득 기회! ‘FC 온라인 M(모바일) 특별 접속 이벤트’가 5/22(목) 정기점검 종료 후 진행될 예정입니다.
이벤트...
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tr ">
                                        <a href="/news/notice/view?n4ArticleSN=5395">
                                            <span class="td sort">공지</span>
                                            <span class="td subject">5/16(금) 24PL 클래스 라이브 퍼포먼스 반영 중단 안내  </span>
                                            <span class="td date">5.16(금)</span>
                                            <span class="td count">11,126</span>
                                        </a>
                                        <div class="hidden_desc" style="left: 394px; display: none;">
                                            <div class="text_box">
                                                안녕하세요. GM 비올라입니다.
 
25.5.16(금)에는 부득이하게 24PL 클래스 라이브 퍼포먼스 반영이 일시적으로 중단될 예정입니다.
 
라이브 퍼포먼스 반영 중단으로 구단주님들...
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tr ">
                                        <a href="/news/notice/view?n4ArticleSN=5394">
                                            <span class="td sort">공지</span>
                                            <span class="td subject">(조치 완료) 5/15(목) 기준가 변동 규칙 변경 안내  </span>
                                            <span class="td date">5.15(목)</span>
                                            <span class="td count">18,755</span>
                                        </a>
                                        <div class="hidden_desc" style="left: 394px; display: none;">
                                            <div class="text_box">
                                                안녕하세요. GM거너스입니다.
 
5/8(목) 기준가 변동 규칙 임시 적용 이후 WB 클래스 선수들의 거래를 모니터링하는 과정에서
상대적으로 OVR이 낮은 일부 WB 클래스 선수...
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tr ">
                                        <a href="/news/notice/view?n4ArticleSN=5392">
                                            <span class="td sort">공지</span>
                                            <span class="td subject">5/15(목) 전력분석실 업데이트 안내  </span>
                                            <span class="td date">5.15(목)</span>
                                            <span class="td count">5,510</span>
                                        </a>
                                        <div class="hidden_desc" style="left: 394px; display: none;">
                                            <div class="text_box">
                                                안녕하세요. GM붉은악마 입니다.
5/15(목) 정기점검을 통해 전력분석실의 플레이 스타일이 아래와 같이 업데이트 되어 안내 드립니다.
 
■ 전력분석실 업데이트 데이터 기준 일자...
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tr ">
                                        <a href="/news/notice/view?n4ArticleSN=5391">
                                            <span class="td sort">공지</span>
                                            <span class="td subject">5/15(목) 스페셜 상점 ‘7주년 치트키! SSS 행운 상점’ 참여 가능 기간 변경 안내  </span>
                                            <span class="td date">5.15(목)</span>
                                            <span class="td count">8,410</span>
                                        </a>
                                        <div class="hidden_desc" style="left: 394px; display: none;">
                                            <div class="text_box">
                                                안녕하세요. GM 네로입니다. 
 
5/15(목) 정기점검을 통해 현재 진행되고 있는
‘7주년 치트키! SSS 행운 상점’의 참여 가능 기간이 변경될 예정입니다. 
 
■ 5/15(목...
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tr ">
                                        <a href="/news/notice/view?n4ArticleSN=5390">
                                            <span class="td sort">공지</span>
                                            <span class="td subject">모두의 판타지 이벤트 얼리버드 넥슨캐시 당첨자 발표  </span>
                                            <span class="td date">5.15(목)</span>
                                            <span class="td count">44,635</span>
                                        </a>
                                        <div class="hidden_desc" style="left: 394px; display: none;">
                                            <div class="text_box">
                                                안녕하세요. GM 네로입니다.
 
												4/25(금) ~ 5/9(금) 진행된 모두의 판타지 이벤트의 얼리버드 미션 
												넥슨캐시 당첨 구단주님을 안내해드립니다. [이벤트 바로가기]
 
												아래 당...
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tr ">
                                        <a href="/news/notice/view?n4ArticleSN=5389">
                                            <span class="td sort">공지</span>
                                            <span class="td subject">NO.7 LEGENDS 투표 추첨 이벤트 당첨자 발표  </span>
                                            <span class="td date">5.15(목)</span>
                                            <span class="td count">23,323</span>
                                        </a>
                                        <div class="hidden_desc" style="left: 394px; display: none;">
                                            <div class="text_box">
                                                안녕하세요. GM 네로입니다. 
 
4/24(목) ~ 4/30(수) 진행된 NO.7 LEGENDS 투표 추첨 이벤트에 당첨되신 
7명의 구단주님을 안내해 드립니다. [이벤트 바로가기]
 
...
                                            </div>
                                        </div>
                                    </div>
                                                            </div>
                        </div>
                    </div>
                </div>

                <div class="pagination">
                    <div class="pagination_wrap"><a href="javascript:;" onclick="Article.ArticleList(this,1,'#divListPart','','','0','1','/news/notice');" class="btn_first"><span class="ico ico_slide_first"></span></a><a href="javascript:;" class="btn_prev_list"><span class="ico ico_slide_prev"></span></a><a href="javascript:;" class="btn_prev"><span class="txt"><strong>이전</strong></span></a><ul><li class="active"><a href="javascript:;" class="btn_num"><span>1</span></a></li><li><a href="javascript:;" onclick="Article.ArticleList(this,2,'#divListPart','','','0','1','/news/notice');" class="btn_num"><span>2</span></a></li><li><a href="javascript:;" onclick="Article.ArticleList(this,3,'#divListPart','','','0','1','/news/notice');" class="btn_num"><span>3</span></a></li><li><a href="javascript:;" onclick="Article.ArticleList(this,4,'#divListPart','','','0','1','/news/notice');" class="btn_num"><span>4</span></a></li><li><a href="javascript:;" onclick="Article.ArticleList(this,5,'#divListPart','','','0','1','/news/notice');" class="btn_num"><span>5</span></a></li><li><a href="javascript:;" onclick="Article.ArticleList(this,6,'#divListPart','','','0','1','/news/notice');" class="btn_num"><span>6</span></a></li><li><a href="javascript:;" onclick="Article.ArticleList(this,7,'#divListPart','','','0','1','/news/notice');" class="btn_num"><span>7</span></a></li><li><a href="javascript:;" onclick="Article.ArticleList(this,8,'#divListPart','','','0','1','/news/notice');" class="btn_num"><span>8</span></a></li><li><a href="javascript:;" onclick="Article.ArticleList(this,9,'#divListPart','','','0','1','/news/notice');" class="btn_num"><span>9</span></a></li><li><a href="javascript:;" onclick="Article.ArticleList(this,10,'#divListPart','','','0','1','/news/notice');" class="btn_num"><span>10</span></a></li></ul><a href="javascript:;" onclick="Article.ArticleList(this,2,'#divListPart','','','0','1','/news/notice');" class="btn_next"><span class="txt">다음</span></a><a href="javascript:;" onclick="Article.ArticleList(this,11,'#divListPart','','','0','1','/news/notice');" class="btn_next_list"><span class="ico ico_slide_next"></span></a><a href="javascript:;" onclick="Article.ArticleList(this,207,'#divListPart','','','0','1','/news/notice');" class="btn_last"><span class="ico ico_slide_last"></span></a></div>
                </div>
            </div>
</body>
</html>