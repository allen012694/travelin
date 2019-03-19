package fu.cap.travelin;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.multipart.MultipartFile;

import fu.cap.travelin.dao.AccountDAO;
import fu.cap.travelin.dao.MessageDAO;
import fu.cap.travelin.dao.NotificationDAO;
import fu.cap.travelin.dao.RelationshipDAO;
import fu.cap.travelin.model.Account;
import fu.cap.travelin.model.Notification;
import fu.cap.travelin.model.NotificationObject;
import fu.cap.travelin.model.Place;
import fu.cap.travelin.model.Relationship;

@SessionAttributes({ "currentAccount", "currentPlaces" })
@Controller
public class AccountController {
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

    // Stop scheduled task from sending more notification
    // public void stopScheduledTask(int keyid) {
    // if (watchers.containsKey(keyid)) {
    // System.out.println(watchers.get(keyid).toString());
    // watchers.get(keyid).setOver(true);
    // // threads.get(keyid).cancel(false);
    // // threads.get(keyid).stop();
    // // threads.get(keyid).destroy();
    // watchers.remove(keyid);
    // }
    // }

    // Delete an account action (status -1)
    @RequestMapping(value = "/accounts/del", method = RequestMethod.POST)
    // @ResponseBody
    @ResponseStatus(value = HttpStatus.OK)
    public void deleteAccount(@RequestParam("id") String accid, Model model) {
        Account acc = accountDao.getAccountById(Integer.parseInt(accid));
        acc.setDatastatus(-1);
        accountDao.updateAccount(acc);
    }

    // Deactivate account action (status 2)
    @RequestMapping(value = "/accounts/deactivate", method = RequestMethod.POST)
    // @ResponseBody
    @ResponseStatus(value = HttpStatus.OK)
    public void deactivateAccount(@RequestParam("id") String accid, Model model) {
        Account acc = accountDao.getAccountById(Integer.parseInt(accid));
        acc.setDatastatus(2);
        accountDao.updateAccount(acc);
        // return "Yeah";
    }

    // Activate account action (status 1)
    @RequestMapping(value = "/accounts/activate", method = RequestMethod.POST)
    // @ResponseBody
    @ResponseStatus(value = HttpStatus.OK)
    public void activateAccount(@RequestParam("id") String accid, Model model) {
        Account acc = accountDao.getAccountById(Integer.parseInt(accid));
        acc.setDatastatus(1);
        accountDao.updateAccount(acc);
        // return "Yeah";
    }

    // Show login page
    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String showLogin(Model model, @ModelAttribute("currentAccount") Account currentAccount) {
        if (null != currentAccount.getEmail()) {
            model.addAttribute("accountProfile", currentAccount);
            return "profile";
        }

        model.addAttribute("accountForm", new Account());
        return "login";
    }

    // Login action
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public String doLogin(@ModelAttribute("accountForm") Account account, Model model,
            @RequestParam(name = "rememberme", required = false) String rememberme, HttpServletResponse response) {
        Account check = accountDao.checkLogin(account.getEmail(), account.getPassword());

        if (check == null) {
            model.addAttribute("err", "Sai Email hoặc Mật khẩu");
            return "login";
        }

        if (check.getDatastatus() == 2) {
            model.addAttribute("err", "Tài khoản bị khóa");
            return "login";
        }

        if (rememberme != null && rememberme.length() > 0) {
            Cookie cookie = new Cookie("authen", check.getEmail() + "|" + check.getPassword());
            response.addCookie(cookie);
        } else {
            Cookie cookie = new Cookie("authen", null);
            cookie.setMaxAge(0);
            response.addCookie(cookie);
        }
        check.setPassword("");
        model.addAttribute("currentAccount", check);
        // model.addAttribute("accountProfile", check);

        return "redirect:/";
    }

    // Show profile page
    @RequestMapping(value = "/profile", method = RequestMethod.GET)
    public String showUpProfile(Model model, @ModelAttribute("currentAccount") Account currentAccount,
            @RequestParam(value = "k", required = false) String userid) {
        if (userid != null && userid.length() > 0) {
            Account target = accountDao.getAccountById(Integer.parseInt(userid));

            if (currentAccount.getEmail() != null && currentAccount.getId() != target.getId()) {
                model.addAttribute("fs",
                        relationshipDao.getRelationshipByAccountIds(currentAccount.getId(), target.getId()));
            }
            model.addAttribute("accountProfile", target);
            return "profile";
        }

        if (userid == null && currentAccount.getEmail() == null)
            return "redirect:/login";

        if (currentAccount.getEmail() != null && currentAccount.getEmail().length() > 0)
            model.addAttribute("accountProfile", currentAccount);
        return "profile";
    }

