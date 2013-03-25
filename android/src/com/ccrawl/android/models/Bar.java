package com.ccrawl.android.models;




public class Bar {
	protected String id;
	protected String name;
	protected String address;
	protected String description;
	protected String logo;
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getWebsite() {
		return website;
	}

	public void setWebsite(String website) {
		this.website = website;
	}

	public String getQuickLogoPath() {
		return quickLogoPath;
	}

	public void setQuickLogoPath(String quickLogoPath) {
		this.quickLogoPath = quickLogoPath;
	}

	public String getDetailedLogoPath() {
		return detailedLogoPath;
	}

	public void setDetailedLogoPath(String detailedLogoPath) {
		this.detailedLogoPath = detailedLogoPath;
	}

	public double getLongitude() {
		return longitude;
	}

	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}

	public double getLatitude() {
		return latitude;
	}

	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}

	protected String website;
	protected String quickLogoPath;
	protected String detailedLogoPath;
	protected double longitude;
	protected double latitude;
	
	
	public Bar(){
		
	}
	
	public Bar(String id){
		this.id = id;
	}
	
	public String getDescription() {
		return description;
	}
	
	public void setDescription(String description) {
		this.description = description;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getLogo() {
		return logo;
	}

	public void setLogo(String logo) {
		this.logo = logo;
	}
	
	public String toString(){
		return this.name;
	}
	
}
