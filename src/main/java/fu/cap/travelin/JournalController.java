package fu.cap.travelin;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;

import fu.cap.travelin.dao.AccountDAO;
import fu.cap.travelin.dao.AreaDAO;
import fu.cap.travelin.dao.CommentDAO;
import fu.cap.travelin.dao.FavoriteDAO;
import fu.cap.travelin.dao.JournalDAO;
import fu.cap.travelin.dao.LikingDAO;
import fu.cap.travelin.dao.NotificationDAO;
import fu.cap.travelin.dao.PlaceDAO;
import fu.cap.travelin.dao.RelationshipDAO;
import fu.cap.travelin.dao.TagDAO;
import fu.cap.travelin.model.Account;
import fu.cap.travelin.model.Comment;
import fu.cap.travelin.model.Favorite;
import fu.cap.travelin.model.Journal;
import fu.cap.travelin.model.JournalPlace;
import fu.cap.travelin.model.JournalTag;
import fu.cap.travelin.model.Liking;
import fu.cap.travelin.model.Notification;
import fu.cap.travelin.model.Place;
import fu.cap.travelin.model.Relationship;
import fu.cap.travelin.model.Tag;

@SessionAttributes({ "currentAccount", "currentPlaces" })
@Controller
public class JournalController {

    public class LikeCmt {
        int cmtId;
        Long countLike;

        public LikeCmt() {
            // TODO Auto-generated constructor stub
        }

        public LikeCmt(int cmtId, Long countLike) {

            this.cmtId = cmtId;
            this.countLike = countLike;
        }

        public int getCmtId() {
            return cmtId;
        }

        public void setCmtId(int cmtId) {
            this.cmtId = cmtId;
        }

        public Long getCountLike() {
            return countLike;
        }

        public void setCountLike(Long countLike) {
            this.countLike = countLike;
        }

    }

    public class JournalObject {
        Journal journal;
        Long countFav;

        public Journal getJournal() {
            return journal;
        }

        public void setJournal(Journal journal) {
            this.journal = journal;
        }

        public Long getCountFav() {
            return countFav;
        }

        public void setCountFav(Long countFav) {
            this.countFav = countFav;
        }

        public JournalObject(Journal journal, Long countFav) {
            this.journal = journal;
            this.countFav = countFav;
        }

        public JournalObject() {
        }

    }

    @Resource(name = "travelinProp")
    private Properties travelinProp;

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

    @Autowired
    private SimpMessagingTemplate template;

    @Autowired
    private AreaDAO areaDao;

    @Autowired
    private JournalDAO journalDao;

    @Autowired
    private AccountDAO accountDao;

    @Autowired
    private PlaceDAO placeDao;

    @Autowired
    private CommentDAO commentDao;

    @Autowired
    private FavoriteDAO favoriteDao;

    @Autowired
    private LikingDAO likingDao;

    @Autowired
    private RelationshipDAO relationshipDao;

    @Autowired
    private NotificationDAO notificationDao;

    @Autowired
    private TagDAO tagDao;

    // Show new journal page
    @RequestMapping(value = "/journals/new", method = RequestMethod.GET)
    public String showNewJour(Model model, @ModelAttribute("currentAccount") Account currentAccount) {
        if (null == currentAccount.getEmail())
            return "redirect:/login";
        model.addAttribute("newJour", new Journal());
        // model.addAttribute("tempPlace", new Place());
        model.addAttribute("newTempPlace", new Place());
        model.addAttribute("cities", areaDao.getAllAvailableCities());
        return "mod-journal";
    }

    // Show new journal admin page (will be remove soon)
    @RequestMapping(value = "/adminjournals/new", method = RequestMethod.GET)
    public String newJour(Model model) {
        model.addAttribute("newJour", new Journal());
        return "admin-mod-journal";
    }

