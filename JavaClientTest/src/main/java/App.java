import ch.kuon.phoenix.Socket;
import ch.kuon.phoenix.Channel;
import ch.kuon.phoenix.Presence;
import com.github.openjson.JSONObject;

import java.util.HashMap;

public class App {

    public static void main(String[] args) {

        // https://git.goyman.com/kuon/java-phoenix-channel

        Socket.Options opts = new Socket.Options();
        opts.setTimeout(5000);
        opts.setHeartbeatIntervalMs(100000);
        opts.setRejoinAfterMs((tries) -> tries * 500);
        opts.setReconnectAfterMs((tries) -> tries * 500);
        opts.setLogger((tag, msg) ->
            {
                System.out.println(tag.toString() + " " + msg);
                return null;
            });
        HashMap<String, Object> params = new HashMap<>();
        opts.setParams(params);

        Socket socket = new Socket("ws://149.202.42.98:4000/socket", opts);
        socket.connect();

        socket.onError((String msg) -> {
            System.out.println("There was an error with the connection!");
            return null;
        });
        socket.onClose((Integer code, String msg) -> {
            System.out.println("The connection closed!");
            return null;
        });

        Channel ch = socket.channel("auth:lobby", new JSONObject());

        ch.join(5000);

        while(true) {
            ch.push("shout", new JSONObject("{}"), socket.getOpts().getTimeout()).receive("ok", (msg) -> {
                System.out.println("OK MAGGLE");
                return null;
            });
        }


    }
}
