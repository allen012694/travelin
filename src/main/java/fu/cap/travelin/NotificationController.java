package fu.cap.travelin;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import fu.cap.travelin.dao.NotificationDAO;
import fu.cap.travelin.dao.RelationshipDAO;
import fu.cap.travelin.model.Account;
import fu.cap.travelin.model.Notification;
import fu.cap.travelin.model.NotificationObject;
import fu.cap.travelin.model.Relationship;

@SessionAttributes({ "currentAccount" })
@Controller
public class NotificationController {
    @Resource(name = "travelinProp")
    private Properties travelinProp;

    @Autowired
    private SimpMessagingTemplate template;

    @Autowired
    private NotificationDAO notificationDao;

    @Autowired
    private RelationshipDAO relationshipDao;

    // Dummy currentAccount
    @ModelAttribute("currentAccount")
    public Account populateAccount() {
        return new Account(); // populates account for the first time if null
    }

    @RequestMapping(value = "/noti/ack", method = RequestMethod.POST)
    @ResponseBody
    public String ackNoti(@RequestParam("noid") String notiId, @RequestParam("notiobjtype") String notiObjType,
            @RequestParam(name = "answer", required = false) String answer,
            @ModelAttribute("currentAccount") Account currentAccout) {
        notificationDao.updateSeenNotification(Integer.parseInt(notiId));
        List<Notification> notis = null;
        // relationship notification process
        if ("relationship".equals(notiObjType)) {
            Notification noti = notificationDao.getNotificationById(Integer.parseInt(notiId));
            Relationship rs = relationshipDao.getRelationshipById(noti.getDetailobjectid());
            if ("y".equalsIgnoreCase(answer)) {
                relationshipDao.acceptRelationship(rs.getId());
                NotificationObject notiObj = notificationDao.getNotiObjByTypeAndAccount("relationship",
                        rs.getAccountfirst().getId());
                notificationDao
                        .insertNotification(new Notification(notiObj, "accept", rs.getAccountsecond(), 1, rs.getId()));
                notis = notificationDao.getNotificationsForAccount(rs.getAccountfirst().getId());
                template.convertAndSend("/topic/nt/" + rs.getAccountfirst().getId(), notis);
            } else if ("n".equalsIgnoreCase(answer)) {
                relationshipDao.deleteRelationship(rs);
            }
        }

        notis = notificationDao.getNotificationsForAccount(currentAccout.getId());
        template.convertAndSend("/topic/nt/" + currentAccout.getId(), notis);
        return "{\"msg\":\"success\"}";
    }
}