    // Show dashboard page
    @RequestMapping(value = "/dashboard", method = RequestMethod.GET)
    public String showDashboard(Model model, @ModelAttribute("currentAccount") Account currentAccount) {
        // List<Relationship> fsreqs =
        // relationshipDao.getNotRespondedFriendRequestsByReceiverId(currentAccount.getId());
        // model.addAttribute("fsReqs", fsreqs);
        if (null == currentAccount.getEmail())
            return "redirect:/login";
        List<Notification> notis = notificationDao.getNotificationsForAccount(currentAccount.getId());
        model.addAttribute("notis", notis);
        return "dashboard";
    }

    // Show update account form.go admin page
    @RequestMapping(value = "/adminaccounts/update", method = RequestMethod.GET)
    public String showEditAccount(Model model, @RequestParam("k") String accId) {
        Account curAcc = accountDao.getAccountById(Integer.parseInt(accId));

        model.addAttribute("curAcc", curAcc);
        return "admin-mod-account";
    }

    // Update profile action
    @RequestMapping(value = "/up-prof", method = RequestMethod.POST)
    public String upProfile(@ModelAttribute("accountProfile") Account account,
            @ModelAttribute("currentAccount") Account current, Model model) {
        // model.addAttribute("accountProfile", account);
        // System.out.println(current.getEmail());
        Account target = accountDao.getAccountByEmail(current.getEmail());

        // New password inputed
        /*
         * if (account.getPassword().length() > 0)
         * target.setPassword(account.getPassword());
         */

        target.setFirstname(account.getFirstname());
        target.setLastname(account.getLastname());
        target.setGender(account.getGender());
        target.setBirthdate(account.getBirthdate());

        accountDao.updateAccount(target);
        model.addAttribute("currentAccount", target);
        return "redirect:/profile";
    }

    @RequestMapping(value = "/changePassword", method = RequestMethod.POST)
    public String upProfile(@RequestParam("oldpassword") String oldpassword,
            @RequestParam("newpassword") String newpassword,

            @ModelAttribute("currentAccount") Account current, Model model) {
        // model.addAttribute("accountProfile", account);
        // System.out.println(current.getEmail());
        Account target = accountDao.getAccountByEmail(current.getEmail());

        // New password inputed
        /*
         * if (account.getPassword().length() > 0)
         * target.setPassword(account.getPassword());
         */
        if (oldpassword.equals(target.getPassword()))
            target.setPassword(newpassword);
        accountDao.updateAccount(target);
        model.addAttribute("currentAccount", target);
        return "redirect:/profile";
    }

    // Update account action (admin page)
    @RequestMapping(value = "/accounts/update", method = RequestMethod.POST)
    public String updateAccount(@ModelAttribute("curAcc") Account account, Model model,
            @RequestParam("cururl") String url, @RequestParam("curfunc") String func) {
        // model.addAttribute("accountProfile", account);
        // account.setDatastatus(1);
        Account target = accountDao.getAccountById(account.getId());
        target.setRole(account.getRole());
        accountDao.updateAccount(target);
        model.addAttribute("curfunc", func);
        // return "redirect:/" + url;
        return "redirect:/admin/accounts";
    }

    // Logout action
    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String doLogout(Model model, WebRequest request, SessionStatus status,
            @ModelAttribute("currentAccount") Account curAcc) {
        status.setComplete();
        // stopScheduledTask(curAcc.getId());
        request.removeAttribute("currentAccount", WebRequest.SCOPE_SESSION);
        return "redirect:/";
    }

    // Show register page
    @RequestMapping(value = "/register", method = RequestMethod.GET)
    public String showRegister(Model model) {
        model.addAttribute("accountForm", new Account());
        return "register";
    }

    // Show new account admin form page
    @RequestMapping(value = "/adminaccounts/new", method = RequestMethod.GET)
    public String createNewAccount(Model model) {
        model.addAttribute("newAcc", new Account());
        return "admin-mod-account";
    }

