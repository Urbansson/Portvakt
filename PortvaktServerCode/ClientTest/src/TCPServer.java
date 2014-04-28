import java.io.*;
import java.net.*; 

class TCPServer {
	
	  private static int port=6780, maxConnections=0;

	
	public static void main(String argv[]) throws Exception
	{       
		String clientSentence;          
		String capitalizedSentence;  

		ServerSocket serverSocket = new ServerSocket(port);       
		Socket clientSocket;

		int i = 0;
		
		while(i++<maxConnections||maxConnections==0)          
		{
			clientSocket = serverSocket.accept();
			System.out.println(clientSocket.getRemoteSocketAddress()+" connected\n");
			clientSocket.close();
		}
		
		serverSocket.close();

		
//		int i = 1;
//		
//		while(i==1)          
//		{             
//			Socket connectionSocket = welcomeSocket.accept();             
//			BufferedReader inFromClient =                
//					new BufferedReader(new InputStreamReader(connectionSocket.getInputStream()));
//			DataOutputStream outToClient = new DataOutputStream(connectionSocket.getOutputStream());           
//			clientSentence = inFromClient.readLine();          
//			System.out.println("Received: " + clientSentence);     
//			capitalizedSentence = clientSentence.toUpperCase() + '\n';    
//			outToClient.writeBytes(capitalizedSentence);          
//		}  
//		welcomeSocket.close();
	} 
} 