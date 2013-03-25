package com.ccrawl.android.fetchers;

import java.net.URL;
import java.net.URLConnection;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.ccrawl.android.models.Event;

public class EventsFetcher {
	
	public static String publicUrl = "http://groovegene.com/cs428/DatabaseInteraction/DataRequest.php?type=events";
	public static String privateUrl  = "http://groovegene.com/cs428/DatabaseInteraction/DataRequest.php?type=eventsforid&id=";
	
	public static List<Event> getPublic(){
		return EventsFetcher.getAll( publicUrl );
	}
	
	public static List<Event> getPrivate(String facebookId){
		return EventsFetcher.getAll( privateUrl + facebookId );
	}
	
	protected static List<Event> getAll(String url){
		
		List<Event> events = new ArrayList<Event>();
		
		try {
			URL eventsUrl = new URL(url);
			URLConnection connection = eventsUrl.openConnection();
			DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
			Document eventsXML = builder.parse( connection.getInputStream() );
			
			NodeList eventNodes  = eventsXML.getElementsByTagName("Event");
			for(int i=0;i<eventNodes.getLength();i++){
				Node eventNode = eventNodes.item(i);
				
				String id = eventNode.getAttributes().getNamedItem("id").getNodeValue();
				NodeList children = eventNode.getChildNodes();
				
				Event current = new Event(id);

				for(int j=0;j<children.getLength();j++){
					Node item = children.item(j);
					if( item.getChildNodes().getLength() < 1) continue;
					
					String name = item.getNodeName();
					String value = item.getChildNodes().item(0).getNodeValue();

					
					if( name.equals("creatorid") ){
						current.setCreatorid( value );
					} else if( name.equals("date") ){
						SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
						current.setDate( df.parse(value) );
					} else if( name.equals("title") ){
						current.setTitle( value );
					} else if( name.equals("description") ){
						current.setDescription( value );
					} else if( name.equals("picture") ){
						current.setPicture( value );
					} else if( name.equals("privacy") ){
						current.setPrivacy( value.equals("1") );
					} 
				}
				events.add(current);
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return events;
		
	}
}
