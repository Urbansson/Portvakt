package se.portvakt.server.init;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;
import java.net.SocketException;
import java.net.SocketTimeoutException;

public class RegisterNewConnection implements Runnable{

	private Socket client;
	private String line,input;

	public RegisterNewConnection(Socket client) {
		this.client=client;
	}


	@Override
	public void run() {
		input ="";
		try {
			// Get input from the client
			
			BufferedReader in = new BufferedReader(new InputStreamReader(client.getInputStream()));
			DataOutputStream out = new DataOutputStream(client.getOutputStream());

			while((line = in.readLine()) != null) {
				if(line.toLowerCase().contains("done".toLowerCase()))
					break;
				else
					input += line;
			}
			
			System.out.println("Data Recived sending to Client");
			out.writeUTF(input+"\n".toUpperCase());
			System.out.println("Recived:" + input);
			
		}catch (IOException ioe) {
			System.out.println("IOException on socket listen: " + ioe);
			ioe.printStackTrace();
		}
	}
}
