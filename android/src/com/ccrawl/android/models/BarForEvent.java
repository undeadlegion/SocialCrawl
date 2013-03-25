package com.ccrawl.android.models;

import java.util.Date;
                            
public class BarForEvent {
	private String barId;
	private Date time;
	
	public String getBarId() {
		return barId;
	}
	public void setBarId(String barId) {
		this.barId = barId;
	}
	public Date getTime() {
		return time;
	}
	public void setTime(Date time) {
		this.time = time;
	}
}
