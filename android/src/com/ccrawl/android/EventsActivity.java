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

import com.ccrawl.android.models.Event;

public abstract class EventsActivity extends Activity {
    protected ListView barsList;
    protected List<Event> events;
    protected View loadingView;
    protected FetchEventsTask fetcher = new FetchEventsTask();
    
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.events);
        
        barsList = (ListView) findViewById(R.id.barListView);
        loadingView = findViewById(R.id.loadingView);
        
        
        fetcher.execute();
        
        barsList.setClickable(true);

        barsList.setOnItemClickListener(new OnItemClickListener() {

            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            	
            	Event e = events.get(position);
            	
            	Intent i = new Intent(EventsActivity.this, EventActivity.class);
            	i.putExtra("event", e);
            	startActivity(i);
            	
            	Toast.makeText( EventsActivity.this,"Clicked: " + e.getTitle(), Toast.LENGTH_LONG).show();
            }
        });
        
    }
    
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
    	super.onCreateOptionsMenu(menu);
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.menu, menu);
        return true;
    }
    
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle item selection
        switch (item.getItemId()) {
	        case R.id.publicCrawlsMenuItem:
	            startActivity( new Intent(EventsActivity.this, PublicEventsActivity.class) );
	            return true;
	        case R.id.myCrawlsMenuItem:
	            startActivity( new Intent(EventsActivity.this, MyEventsActivity.class) );
	            return true;
	        default:
	            return super.onOptionsItemSelected(item);
        }
    }
    
    private class FetchEventsTask extends AsyncTask<Object, Object, List<Event> > {

		@Override
		protected List<Event> doInBackground(Object... params) {
			return getEvents();
		}
		
		protected void onPostExecute(List<Event> result) {
			 events = result;
	    	 ListAdapter adapter = new EventListAdapter(EventsActivity.this, R.layout.event_row, events);
	         barsList.setAdapter( adapter );
	         loadingView.setVisibility(View.GONE);
		}
    }
    
    public abstract List<Event> getEvents();
}