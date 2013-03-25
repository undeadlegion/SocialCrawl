package com.ccrawl.android.fetchers;

import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.ccrawl.android.models.Bar;

public class BarsFetcher {
	
	public static String url = "http://groovegene.com/cs428/DatabaseInteraction/DataRequest.php?type=bars&school_id=12";
	
	public static List<Bar> getAll(){
		
		List<Bar> bars = new ArrayList<Bar>();
		
		try {
			URL barsUrl = new URL(url);
			URLConnection connection = barsUrl.openConnection();
			DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
			Document barsXML = builder.parse( connection.getInputStream() );
			
			NodeList barNodes  = barsXML.getElementsByTagName("Bar");
			for(int i=0;i<barNodes.getLength();i++){
				Node barNode = barNodes.item(i);
				//long id = Long.parseLong( barNode.getAttributes().getNamedItem("id").toString() );
				NodeList children = barNode.getChildNodes();
				String id = barNode.getAttributes().getNamedItem("id").toString();
				Bar current = new Bar(id);
				
				for(int j=0;j<children.getLength();j++){
					Node item = children.item(j);
					if( item.getChildNodes().getLength() < 1) continue;
					
					String name = item.getNodeName();
					String value = item.getChildNodes().item(0).getNodeValue();

					
					if( name.equals("name") ){
						current.setName( value );
					} else if( name.equals("address") ){
						current.setAddress( value );
					} else if( name.equals("description") ){
						current.setDescription( value );
					} else if( name.equals("website")){
						current.setWebsite(value);
					} else if( name.equals("quicklogo")){
						current.setQuickLogoPath(value);
					} else if( name.equals("detailedlogo")){
						current.setDetailedLogoPath(value);
					} else if( name.equals("longitude")){
						current.setLongitude(Double.valueOf(value));
					} else if( name.equals("latitude")){
						current.setLatitude(Double.valueOf(value));
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
