package se.portvakt.server.init;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;

public class HelloConnection implements Runnable{

    private Socket client;

    private String line,input;

	public HelloConnection(Socket client) {
		this.client=client;
	}
	
	
	@Override
	public void run() {
		input ="";
	      try {
	          // Get input from the client
	  		BufferedReader in = new BufferedReader(new InputStreamReader(client.getInputStream()));
	  		DataOutputStream out = new DataOutputStream(client.getOutputStream());

	          while((line = in.readLine()) != null && !line.equals("\n")) {
	            input=input + line;
	            out.writeBytes(input);          
	          }

	          client.close();
	        } catch (IOException ioe) {
	          System.out.println("IOException on socket listen: " + ioe);
	          ioe.printStackTrace();
	        }
	}

}
