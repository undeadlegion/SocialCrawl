package com.ccrawl.android;

import java.util.List;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.Toast;

import com.ccrawl.android.fetchers.BarsForEventFetcher;
import com.ccrawl.android.models.BarForEvent;
import com.ccrawl.android.models.Event;

public abstract class EventBarsActivity extends Activity {
    protected ListView barsList;
    protected List<BarForEvent> bars;
    protected View loadingView;
    protected FetchBarsTask fetcher = new FetchBarsTask();
    
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.events);
        
        barsList = (ListView) findViewById(R.id.barListView);
        loadingView = findViewById(R.id.loadingView);
        fetcher.execute();
    }
    
    private class FetchBarsTask extends AsyncTask<Event, Object, List<BarForEvent> > {

		@Override
		protected List<BarForEvent> doInBackground(Event... events) {
			return BarsForEventFetcher.getBarsForEvent(events[0]);
		}
		
		protected void onPostExecute(List<BarForEvent> result) {
	    	 //TODO do something with the result here
		}
    }
}