    // New account action
    @RequestMapping(value = "/accounts/new", method = RequestMethod.POST)
    public String createNewAccount(@ModelAttribute("newAcc") Account account, Model model,
            @RequestParam("cururl") String url, @RequestParam("curfunc") String func) {
        // account.setDatastatus(1);
        accountDao.insertAccount(account);

        // create notification objects
        List<NotificationObject> notiObjs = new ArrayList<NotificationObject>();
        for (int i = 0; i < NOTI_OBJECT_TYPE.length; i++) {
            notiObjs.add(new NotificationObject(account, NOTI_OBJECT_TYPE[i]));
        }
        notificationDao.insertNotificationObjects(notiObjs);

        // create default avatar
        URI uri;
        try {
            uri = new URI(HomeController.class.getResource("").getPath());
            String defaultDir = uri.getPath() + "../../../../../resources/images/" + "accounts/0/";
            File defaultAvatar = new File(defaultDir + "avatar.jpg");
            String newAccDir = uri.getPath() + "../../../../../resources/images/" + "accounts/" + account.getId() + "/";
            File newAccAvatar = new File(newAccDir + "avatar.jpg");
            if (!(new File(newAccDir)).exists()) {
                (new File(newAccDir)).mkdirs();
            }
            Files.copy(defaultAvatar.toPath(), newAccAvatar.toPath(), StandardCopyOption.REPLACE_EXISTING);
        } catch (URISyntaxException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        model.addAttribute("curfunc", func);
        return "redirect:/" + url;
    }

    // Register action
    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public String doRegister(@ModelAttribute("accountForm") Account account, Model model) {
        Account checkEmail = accountDao.getAccountByEmail(account.getEmail());
        if (checkEmail != null) {
            model.addAttribute("errEmail", "Email đã tồn tại!!!");
        }
        Account checkUsername = accountDao.getAccountByUsername(account.getUsername());
        if (checkUsername != null) {
            model.addAttribute("errUsername", "Tên đại diện đã tồn tại!!!");
        }
        account.setDatastatus(1);
        // if (account.getBirthdate())
        accountDao.insertAccount(account);

        // create notification objects
        List<NotificationObject> notiObjs = new ArrayList<NotificationObject>();
        for (int i = 0; i < NOTI_OBJECT_TYPE.length; i++) {
            notiObjs.add(new NotificationObject(account, NOTI_OBJECT_TYPE[i]));
        }
        notificationDao.insertNotificationObjects(notiObjs);

        // create default avatar
        URI uri;
        try {
            uri = new URI(HomeController.class.getResource("").getPath());
            String defaultDir = uri.getPath() + "../../../../../resources/images/" + "accounts/0/";
            File defaultAvatar = new File(defaultDir + "avatar.jpg");
            String newAccDir = uri.getPath() + "../../../../../resources/images/" + "accounts/" + account.getId() + "/";
            File newAccAvatar = new File(newAccDir + "avatar.jpg");
            if (!(new File(newAccDir)).exists()) {
                (new File(newAccDir)).mkdirs();
            }
            Files.copy(defaultAvatar.toPath(), newAccAvatar.toPath(), StandardCopyOption.REPLACE_EXISTING);
        } catch (URISyntaxException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "login";
    }

    // Login on page action (login and redirect to the same URL)
    @RequestMapping(value = "/login-on-page", method = RequestMethod.POST)
    public String doLoginOnPage(Model model, @RequestParam("email") String email,
            @RequestParam("password") String password, @RequestParam("cururl") String url,
            @RequestParam(name = "rememberme", required = false) String rememberme, HttpServletResponse response) {
        Account check = accountDao.checkLogin(email, password);
        if (check == null) {
            model.addAttribute("err", "Sai Email hoặc Mật khẩu");
            model.addAttribute("accountForm", new Account());
            return "login";
        }

        if (check.getDatastatus() == 2) {
            model.addAttribute("err", "Tài khoản bị khóa");
            model.addAttribute("accountForm", new Account());
            return "login";
        }

        if (rememberme != null && rememberme.length() > 0) {
            Cookie cookie = new Cookie("authen", check.getEmail() + "|" + check.getPassword());
            response.addCookie(cookie);
        } else {
            Cookie cookie = new Cookie("authen", null);
            cookie.setMaxAge(0);
            response.addCookie(cookie);
        }
        check.setPassword("");
        model.addAttribute("currentAccount", check);
        return "redirect:.." + url;
    }

    // List accounts admin page
    @RequestMapping(value = "/adminaccounts", method = RequestMethod.GET)
    public String getAdminAccounts(Model model) {
        List<Account> list = accountDao.getAllAccount();
        model.addAttribute("accounts", list);
        return "admin-accounts";
    }

    // Send make friend request action
    @RequestMapping(value = "/make-friend", method = RequestMethod.POST)
    @ResponseBody
    public String makeFriend(Model model, @ModelAttribute("currentAccount") Account currentAccount,
            @RequestParam("targetAccountId") String targetAccountId) {
        Relationship existed = relationshipDao.getRelationshipByAccountIds(currentAccount.getId(),
                Integer.parseInt(targetAccountId));
        if (existed != null) {
            return "{\"statusCode\":2}"; // already be friends
        }
        Account target = accountDao.getAccountById(Integer.parseInt(targetAccountId));
        Relationship frequest = new Relationship(currentAccount, target, 0);
        relationshipDao.createFriendRequest(frequest);
        // notify when request send
        NotificationObject notiObj = notificationDao.getNotiObjByTypeAndAccount("relationship", target.getId());
        notificationDao.insertNotification(new Notification(notiObj, "request", currentAccount, 1, frequest.getId()));

        // Notify target
        List<Notification> notis = notificationDao.getNotificationsForAccount(target.getId());
        template.convertAndSend("/topic/nt/" + target.getId(), notis);
        return "{\"statusCode\":1}"; // friend request succesful
    }

    // Response friend request action
    @RequestMapping(value = "/resp-friend", method = RequestMethod.POST)
    @ResponseBody
    public String responseFriend(Model model, @ModelAttribute("currentAccount") Account currentAccount,
            @RequestParam("freqId") String freqId, @RequestParam("responseCode") String resCode) {
        Relationship fs = relationshipDao.getRelationshipById(Integer.parseInt(freqId));
        if (fs == null) {
            return "{\"statusCode\":-1}"; // no friend request found
        }
        if (Integer.parseInt(resCode) == 1) {
            fs.setStatus(1);
            relationshipDao.updateRelationship(fs);
            return "{\"statusCode\":1}"; // aggree
        }
        if (Integer.parseInt(resCode) == 0) {
            relationshipDao.deleteRelationship(fs);
            return "{\"statusCode\":0}"; // disagree
        }
        return "{\"statusCode\":-2}"; // unidentify code
    }

    // Activate Server push notification toward each user
    @MessageMapping(value = "/go/{accountid}")
    public void startNotify(@DestinationVariable String accountid, @Payload String msg) {
        // trigger first time for sending leftover notifications
        List<Notification> notis = notificationDao.getNotificationsForAccount(Integer.parseInt(accountid));
        List converObjs = messageDao.getUnseenConversationForAccount(Integer.parseInt(accountid));
        List<Object> msgnotis = new ArrayList<Object>();
        msgnotis.add(converObjs);
        msgnotis.add(null);
        template.convertAndSend("/topic/nt/" + accountid, notis);
        template.convertAndSend("/topic/remsg/" + accountid, msgnotis);
    }

    // Pull notfication request from client
    @MessageMapping(value = "/pull/{accountid}")
    public void processPullNotification(@DestinationVariable String accountid, @Payload String msg) {

    }

    // List friend
    @RequestMapping(value = "/list-friends", method = RequestMethod.GET)
    public String getFriendList(Model model, @ModelAttribute("currentAccount") Account currentAccount) {
        List<Relationship> list1 = relationshipDao.getByFirstAccountId(currentAccount.getId());
        List<Relationship> list2 = relationshipDao.getBySecondAccountId(currentAccount.getId());
        model.addAttribute("listfriend1", list1);
        model.addAttribute("listfriend2", list2);
        return "list-friends";
    }

    // Show form to request for becoming Collaborator
    @RequestMapping(value = "/rc", method = RequestMethod.GET)
    public String showRequestCollaborator(Model model, @ModelAttribute("currentAccount") Account currentAccount) {
        return "become-collab";
    }

    // Check email exist
    @RequestMapping(value = "/checkEmailExists", method = RequestMethod.POST)
    @ResponseBody
    public String checkEmailExists(Model model, @RequestParam("email") String email) {
        String ptn = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
        if (!Pattern.matches(ptn, email))
            return "{\"status\":-1}";
        Account checkEmail = accountDao.getAccountByEmail(email);
        if (checkEmail != null) {
            return "{\"status\":2}";
        } else {
            return "{\"status\":1}";
        }
    }

    // Check user name exist
    @RequestMapping(value = "/checkUsernameExists", method = RequestMethod.POST)
    @ResponseBody
    public String checkUsernameExists(Model model, @RequestParam("username") String username) {
        Account checkUsername = accountDao.getAccountByUsername(username);
        System.out.print(checkUsername);
        if (checkUsername != null) {
            // return true;
            return "{\"status\":2}";
        } else {
            // return false;
            return "{\"status\":1}";
        }
    }

    @RequestMapping(value = "/changeavatar", method = RequestMethod.POST)
    public String changeAvatar(Model model, @RequestParam(value = "image") MultipartFile uploadImage,
            @ModelAttribute("currentAccount") Account currentAccount) {
        if (!uploadImage.isEmpty()) {
            try {
                URI uri = new URI(HomeController.class.getResource("").getPath());
                String uploadDir = uri.getPath() + "../../../../../resources/images/" + "accounts/"
                        + currentAccount.getId() + "/";
                if (!new File(uploadDir).exists()) {
                    new File(uploadDir).mkdirs();
                }
                // System.out.println(uploadDir);
                String[] filestr = uploadImage.getOriginalFilename().split("\\.");
                String filename = "avatar." + filestr[filestr.length - 1].toLowerCase();
                File uploadFile = new File(uploadDir + filename);

                uploadImage.transferTo(uploadFile);

            } catch (Exception e) {
                e.printStackTrace();
                return "redirect:/resources/pages/error.html";
            }
        }
        return "redirect:/profile";
    }
}
