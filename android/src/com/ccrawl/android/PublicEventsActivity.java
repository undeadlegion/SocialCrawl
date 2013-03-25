package com.ccrawl.android;

import java.io.IOException;
import java.net.MalformedURLException;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.widget.ListView;

import com.ccrawl.android.fetchers.BarsFetcher;
import com.ccrawl.android.fetchers.EventsFetcher;
import com.ccrawl.android.models.Bar;
import com.ccrawl.android.models.Event;
import com.facebook.android.*;
import com.facebook.android.Facebook.*;


public class PublicEventsActivity extends EventsActivity {
    Facebook facebook = new Facebook("183973304975501");

    @Override
    public void onCreate(Bundle savedInstanceState) {
    	super.onCreate(savedInstanceState);
    	
//        setContentView(R.layout.main);
    	Log.v("LOOK BITCH", "About to authorize FB");
        facebook.authorize(this, new DialogListener() {
            @Override
            public void onComplete(Bundle values) {
            	Log.v("LOOK BITCH", " this is a message");
            	System.out.println("Values " + values);
            	
            	String result = "";
            	try {
					result = facebook.request("me");
					JSONObject obj = new JSONObject(result);
					String id = obj.getString("id");
					Log.v("LOOK BITCH", "id: " + id);

				} catch (Exception e) {
					e.printStackTrace();
				}
				
//            	String token = values.get("access token")
//            	System.out.println("Token:" + token);
            }

            @Override
            public void onFacebookError(FacebookError error) {
            	Log.v("LOOK BITCH", "FB error");

            }

            @Override
            public void onError(DialogError e) {
            	Log.v("LOOK BITCH", "on Error");

            }

            @Override
            public void onCancel() {
            	Log.v("LOOK BITCH", "On Cancel");

            }
        });
    	Log.v("LOOK BITCH", "about to load the bars");

    	// load up the bars for caching later
    	List<Bar> bars = BarsFetcher.getAll();
    	Map<String, Bar> cache = ((CampusCrawlerApp)getApplication() ).bars;
    	
    	for(Bar bar : bars){
    		cache.put( bar.getId() , bar);
    	}
    }
	@Override
	public List<Event> getEvents() {
		return EventsFetcher.getPublic();
	}
	
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
    	super.onCreateOptionsMenu(menu);
        menu.findItem(R.id.publicCrawlsMenuItem).setEnabled(false);
        return true;
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        facebook.authorizeCallback(requestCode, resultCode, data);
    }
}
