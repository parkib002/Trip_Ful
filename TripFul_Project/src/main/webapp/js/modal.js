document.addEventListener('DOMContentLoaded', () => {
    const authButton = document.getElementById('auth-button');
    const welcomeText = document.getElementById('welcome-text');
    let loggedIn = false;

    authButton.addEventListener('click', () => {
        loggedIn = !loggedIn;
        if (loggedIn) {
            welcomeText.textContent = 'taelim34 님 환영합니다';
            authButton.textContent = 'Logout';
            authButton.classList.remove('btn-yellow');
            authButton.classList.add('btn-danger');
        } else {
            welcomeText.textContent = '로그인을 해주세요';
            authButton.textContent = 'Login';
            authButton.classList.remove('btn-danger');
            authButton.classList.add('btn-yellow');
        }
    });

    window.showCountries = function (continent) {
        const countriesByContinent = {
            asia: ['대한민국', '일본', '중국', '태국', '베트남'],
            europe: ['프랑스', '영국', '이탈리아', '독일', '스페인'],
            americas: ['미국', '캐나다', '브라질', '멕시코', '아르헨티나'],
            oceania: ['호주', '뉴질랜드', '피지'],
            africa: ['이집트', '남아프리카공화국', '모로코', '케냐']
        };

        const container = document.getElementById('countryList');
        container.innerHTML = '';
        countriesByContinent[continent].forEach(country => {
            const btn = document.createElement('a');
            btn.className = 'btn btn-outline-secondary';
            btn.href = 'country.jsp?name=' + encodeURIComponent(country);
            btn.textContent = country;
            container.appendChild(btn);
        });
    }
});
