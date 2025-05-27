<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<div class="modal fade" id="regionModal" tabindex="-1" aria-labelledby="regionModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="regionModalLabel">지역별 관광지</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3 d-flex flex-wrap gap-2">
                    <button class="btn btn-outline-primary" onclick="showCountries('asia')">아시아</button>
                    <button class="btn btn-outline-primary" onclick="showCountries('europe')">유럽</button>
                    <button class="btn btn-outline-primary" onclick="showCountries('americas')">아메리카</button>
                    <button class="btn btn-outline-primary" onclick="showCountries('oceania')">오세아니아</button>
                    <button class="btn btn-outline-primary" onclick="showCountries('africa')">아프리카</button>
                </div>
                <div id="countryList" class="d-flex flex-wrap gap-2"></div>
            </div>
        </div>
    </div>
</div>
