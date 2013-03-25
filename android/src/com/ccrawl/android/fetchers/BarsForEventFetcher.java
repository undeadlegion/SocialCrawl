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

import com.ccrawl.android.models.BarForEvent;
import com.ccrawl.android.models.Event;

public class BarsForEventFetcher {
//	public static String barsForEventString  = "http://groovegene.com/cs428/DatabaseInteraction/DataRequest.php?type=eventsforid&id=";
	
	public static List<BarForEvent> getBarsForEvent(Event e){
		return BarsForEventFetcher.parse(Constants.barsForEventRequestString + e.getId());
	}
	
	private static List<BarForEvent> parse (String url){
		
		List<BarForEvent> bars = new ArrayList<BarForEvent>();
		
		try {
			URL eventsUrl = new URL(url);
			URLConnection connection = eventsUrl.openConnection();
			DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
			Document barForEventXML = builder.parse( connection.getInputStream() );
			
			NodeList barForEventNodes  = barForEventXML.getElementsByTagName("Event");
			for(int i=0;i<barForEventNodes.getLength();i++){
				Node barForEventNode = barForEventNodes.item(i);
				
				String id = barForEventNode.getAttributes().getNamedItem("id").getNodeValue();
				NodeList children = barForEventNode.getChildNodes();
				
				BarForEvent current = new BarForEvent();
				current.setBarId(id);

				for(int j=0;j<children.getLength();j++){
					Node item = children.item(j);
					if( item.getChildNodes().getLength() < 1) continue;
					
					String name = item.getNodeName();
					String value = item.getChildNodes().item(0).getNodeValue();

					
					if( name.equals("time") ){
						SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
						current.setTime( df.parse(value) );
					}
				}
				bars.add(current);
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return bars;
		
	}
}
