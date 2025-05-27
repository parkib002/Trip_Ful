<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Dongle&family=Nanum+Brush+Script&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>

<title>Insert title here</title>
<script src="https://cdn.tailwindcss.com"></script>
    <style>
        .menu {
            display: none;
            position: absolute;
            background-color: white;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            z-index: 10;
        }
        .menu-item:hover .menu {
            display: block;
        }
       .blurred-image {
            background-image: url('../image/IMG_0104.JPEG');
            background-size: contain; /* 이미지 비율 유지하며 전체 표시 */
            background-repeat: no-repeat;
            background-position: center;
            filter: blur(0px);
            width: 100%; /* 부모 요소 크기에 맞게 조정 */
            height: 300px; /* 필요 시 이 높이를 비율로 설정 */
}


.container {
    width: 150%;
    height: 50vh; /* 화면 크기에 비례하도록 설정 */
    display: flex;
    justify-content: center;
    align-items: center;
}
    </style>
</head>
<body class="bg-gray-100 text-gray-800">
    <header class="flex justify-between items-center p-4 bg-white shadow">
        <div class="cursor-pointer" onclick="location.reload()">
            <img src="../image/tripful.png" alt="Logo" class="h-12">
        </div>
        <nav class="relative">
            <ul class="flex space-x-4">
                <li class="menu-item relative">
                    <button class="px-4 py-2 bg-gray-200 rounded">Menu 1</button>
                    <ul class="menu p-2">
                        <li class="p-2 hover:bg-gray-100">Submenu 1-1</li>
                        <li class="p-2 hover:bg-gray-100">Submenu 1-2</li>
                    </ul>
                </li>
                <li class="menu-item relative">
                    <button class="px-4 py-2 bg-gray-200 rounded">Menu 2</button>
                    <ul class="menu p-2">
                        <li class="p-2 hover:bg-gray-100">Submenu 2-1</li>
                        <li class="p-2 hover:bg-gray-100">Submenu 2-2</li>
                    </ul>
                </li>
                <li class="menu-item relative">
                    <button class="px-4 py-2 bg-gray-200 rounded">Menu 3</button>
                    <ul class="menu p-2">
                        <li class="p-2 hover:bg-gray-100">Submenu 3-1</li>
                        <li class="p-2 hover:bg-gray-100">Submenu 3-2</li>
                    </ul>
                </li>
                <li class="menu-item relative">
                    <button class="px-4 py-2 bg-gray-200 rounded">Menu 4</button>
                    <ul class="menu p-2">
                        <li class="p-2 hover:bg-gray-100">Submenu 4-1</li>
                        <li class="p-2 hover:bg-gray-100">Submenu 4-2</li>
                    </ul>
                </li>
            </ul>
        </nav>
        <div>
            <span id="welcome-text" class="mr-4">로그인을 해주세요</span>
            <button id="auth-button" class="px-4 py-2 bg-blue-500 text-white rounded">Login</button>
        </div>
    </header>
    <main class="p-4">
        <div class="blurred-image flex items-center justify-center container">
            
        </div>
    </main>
    <footer class="bg-black text-white p-4">
        <p>Address: 1234 Street, City, Country</p>
        <p>Tel: +123 456 7890</p>
    </footer>
    <script type="module">
        const authButton = document.getElementById('auth-button');
        const welcomeText = document.getElementById('welcome-text');
        let loggedIn = false;

        authButton.addEventListener('click', () => {
            loggedIn = !loggedIn;
            if (loggedIn) {
                welcomeText.textContent = 'taelim34 님 환영합니다';
                authButton.textContent = 'Logout';
            } else {
                welcomeText.textContent = '로그인을 해주세요';
                authButton.textContent = 'Login';
            }
        });
    </script>
</body>
</html>
