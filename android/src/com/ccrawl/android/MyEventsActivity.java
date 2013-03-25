package com.ccrawl.android;

import java.util.List;

import android.view.Menu;

import com.ccrawl.android.fetchers.EventsFetcher;
import com.ccrawl.android.models.Event;

public class MyEventsActivity extends EventsActivity {

	@Override
	public List<Event> getEvents() {
		// Jamie's Facebook id
		return EventsFetcher.getPrivate( "754465610" );
	}
	
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
    	super.onCreateOptionsMenu(menu);
        menu.findItem(R.id.myCrawlsMenuItem).setEnabled(false);
        return true;
    }
    

}
