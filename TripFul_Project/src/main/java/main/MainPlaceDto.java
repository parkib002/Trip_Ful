package main;

public class MainPlaceDto {
    private String placeNum;
    private String countryName;
    private String placeImg;
    private String placeContent;
    private String placeTag;
    private String placeCode;
    private String placeName;
    private int placeCount;
    private String continentName;

    public MainPlaceDto() {}

    public MainPlaceDto(String placeNum, String countryName, String placeImg, String placeContent,
                        String placeTag, String placeCode, String placeName,
                        int placeCount, String continentName) {
        this.placeNum = placeNum;
        this.countryName = countryName;
        this.placeImg = placeImg;
        this.placeContent = placeContent;
        this.placeTag = placeTag;
        this.placeCode = placeCode;
        this.placeName = placeName;
        this.placeCount = placeCount;
        this.continentName = continentName;
    }

    // Getters & Setters
    public String getPlaceNum() {
        return placeNum;
    }

    public void setPlaceNum(String placeNum) {
        this.placeNum = placeNum;
    }

    public String getCountryName() {
        return countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    public String getPlaceImg() {
        return placeImg;
    }

    public void setPlaceImg(String placeImg) {
        this.placeImg = placeImg;
    }

    public String getPlaceContent() {
        return placeContent;
    }

    public void setPlaceContent(String placeContent) {
        this.placeContent = placeContent;
    }

    public String getPlaceTag() {
        return placeTag;
    }

    public void setPlaceTag(String placeTag) {
        this.placeTag = placeTag;
    }

    public String getPlaceCode() {
        return placeCode;
    }

    public void setPlaceCode(String placeCode) {
        this.placeCode = placeCode;
    }

    public String getPlaceName() {
        return placeName;
    }

    public void setPlaceName(String placeName) {
        this.placeName = placeName;
    }

    public int getPlaceCount() {
        return placeCount;
    }

    public void setPlaceCount(int placeCount) {
        this.placeCount = placeCount;
    }

    public String getContinentName() {
        return continentName;
    }

    public void setContinentName(String continentName) {
        this.continentName = continentName;
    }
}
