package com.ccrawl.android.models;

import java.util.Date;

import android.os.Parcel;
import android.os.Parcelable;

public class Event implements Parcelable{
    
	protected String id;
	protected String creatorid;
	protected Date date;
	protected String title;
	protected String description;
	protected String picture;
	protected Boolean privacy;
	
	public Event(){}
	
	public Event(String id){
		this.id = id;
	}
	
	public String toString(){
		return title;
	}
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getCreatorid() {
		return creatorid;
	}

	public void setCreatorid(String creatorid) {
		this.creatorid = creatorid;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getPicture() {
		return picture;
	}

	public void setPicture(String picture) {
		this.picture = picture;
	}

	public boolean isPrivacy() {
		return privacy;
	}

	public void setPrivacy(boolean privacy) {
		this.privacy = privacy;
	}
	
    public static final Parcelable.Creator<Event> CREATOR = new Parcelable.Creator<Event>() {
		public Event createFromParcel(Parcel in) {
		    return new Event(in);
		}
		
		public Event[] newArray(int size) {
		    return new Event[size];
		}
    };
    
    private Event(Parcel p){
    	id = p.readString();
    	creatorid = p.readString();
    	date = (Date) p.readSerializable();    	
    	title = p.readString();
    	description = p.readString();
    	picture = p.readString();
    	privacy = (Boolean) p.readSerializable();
    }

	@Override
	public int describeContents() {
		// apparently we need to override this?
		return 0;
	}

	@Override
	public void writeToParcel(Parcel p, int flags) {
		p.writeString( id );
		p.writeString( creatorid );
		p.writeSerializable( date );
		p.writeString( title );
		p.writeString( description );
		p.writeString( picture );
		p.writeSerializable( privacy );
	}
	
}
