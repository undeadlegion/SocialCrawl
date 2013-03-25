package com.ccrawl.android;

import java.util.HashMap;
import java.util.Map;

import com.ccrawl.android.models.Bar;

import android.app.Application;

public class CampusCrawlerApp extends Application {
	public Map<String, Bar> bars = new HashMap<String, Bar>();
}