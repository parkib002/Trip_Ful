<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관광지 차트</title>
  
    <script src="
https://cdn.jsdelivr.net/npm/echarts@5.6.0/dist/echarts.min.js
"></script>
    <script type="text/javascript">
        // x축과 y축 데이터는 그대로 유지됩니다.
        // 추후 이 데이터를 DB에서 조회하여 <% %> 스크립틀릿으로 동적으로 생성할 수 있습니다.
        let xAxisData = ['', '영희', '민수', '지수'];
        let seriesData = [70, 80, 100, 30];
        // 페이지가 모두 로드된 후 스크립트 실행
        window.onload = function() {
            // 버튼 클릭 이벤트 리스너 추가
            document.getElementById("drawLine").addEventListener('click', drawChart);
            document.getElementById("drawBar").addEventListener('click', drawChart);
        }
        // 차트를 그리는 함수
        function drawChart() {
            // id='chart'인 div 요소를 찾아 차트를 초기화합니다.
            var myChart = echarts.init(document.getElementById('chart'));
            // 차트 옵션 설정
            let option = {
                xAxis: {
                    type: 'category',
                    data: xAxisData // x축 데이터
                },
                yAxis: {
                    type: 'value'
                },
                series: [{
                    data: seriesData, // y축(값) 데이터
                    type: this.value // 클릭된 버튼의 value 값 ('line' 또는 'bar')
                }]
            };
            // 설정한 옵션으로 차트를 그립니다.
            myChart.setOption(option);
        }
    </script>
</head>
<body>
    <button id="drawLine" value="line">조회수</button>
    <button id="drawBar" value="bar">별점순</button>
    <button id="drawBar" value="bar">좋아요순</button>
    <div id="chart" style="width: 100%; height: 500px;"></div>
</body>
</html>