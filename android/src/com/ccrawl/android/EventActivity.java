package com.ccrawl.android;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

import com.ccrawl.android.models.Event;

public class EventActivity extends Activity{
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.event);
        Event e = (Event) getIntent().getExtras().getParcelable("event");
        
        TextView name = (TextView) findViewById( R.id.eventName );
        name.setText( e.getTitle() );
        
    }
    
}
