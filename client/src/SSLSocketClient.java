
import java.io.*;
import javax.net.ssl.*;


public class SSLSocketClient {

    public static void main(String[] args) throws Exception {
        try {
        	SSLContext sc = SSLContext.getInstance("SSL");  
            sc.init(null, new TrustManager[]{new SSLCertificateNuker()}, new java.security.SecureRandom());  
        	
            SSLSocketFactory factory = sc.getSocketFactory();
            SSLSocket socket = (SSLSocket) factory.createSocket("localhost", 3000);
            
            PrintWriter out = new PrintWriter(new BufferedWriter(new OutputStreamWriter(socket.getOutputStream())));

            BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));

            String inputLine;
            while ((inputLine = in.readLine()) != null)
                System.out.println(inputLine);
            
            in.close();
            out.close();
            socket.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}