package javareflx.standard_services;

import java.io.*;
import java.net.*;

import javareflx.bri.Service;

// rien à ajouter ici
public class ServiceInversion implements Service {
	
	private final Socket client;
	
	public ServiceInversion(Socket socket) {
		client = socket;
	}

	@Override
	public void run() {
		try {BufferedReader in = new BufferedReader (new InputStreamReader(client.getInputStream ( )));
			PrintWriter out = new PrintWriter (client.getOutputStream ( ), true);

			out.println("Tapez un texte à inverser");
		
			String line = in.readLine();		
	
			String invLine = new String (new StringBuffer(line).reverse());
			
			out.println(invLine);
			
			client.close();
		}
		catch (IOException e) {
			//Fin du service d'inversion
		}
	}
	
	protected void finalize() throws Throwable {
		 client.close(); 
	}

	public static String toStringue() {
		return "Inversion de texte";
	}
}