    // New journal action
    @RequestMapping(value = "/journals/new", method = RequestMethod.POST)
    public String newJournal(Model model, @ModelAttribute("newJour") Journal newJour,
            @ModelAttribute("currentAccount") Account curAcc, @ModelAttribute("currentPlaces") List<Place> curPlaces,
            @RequestParam(value = "image") MultipartFile uploadImage, @RequestParam(value = "tags") String tags) {
        // newJour.setDatastatus(1);
        newJour.setAuthor(curAcc);

        journalDao.insertJournal(newJour);

        // insert tags
        List<JournalTag> journaltags = new ArrayList<JournalTag>();
        if (null != tags && 0 < tags.length()) {
            String[] taglist = tags.split(",");
            for (String tag : taglist) {
                Tag t = new Tag();
                t.setName(tag);
                t.setSearchcount(0);
                tagDao.findOrInsertTag(t);
                journaltags.add(new JournalTag(newJour, t));
            }
        }
        tagDao.insertJournalTags(journaltags);

        // create relation journal - places
        List<JournalPlace> jps = new ArrayList<JournalPlace>();
        for (Place place : curPlaces) {
            jps.add(new JournalPlace(newJour, place));
        }
        journalDao.insertJournalPlaces(jps);

        // Notify friends
        if (newJour.getDatastatus() == 1 || newJour.getDatastatus() == 2) {
            List<Account> friendsOfMine = relationshipDao.getFriendsOf(curAcc);
            if (friendsOfMine.size() > 0) {
                notificationDao.notifyToFriendsAboutJournal(friendsOfMine, newJour);

                // send notify to friends
                (new Thread(new Runnable() {
                    @Override
                    public void run() {
                        for (Account account : friendsOfMine) {
                            List<Notification> notis = notificationDao.getNotificationsForAccount(account.getId());
                            if (notis != null && notis.size() > 0) {
                                template.convertAndSend("/topic/nt/" + account.getId(), notis);
                            }
                        }
                    }
                })).start();
            }
        }
        if (!uploadImage.isEmpty()) {
            try {
                URI uri = new URI(HomeController.class.getResource("").getPath());
                String uploadDir = uri.getPath() + "../../../../../resources/images/" + "journals/" + newJour.getId()
                        + "/";
                if (!new File(uploadDir).exists()) {
                    new File(uploadDir).mkdirs();
                }

                String[] filestr = uploadImage.getOriginalFilename().split("\\.");
                String filename = "theme." + filestr[filestr.length - 1].toLowerCase();
                File uploadFile = new File(uploadDir + filename);
                uploadImage.transferTo(uploadFile);

            } catch (Exception e) {
                e.printStackTrace();
                return "redirect:/resources/pages/error.html";
            }
        } else {
            try {
                URI uri = new URI(HomeController.class.getResource("").getPath());
                String defaultDir = uri.getPath() + "../../../../../resources/images/" + "journals/0/";
                File defaultTheme = new File(defaultDir + "theme.jpg");
                String newJourDir = uri.getPath() + "../../../../../resources/images/" + "journals/" + newJour.getId()
                        + "/";
                File newJourTheme = new File(newJourDir + "theme.jpg");
                if (!(new File(newJourDir)).exists()) {
                    (new File(newJourDir)).mkdirs();
                }
                Files.copy(defaultTheme.toPath(), newJourTheme.toPath(), StandardCopyOption.REPLACE_EXISTING);
            } catch (URISyntaxException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // reset list place
        model.addAttribute("currentPlaces", new ArrayList<Place>());

        return "redirect:/myjournals";
    }

    @RequestMapping(value = "/journals", method = RequestMethod.GET)
    public String showPublicJournals(Model model, @RequestParam(name = "type") String type,
            @ModelAttribute("currentAccount") Account currentAccount) {
        // check if there is login user
        /*
         * if (null == currentAccount.getEmail()) return
         * "redirect:/resources/pages/unauthorized.html";
         */
        /*
         * model.addAttribute("hotarticles",articleDao.getAvailableByPage(1, 3,
         * "hot"));
         */
        double maxPage = 0;
        maxPage = (double) journalDao.countPublic() / 10;

        maxPage = Math.ceil(maxPage);
        model.addAttribute("count", maxPage);

        return "journals";
    }

    @RequestMapping(value = "/journalsbypage", method = RequestMethod.GET)
    public String getAllPlacess(Model model,
            @RequestParam(value = "page", required = false, defaultValue = "1") String page,
            @RequestParam(value = "steps", required = false, defaultValue = "10") String steps,
            @RequestParam(value = "type", required = false, defaultValue = "last") String type,
            @ModelAttribute("currentAccount") Account currentAccount) {

        List<Journal> journallist = journalDao.getPublicByPage(Integer.parseInt(page), Integer.parseInt(steps), type);
        List<JournalObject> journals = new ArrayList<JournalObject>();
        for (Journal journal : journallist) {
            JournalObject journalObj = new JournalObject(journal, favoriteDao.countFavJournal(journal.getId()));
            journals.add(journalObj);
        }

        model.addAttribute("journals", journals);
        model.addAttribute("page", page);

        return "journalspage";
    }

    @RequestMapping(value = "/journals/update", method = RequestMethod.GET)
    public String showEditJournal(Model model, @RequestParam("k") String jId,
            @ModelAttribute("currentAccount") Account currentAccount) {
        if (currentAccount.getEmail() == null) {
            return "redirect:/resources/pages/unauthorized.html";
        }

        Journal curJour = journalDao.getJournalById(Integer.parseInt(jId));
        if (curJour != null && currentAccount.getId().intValue() != curJour.getAuthor().getId().intValue()) {
            // System.out.println(currentAccount.getId().intValue() !=
            // curJour.getAuthor().getId().intValue());
            return "redirect:/resources/pages/unauthorized.html";
        }

        List<JournalPlace> jps = journalDao.getJournalPlaces(curJour.getId());
        String sPlaces = "";
        List<Place> places = new ArrayList<Place>();
        for (JournalPlace jp : jps) {
            places.add(jp.getPlace());
            sPlaces += jp.getPlace().getId() + ",";
        }
        List<JournalTag> journalTags = tagDao.getJournalTags(curJour.getId());
        String jtags = "";
        for (JournalTag jtag : journalTags) {
            jtags += jtag.getTag().getName() + ",";
        }

        // get gallery
        List<String> imgs = new ArrayList<String>();
        URI uri;
        try {
            uri = new URI(HomeController.class.getResource("").getPath());
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/resources/pages/error.html";
        }

        String imgDirStr = uri.getPath() + "../../../../../resources/images/" + "journals/" + curJour.getId() + "/";
        File imgDir = new File(imgDirStr);
        String[] listImgNames = imgDir.list(new FilenameFilter() {
            @Override
            public boolean accept(File dir, String name) {
                if ("theme.jpg".equalsIgnoreCase(name))
                    return false;
                if (name.endsWith("jpg") || name.endsWith("jpeg") || name.endsWith("png") || name.endsWith("gif"))
                    return true;
                return false;
            }
        });
        model.addAttribute("curJour", curJour);
        model.addAttribute("newTempPlace", new Place());
        model.addAttribute("curPlaces", places);
        model.addAttribute("splaces", sPlaces);
        model.addAttribute("curTags", jtags);
        model.addAttribute("jourImgs", listImgNames);
        model.addAttribute("cities", areaDao.getAllAvailableCities());
        return "mod-journal";
    }

    // Show update journal admin page
    @RequestMapping(value = "/adminjournals/update", method = RequestMethod.GET)
    public String editJournal(Model model, @RequestParam("k") String jId) {
        Journal curJour = journalDao.getJournalById(Integer.parseInt(jId));

        List<JournalPlace> jps = journalDao.getJournalPlaces(curJour.getId());
        String sPlaces = "";
        List<Place> places = new ArrayList<Place>();
        for (JournalPlace jp : jps) {
            places.add(jp.getPlace());
            sPlaces += jp.getPlace().getId() + ",";
        }
        model.addAttribute("curJour", curJour);
        model.addAttribute("curPlaces", places);
        model.addAttribute("splaces", sPlaces);
        return "admin-mod-journal";
    }

    // Update journal action
    @RequestMapping(value = "/journals/update", method = RequestMethod.POST)
    public String doEditJournal(Model model, @RequestParam("splaces") String splaces,
            @RequestParam(value = "tags") String tags, @ModelAttribute("curJour") Journal journal,
            @RequestParam(value = "image") MultipartFile uploadImage) {
        // journal.setDatastatus(1);
        int oldJourDstatus = journalDao.getJournalById(journal.getId()).getDatastatus();
        journalDao.updateJournal(journal);

        // Clean old tags and insert new s
        tagDao.cleanPlaceTags(journal.getId());
        List<JournalTag> journaltags = new ArrayList<JournalTag>();
        if (null != tags && 0 < tags.length()) {
            String[] taglist = tags.split(",");
            for (String tag : taglist) {
                Tag t = new Tag();
                t.setName(tag);
                t.setSearchcount(0);
                tagDao.findOrInsertTag(t);
                journaltags.add(new JournalTag(journal, t));
            }
        }
        tagDao.insertJournalTags(journaltags);

        // Clean old place list and insert anew
        journalDao.cleanJournalPlaces(journal.getId());
        if (!splaces.isEmpty()) {
            List<JournalPlace> jps = new ArrayList<JournalPlace>();
            String[] placeids = splaces.split(",");
            for (String pid : placeids) {
                // System.out.println(pid);
                jps.add(new JournalPlace(journal, placeDao.getPlaceById(Integer.parseInt(pid))));
            }
            journalDao.insertJournalPlaces(jps);
        }

        // Notify if switch from draft to official
        if (oldJourDstatus == 0 && (journal.getDatastatus() == 1 || journal.getDatastatus() == 2)) {
            List<Account> friendsOfMine = relationshipDao.getFriendsOf(journal.getAuthor());
            // System.out.println(friendsOfMine.size());
            if (friendsOfMine.size() > 0) {
                notificationDao.notifyToFriendsAboutJournal(friendsOfMine, journal);

                // send notify to friends
                (new Thread(new Runnable() {
                    @Override
                    public void run() {
                        for (Account account : friendsOfMine) {
                            List<Notification> notis = notificationDao.getNotificationsForAccount(account.getId());
                            if (notis != null && notis.size() > 0) {
                                template.convertAndSend("/topic/nt/" + account.getId(), notis);
                            }
                        }
                    }
                })).start();
            }
        }

        if (!uploadImage.isEmpty()) {
            try {
                URI uri = new URI(HomeController.class.getResource("").getPath());
                String uploadDir = uri.getPath() + "../../../../../resources/images/" + "journals/" + journal.getId()
                        + "/";
                if (!new File(uploadDir).exists()) {
                    new File(uploadDir).mkdirs();
                }

                String[] filestr = uploadImage.getOriginalFilename().split("\\.");
                String filename = "theme." + filestr[filestr.length - 1].toLowerCase();
                File uploadFile = new File(uploadDir + filename);
                uploadImage.transferTo(uploadFile);

            } catch (Exception e) {
                e.printStackTrace();
                return "redirect:/resources/pages/error.html";
            }
        }
        return "redirect:/journals/" + journal.getId();
    }

    // Delete a single place in a journal action
    @RequestMapping(value = "/journals/del-place-session", method = RequestMethod.POST)
    @ResponseBody
    public String removePlaceSession(Model model, @ModelAttribute("currentPlaces") List<Place> places,
            @RequestParam("pid") String pid) {
        for (int i = 0; i < places.size(); i++) {
            if (places.get(i).getId().intValue() == Integer.parseInt(pid)) {
                places.remove(i);
            }
        }

        model.addAttribute("currentPlaces", places);
        return "{\"placessize\":" + places.size() + "}";
    }

    // Show journal page
    @RequestMapping(value = "/journals/{jid}", method = RequestMethod.GET)
    public String viewJournal(Model model, @PathVariable String jid,
            @ModelAttribute("currentAccount") Account currentAccount) {
        Journal journal = journalDao.getJournalById(Integer.parseInt(jid));
        boolean accessible = false;
        Relationship rs = null;
        if (currentAccount.getEmail() != null && currentAccount.getEmail().length() > 0)
            rs = relationshipDao.getRelationshipByAccountIds(currentAccount.getId(), journal.getAuthor().getId());

        if (journal.getDatastatus() == -1) {
            return "redirect:/resources/pages/notfound.html";
        }

        if (journal.getDatastatus() == 1)
            accessible = true;
        else if (journal.getDatastatus() == 2) {
            if (currentAccount.getId().intValue() == journal.getAuthor().getId().intValue()) {
                accessible = true;
            } else {
                // List<Account> friends =
                // relationshipDao.getFriendsOf(currentAccount);
                // for (Account account : friends) {
                // if (account.getId() == journal.getAuthor().getId()) {
                // accessible = true;
                // break;
                // }
                // }
                if (rs != null)
                    accessible = true;
            }
        } else if (journal.getDatastatus() == 3
                && journal.getAuthor().getId().intValue() == currentAccount.getId().intValue()) {
            accessible = true;
        } else if (journal.getDatastatus() == 0
                && journal.getAuthor().getId().intValue() == currentAccount.getId().intValue()) {
            accessible = true;
        } else {
            // do nothing
        }

        if (!accessible) {
            return "redirect:/resources/pages/unauthorized.html";
        }

        List<JournalTag> journalTags = tagDao.getJournalTags(journal.getId());
        // get list tag
        List<String> jtags = new ArrayList<String>();
        for (JournalTag jtag : journalTags) {
            jtags.add(jtag.getTag().getName());
        }

        List<String> imgs = new ArrayList<String>();
        URI uri;
        try {
            uri = new URI(HomeController.class.getResource("").getPath());
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/resources/pages/error.html";
        }

        String imgDirStr = uri.getPath() + "../../../../../resources/images/" + "journals/" + journal.getId() + "/";
        File imgDir = new File(imgDirStr);
        String[] listImgNames = imgDir.list(new FilenameFilter() {
            @Override
            public boolean accept(File dir, String name) {
                if ("theme.jpg".equalsIgnoreCase(name))
                    return false;
                if (name.endsWith("jpg") || name.endsWith("jpeg") || name.endsWith("png") || name.endsWith("gif"))
                    return true;
                return false;
            }
        });
        List<JournalPlace> jps = journalDao.getJournalPlaces(journal.getId());
        List<Comment> comments = commentDao.getJournalCommentsByJournalId(journal.getId());
        List<Liking> likes = new ArrayList<Liking>();

        List<Place> places = new ArrayList<Place>();
        for (JournalPlace jp : jps) {
            places.add(jp.getPlace());
        }

        // get favorite and like for current logged in account
        if (null != currentAccount.getEmail()) {
            for (Comment cmt : comments) {
                likes.add(likingDao.getLikeComment(cmt.getId(), currentAccount.getId()));
            }
            Favorite favoriteJournal = favoriteDao.getFavoriteJournal(journal.getId(), currentAccount.getId());
            model.addAttribute("fav", favoriteJournal);
        }

        List<LikeCmt> countLikeComments = new ArrayList<LikeCmt>();
        for (Comment cmt : comments) {
            Long countLikeComment = likingDao.countLikeComment(cmt.getId());
            countLikeComments.add(new LikeCmt(cmt.getId(), countLikeComment));
        }

        // get journals from same author
        List<Journal> sameAuJours;
        if (rs != null)
            sameAuJours = journalDao.getLastestJournalsFromAuthorExcept(3, journal.getAuthor().getId(),
                    JournalDAO.FILTER_FRIENDS, journal.getId());
        else
            sameAuJours = journalDao.getLastestJournalsFromAuthorExcept(3, journal.getAuthor().getId(),
                    JournalDAO.FILTER_PUBLIC, journal.getId());

        // get hot journals for sevent days
        List<Map<String, Object>> joursWithFavCount;
        if (rs != null)
            joursWithFavCount = journalDao.getMostFavJournalsIn7DaysExcept(3, JournalDAO.FILTER_FRIENDS,
                    journal.getId());
        else
            joursWithFavCount = journalDao.getMostFavJournalsIn7DaysExcept(3, JournalDAO.FILTER_PUBLIC,
                    journal.getId());

        model.addAttribute("sameAuJours", sameAuJours);
        model.addAttribute("hot7DaysJours", joursWithFavCount); // DynamicObject
        model.addAttribute("countLikeComment", countLikeComments);
        model.addAttribute("curJour", journal);
        model.addAttribute("curTags", jtags);
        model.addAttribute("curPlaces", places);
        model.addAttribute("newComment", new Comment());
        model.addAttribute("comments", comments);
        model.addAttribute("likes", likes);
        model.addAttribute("journalImgs", listImgNames);
        return "journal";
    }

    @RequestMapping(value = "/adminjournals/show", method = RequestMethod.GET)
    public String viewJournalByAdmin(Model model, @RequestParam("k") String jid,
            @ModelAttribute("currentAccount") Account currentAccount) {
        Journal journal = journalDao.getJournalById(Integer.parseInt(jid));
        boolean accessible = false;
        Relationship rs = null;

        if (journal.getDatastatus() == -1) {
            return "redirect:/resources/pages/notfound.html";
        }

        if (journal.getDatastatus() == 1)
            accessible = true;
        else if (journal.getDatastatus() == 2) {
            if (currentAccount.getId().intValue() == journal.getAuthor().getId().intValue()) {
                accessible = true;
            } else {
                // List<Account> friends =
                // relationshipDao.getFriendsOf(currentAccount);
                // for (Account account : friends) {
                // if (account.getId() == journal.getAuthor().getId()) {
                // accessible = true;
                // break;
                // }
                // }
                rs = relationshipDao.getRelationshipByAccountIds(currentAccount.getId(), journal.getAuthor().getId());
                if (rs != null)
                    accessible = true;
            }
        } else if (journal.getDatastatus() == 3
                && journal.getAuthor().getId().intValue() == currentAccount.getId().intValue()) {
            accessible = true;
        } else {
            // do nothing
        }

        if (!accessible) {
            return "redirect:/resources/pages/unauthorized.html";
        }

        List<JournalTag> journalTags = tagDao.getJournalTags(journal.getId());
        // get list tag
        List<String> jtags = new ArrayList<String>();
        for (JournalTag jtag : journalTags) {
            jtags.add(jtag.getTag().getName());
        }

        List<String> imgs = new ArrayList<String>();
        URI uri;
        try {
            uri = new URI(HomeController.class.getResource("").getPath());
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/resources/pages/error.html";
        }

        String imgDirStr = uri.getPath() + "../../../../../resources/images/" + "journals/" + journal.getId() + "/";
        File imgDir = new File(imgDirStr);
        String[] listImgNames = imgDir.list(new FilenameFilter() {
            @Override
            public boolean accept(File dir, String name) {
                if ("theme.jpg".equalsIgnoreCase(name))
                    return false;
                if (name.endsWith("jpg") || name.endsWith("jpeg") || name.endsWith("png") || name.endsWith("gif"))
                    return true;
                return false;
            }
        });
        List<JournalPlace> jps = journalDao.getJournalPlaces(journal.getId());

        List<Place> places = new ArrayList<Place>();
        for (JournalPlace jp : jps) {
            places.add(jp.getPlace());
        }

        // get favorite and like for current logged in account

        // get journals from same author
        List<Journal> sameAuJours;
        if (rs != null)
            sameAuJours = journalDao.getLastestJournalsFromAuthorExcept(3, journal.getAuthor().getId(),
                    JournalDAO.FILTER_FRIENDS, journal.getId());
        else
            sameAuJours = journalDao.getLastestJournalsFromAuthorExcept(3, journal.getAuthor().getId(),
                    JournalDAO.FILTER_PUBLIC, journal.getId());

        // get hot journals for sevent days
        List<Map<String, Object>> joursWithFavCount;
        if (rs != null)
            joursWithFavCount = journalDao.getMostFavJournalsIn7DaysExcept(3, JournalDAO.FILTER_FRIENDS,
                    journal.getId());
        else
            joursWithFavCount = journalDao.getMostFavJournalsIn7DaysExcept(3, JournalDAO.FILTER_PUBLIC,
                    journal.getId());

        model.addAttribute("sameAuJours", sameAuJours);
        model.addAttribute("hot7DaysJours", joursWithFavCount); // DynamicObject

        model.addAttribute("curJour", journal);
        model.addAttribute("curTags", jtags);
        model.addAttribute("curPlaces", places);

        model.addAttribute("journalImgs", listImgNames);
        return "admin-mod-journal";
    }

    // Show list of journals of a specific account
    @RequestMapping(value = "/myjournals", method = RequestMethod.GET)
    public String listJournals(Model model, @ModelAttribute("currentAccount") Account curAcc,
            @RequestParam(value = "k", required = false) String accid) {
        List<Journal> journals;
        if (accid != null && accid.length() > 0) {
            if (curAcc.getEmail() != null && Integer.parseInt(accid) == curAcc.getId())
                return "redirect:/myjournals";
            Account targetAccount = accountDao.getAccountById(Integer.parseInt(accid));
            if (curAcc.getEmail() != null) {
                Relationship rs = relationshipDao.getRelationshipByAccountIds(curAcc.getId(), targetAccount.getId());
                if (rs != null)
                    journals = journalDao.getJournalByAccount(targetAccount, JournalDAO.FILTER_FRIENDS);
                else
                    journals = journalDao.getJournalByAccount(targetAccount, JournalDAO.FILTER_PUBLIC);
            } else {
                journals = journalDao.getJournalByAccount(targetAccount, JournalDAO.FILTER_PUBLIC);
            }
            model.addAttribute("targetAccount", targetAccount);
        } else {
            journals = journalDao.getJournalByAccount(curAcc);
            model.addAttribute("targetAccount", curAcc);
        }
        model.addAttribute("journals", journals);
        return "myjournals";
    }

    @RequestMapping(value = "/oldjournals", method = RequestMethod.GET)
    @ResponseBody
    public List<Journal> oldJournals(Model model, @ModelAttribute("currentAccount") Account curAcc) {
        List<Journal> journals = journalDao.getJournalByAccount(curAcc);

        model.addAttribute("journals", journals);
        return journals;
    }

    // Show journal list on admin page
    @RequestMapping(value = "/adminjournals", method = RequestMethod.GET)
    public String getAdminJournals(Model model) {
        List<Journal> journals = journalDao.getAll();

        model.addAttribute("journals", journals);
        return "admin-journals";
    }

    // Delete journal action
    @RequestMapping(value = "/journals/del", method = RequestMethod.POST)
    // @ResponseBody
    @ResponseStatus(value = HttpStatus.OK)
    public void deleteJournal(@RequestParam("jid") String journalid, Model model) {
        Journal journal = journalDao.getJournalById(Integer.parseInt(journalid));
        journal.setDatastatus(-1);
        journalDao.updateJournal(journal);
    }

    // Verify journal action
    @RequestMapping(value = "/journals/verify", method = RequestMethod.POST)
    // @ResponseBody
    @ResponseStatus(value = HttpStatus.OK)
    public void verifyJournal(@RequestParam("jid") String journalid, Model model) {
        Journal journal = journalDao.getJournalById(Integer.parseInt(journalid));
        journal.setDatastatus(1);
        journalDao.updateJournal(journal);

    }

    // Unverify journal action
    @RequestMapping(value = "/journals/unverify", method = RequestMethod.POST)
    // @ResponseBody
    @ResponseStatus(value = HttpStatus.OK)
    public void unverifyJournal(@RequestParam("jid") String journalid, Model model) {
        Journal journal = journalDao.getJournalById(Integer.parseInt(journalid));
        journal.setDatastatus(0);
        journalDao.updateJournal(journal);

    }

    // New journal comment action
    @RequestMapping(value = "/journals/comments/new", method = RequestMethod.POST)
    public String newComment(@ModelAttribute("newComment") Comment newComment, Model model,
            @ModelAttribute("currentAccount") Account curAcc, @RequestParam("journalid") String journalid) {
        // newComment.setDatastatus(1);
        Journal journal = journalDao.getJournalById(Integer.parseInt(journalid));
        newComment.setAccount(curAcc);
        newComment.setTargetid(journal.getId());
        commentDao.insertJournalComment(newComment);

        return "redirect:/journals/" + journal.getId();
    }

    // Delete journal comment action
    @RequestMapping(value = "/journals/comments/del", method = RequestMethod.POST)
    @ResponseStatus(value = HttpStatus.OK)
    // @ResponseBody
    public void deleteArtComment(@RequestParam("id") String commentid, Model model) {
        Comment comment = commentDao.getCommentById(Integer.parseInt(commentid));
        // comment.setDatastatus(-1);
        // commentDao.updateComment(comment);
        commentDao.deleteComment(comment);
        // return "Yeah";
    }

    // Update journal comment action
    @RequestMapping(value = "/journals/updateComment", method = RequestMethod.POST)
    @ResponseBody
    public Comment updateArtComment(@RequestBody Comment comment) {
        // comment.setDatastatus(1);
        // commentDao.updateComment(comment);
        // System.out.println(comment.getId());
        Comment curComment = commentDao.getCommentById(comment.getId());
        curComment.setContent(comment.getContent());
        commentDao.updateComment(curComment);
        return curComment;
    }

    // add place into existing journal
    @RequestMapping(value = "/journals/addPlace", method = RequestMethod.POST)
    @ResponseBody
    public String addPlaceToJournal(@RequestParam("jid") String journalId, @RequestParam("pid") String placeId) {

        List<JournalPlace> jps = journalDao.getJournalPlaces(Integer.parseInt(journalId));
        for (JournalPlace journalPlace : jps) {
            if (journalPlace.getPlace().getId() == Integer.parseInt(placeId))
                return "{\"status\":2}";
        }
        JournalPlace jp = new JournalPlace(journalDao.getJournalById(Integer.parseInt(journalId)),
                placeDao.getPlaceById(Integer.parseInt(placeId)));
        journalDao.insertJournalPlace(jp);
        return "{\"status\":1}";
    }

    @RequestMapping(value = "/journals/uploadFileImage", method = RequestMethod.POST)
    @ResponseBody
    public String upImgsJournal(Model model, @RequestParam("upfiles") List<MultipartFile> files,
            @RequestParam("jid") String jid) {
        System.out.println(files.size());
        if (!files.isEmpty()) {
            try {
                URI uri = new URI(HomeController.class.getResource("").getPath());
                String uploadDir = uri.getPath() + "../../../../../resources/images/" + "journals/" + jid + "/";
                File upDir = new File(uploadDir);
                if (!new File(uploadDir).exists()) {
                    new File(uploadDir).mkdirs();
                }
                int counter = upDir.listFiles().length;
                for (MultipartFile file : files) {
                    String[] filestr = file.getOriginalFilename().split("\\.");
                    String filename = counter + "." + filestr[filestr.length - 1].toLowerCase();
                    File uploadFile = new File(uploadDir + filename);
                    file.transferTo(uploadFile);
                    counter += 1;
                }
            } catch (Exception e) {
                e.printStackTrace();
                return "redirect:/resources/pages/error.html";
            }
        }

        // return "redirect:/places/" + pid;
        return "{\"success\":true}";
    }
}
