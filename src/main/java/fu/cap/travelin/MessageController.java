package fu.cap.travelin;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import fu.cap.travelin.dao.AccountDAO;
import fu.cap.travelin.dao.MessageDAO;
import fu.cap.travelin.dao.RelationshipDAO;
import fu.cap.travelin.model.Account;
import fu.cap.travelin.model.Conversation;
import fu.cap.travelin.model.Message;

@SessionAttributes({ "currentAccount" })
@Controller
public class MessageController {
    // private TaskScheduler scheduler = new ConcurrentTaskScheduler();
    @Autowired
    private SimpMessagingTemplate template;

    @Autowired
    private AccountDAO accountDao;

    @Resource(name = "travelinProp")
    private Properties travelinProp;

    @Autowired
    private MessageDAO messageDao;

    @Autowired
    private RelationshipDAO relationshipDao;

    // Dummy currentAccount
    @ModelAttribute("currentAccount")
    public Account populateAccount() {
        return new Account(); // populates account for the first time if null
    }

    // Show message list page
    @RequestMapping(value = "/messages", method = RequestMethod.GET)
    public String showMessages(Model model, @ModelAttribute("currentAccount") Account currentAccount,
            @RequestParam(name = "c", required = false) String conversTargetId,
            @RequestParam(name = "n", required = false) String needNewRoom) {
        if (null == currentAccount.getEmail())
            return "redirect:/login";

        // check redirect from target's profile page
        if (conversTargetId != null && conversTargetId.length() > 0) {
            messageDao.refreshConversationForAccount(Integer.parseInt(conversTargetId), currentAccount.getId());
            model.addAttribute("convid", conversTargetId);
        } else if (needNewRoom != null && needNewRoom.length() > 0) {
            // messageDao.requestNewConversationByAccount( );
            // Request new conversation but available only to the host
            Conversation check = messageDao.getPrivateConversation(Integer.parseInt(needNewRoom),
                    currentAccount.getId());
            if (check != null) {
                messageDao.refreshConversationForAccount(check.getId(), currentAccount.getId());
                model.addAttribute("convid", check.getId());
            } else {
                Account acc1 = new Account();
                Account acc2 = new Account();
                acc1.setId(currentAccount.getId());
                acc2.setId(Integer.parseInt(needNewRoom));
                Conversation newConv = new Conversation(acc1, acc2, 2);
                messageDao.insertConversation(newConv);
                model.addAttribute("convid", newConv.getId());
            }
        } else {
            // Do nothing
        }

        List<Conversation> convs = messageDao.getAvailableConversationsForAccount(currentAccount.getId());
        Map<Integer, Integer> mapUnreadCount = new HashMap<Integer, Integer>();
        for (Conversation conversation : convs) {
            mapUnreadCount.put(conversation.getId(),
                    messageDao.checkUnreadInConversationTowardAccount(conversation.getId(), currentAccount.getId()));
        }

        model.addAttribute("conversations", convs);
        model.addAttribute("unreadCounts", mapUnreadCount);

        return "mymessages";
    }

    @RequestMapping(value = "/messages/searchsenders", method = RequestMethod.GET)
    @ResponseBody
    public List<Object> showMessagesBySearch(Model model, @RequestParam("k") String searchText,
            @ModelAttribute("currentAccount") Account currentAccount)

    {

        List<Account> searchAccountList = accountDao.getTopSearchAccountResult(searchText, 10);
        List<Integer> searchIdList = new ArrayList<Integer>();
        for (Account account : searchAccountList) {
            searchIdList.add(account.getId());
        }
        List<Object> list = new ArrayList<Object>();
        List<Conversation> convs = null;
        if (searchText.length() != 0) {
            convs = messageDao.getAvailableConversationsForAccountBySearch(currentAccount.getId(), searchIdList);
        } else {
            convs = messageDao.getAvailableConversationsForAccount(currentAccount.getId());
        }
        Map<Integer, Integer> mapUnreadCount = new HashMap<Integer, Integer>();
        for (Conversation conversation : convs) {
            mapUnreadCount.put(conversation.getId(),
                    messageDao.checkUnreadInConversationTowardAccount(conversation.getId(), currentAccount.getId()));
        }

        list.add(convs);
        list.add(mapUnreadCount);

        return list;
    }

