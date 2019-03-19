// package fu.cap.travelin.util;
//
// import java.io.Serializable;
// import java.util.ArrayList;
// import java.util.List;
//
// import javax.websocket.OnClose;
// import javax.websocket.OnMessage;
// import javax.websocket.OnOpen;
// import javax.websocket.Session;
// import javax.websocket.server.ServerEndpoint;
//
// @ServerEndpoint("/nt")
// public class WebSocketNotification implements Serializable {
// static List<Session> sessions = new ArrayList<Session>();
//
// @OnMessage
// public void messageReciever(String msg) {
// System.out.println("Received msg: " + msg);
// }
//
// @OnOpen
// public void onOpen(Session session) {
// System.out.println("onOpen: " + session.getId());
// sessions.add(session);
// System.out.println("onOpen: Notification list size: " + sessions.size());
// }
//
// @OnClose
// public void onClose(Session session) {
// System.out.println("onClose: " + session.getId());
// sessions.remove(session);
// }
//
// public static List<Session> getSessions() {
// return sessions;
// }
//
// public static void setSessions(ArrayList<Session> sessions) {
// WebSocketNotification.sessions = sessions;
// }
// }
