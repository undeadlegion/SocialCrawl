package com.ccrawl.android;

import java.util.List;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.ccrawl.android.models.Event;
import com.ocpsoft.pretty.time.PrettyTime;

public class EventListAdapter extends ArrayAdapter<Event> {

	protected List<Event> events;
	protected int textViewResourceId;
	protected Context context;
	
	public EventListAdapter(Context context, int textViewResourceId, List<Event> events) {
		super(context, textViewResourceId, events);
		this.events = events;
		this.textViewResourceId = textViewResourceId;
		this.context = context;
	}

	@Override
    public View getView(int position, View view, ViewGroup parent) { 
    	Event event = events.get(position);
    	
        LayoutInflater inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        
        // recycle an old view if we can...
        if( view == null ){
        	view = inflater.inflate(textViewResourceId, null, true);
        }
        
        TextView title = (TextView) view.findViewById( R.id.event_title );
        TextView date = (TextView) view.findViewById( R.id.event_date );
        
        title.setText( event.getTitle() );
        PrettyTime dateFormatter = new PrettyTime();
        
        date.setText( dateFormatter.format( event.getDate() ) );
        return view;
    }

}
