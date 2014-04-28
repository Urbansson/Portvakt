package se.portvakt.server.init;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

public class Initialization {

	private static int port=6780;

	public static void main(String[] args) {

		 int i=1;

		    try{
		      ServerSocket listener = new ServerSocket(port);
		      Socket server;

		      while(1==i){
		    	  
		    	System.out.println("Waiting for connection!");
		        server = listener.accept();
		        System.out.println("connection from "+server.getRemoteSocketAddress());

		        RegisterNewConnection conn = new RegisterNewConnection(server);
		       // doComms conn_c= new doComms(server);
		        Thread t = new Thread(conn);
		        t.start();  
		        
		      }
		      listener.close();
		    } catch (IOException ioe) {
		      System.out.println("IOException on socket listen: " + ioe);
		      ioe.printStackTrace();
		    }
		

	}

}