    // Message redirect from profile page
    @RequestMapping(value = "/message", method = RequestMethod.GET)
    public String redirMessageRoom(Model model, @ModelAttribute("currentAccount") Account currentAccount,
            @RequestParam("t") String targetid) {
        Conversation conv = messageDao.getPrivateConversation(currentAccount.getId(), Integer.parseInt(targetid));

        if (conv != null) {
            // Conversation conv = convs.get(0);
            messageDao.updateConversation(conv);
            return "redirect:/messages?c=" + conv.getId();
        } else {
            return "redirect:/messages?n=" + targetid;
        }
    }

    // Get message for a specific
    @RequestMapping(value = "/messages/acquire", method = RequestMethod.POST)
    @ResponseBody
    public List<Message> acquireMessage(@ModelAttribute("currentAccount") Account currentAccount,
            @RequestParam("cid") String cid) {
        // List<Message> msgs =
        // messageDao.getConversationMessages(Integer.parseInt(cid));
        List<Message> msgs = messageDao.getConversationMessagesForAccount(
                messageDao.getConversationById(Integer.parseInt(cid)), currentAccount);
        return msgs;
    }

    @MessageMapping(value = "/msg/{accountid}")
    public void sendPrivateMessage(@DestinationVariable String accountid, Message msg) {
        msg.setIsread(false);
        msg.setDatastatus(3);
        messageDao.insertMessage(msg);
        Conversation targetConv = messageDao.getConversationById(msg.getConversation().getId());
        if (targetConv.getDatastatus() != 3) {
            targetConv.setDatastatus(3);
            messageDao.updateConversation(targetConv);
        }
        int targetid;
        if (targetConv.getAccountfirst().getId().intValue() == msg.getFromaccount().getId().intValue())
            targetid = targetConv.getAccountsecond().getId();
        else
            targetid = targetConv.getAccountfirst().getId();
        msg.setConversation(targetConv);
        List converUnseen = messageDao.getUnseenConversationForAccount(targetid);
        List<Object> deliverMsg = new ArrayList<Object>();
        deliverMsg.add(converUnseen);
        deliverMsg.add(msg);
        template.convertAndSend("/topic/remsg/" + targetid, deliverMsg);

    }

    @MessageMapping(value = "/seen/{accountid}")
    public void seenMsg(@DestinationVariable String accountid, String convid) {
        messageDao.seenMessageForAccount(Integer.parseInt(convid), Integer.parseInt(accountid));
        List<Object> deliverMsg = new ArrayList<Object>();
        deliverMsg.add(messageDao.getUnseenConversationForAccount(Integer.parseInt(accountid)));
        deliverMsg.add(null);
        template.convertAndSend("/topic/remsg/" + accountid, deliverMsg);
    }

    @RequestMapping(value = "/messages/notify", method = RequestMethod.POST)
    @ResponseBody
    public List getNotifyConversation(Model model, @RequestParam("aid") String accountId) {
        List list = messageDao.getUnseenConversationForAccount(Integer.parseInt(accountId));
        return list;
    }

    @RequestMapping(value = "/messages/delconv", method = RequestMethod.POST)
    @ResponseBody
    public String removeConversation(Model model, @RequestParam("convid") String convid,
            @ModelAttribute("currentAccount") Account currentAccount) {
        Conversation conv = messageDao.getConversationById(Integer.parseInt(convid));
        messageDao.seenMessageForAccount(conv.getId(), currentAccount.getId());
        messageDao.removeConversationFromAccountHistory(currentAccount, conv);
        return "{\"status\":1}";
    }
}
