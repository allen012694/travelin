package fu.cap.travelin;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;

import fu.cap.travelin.dao.AccountDAO;
import fu.cap.travelin.dao.MessageDAO;
import fu.cap.travelin.dao.NotificationDAO;
import fu.cap.travelin.dao.RelationshipDAO;
import fu.cap.travelin.model.Account;
import fu.cap.travelin.model.Place;

@SessionAttributes({ "currentAccount", "currentPlaces" })
@Controller
public class ErrorController {
    @Resource(name = "travelinProp")
    private Properties travelinProp;

    // private TaskScheduler scheduler = new ConcurrentTaskScheduler();
    // public Map<Integer, ClientWatcher> watchers = new HashMap<Integer,
    // ClientWatcher>();

    @Autowired
    private SimpMessagingTemplate template;

    @Autowired
    public AccountDAO accountDao;

    @Autowired
    public RelationshipDAO relationshipDao;

    @Autowired
    public NotificationDAO notificationDao;

    @Autowired
    public MessageDAO messageDao;

    private final String[] NOTI_OBJECT_TYPE = { "journal", "message", "relationship", "place", "feedback", "article",
            "account" };

    // Dummy currentAccount
    @ModelAttribute("currentAccount")
    public Account populateAccount() {
        return new Account(); // populates account for the first time if null
    }

    // Dummy currentPlaces
    @ModelAttribute("currentPlaces")
    public List<Place> populatePlaceList() {
        return new ArrayList<Place>(); // populates place list for the first
                                       // time if null
    }

    @RequestMapping(value = "/error", method = RequestMethod.GET)
    public String error(Model model, @ModelAttribute("currentAccount") Account currentAccount, Exception e) {
        model.addAttribute("exception", e);
        return "error";
    }

    @RequestMapping(value = "/500", method = RequestMethod.GET)
    public String error500(Model model, @ModelAttribute("currentAccount") Account currentAccount, Exception e) {
        model.addAttribute("exception", e);
        return "500";
    }

    @RequestMapping(value = "/404", method = RequestMethod.GET)
    public String error404(Model model, @ModelAttribute("currentAccount") Account currentAccount, Exception e) {
        model.addAttribute("exception", e);
        return "404";
    }

}
