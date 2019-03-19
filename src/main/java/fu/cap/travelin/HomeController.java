package fu.cap.travelin;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import fu.cap.travelin.dao.AccountDAO;
import fu.cap.travelin.dao.AreaDAO;
import fu.cap.travelin.dao.ArticleDAO;
import fu.cap.travelin.dao.FeedbackDAO;
import fu.cap.travelin.dao.JournalDAO;
import fu.cap.travelin.dao.PlaceDAO;
import fu.cap.travelin.dao.TagDAO;
import fu.cap.travelin.model.Account;
import fu.cap.travelin.model.Area;
import fu.cap.travelin.model.Article;
import fu.cap.travelin.model.ArticleTag;
import fu.cap.travelin.model.Feedback;
import fu.cap.travelin.model.Journal;
import fu.cap.travelin.model.JournalTag;
import fu.cap.travelin.model.Place;
import fu.cap.travelin.model.PlaceTag;
import fu.cap.travelin.model.Subscriber;
import fu.cap.travelin.model.Tag;

/**
 * Handles requests for the application home page.
 */

@SessionAttributes({ "currentAccount" })
@Controller
public class HomeController {
    @Resource(name = "travelinProp")
    private Properties travelinProp;

    // Dummy currentAccount
    @ModelAttribute("currentAccount")
    public Account populateAccount() {
        return new Account(); // populates account for the first time if null
    }

    @Autowired
    private AccountDAO accountDao;

    @Autowired
    private ArticleDAO articleDao;

    @Autowired
    private AreaDAO areaDao;

    @Autowired
    private JournalDAO journalDao;

    @Autowired
    private PlaceDAO placeDao;

    @Autowired
    private FeedbackDAO feedbackDao;

    @Autowired
    private TagDAO tagDao;

    private List<Object> list;

    // Home page
    @RequestMapping(value = "/*", method = RequestMethod.GET)
    public String home(Model model) {
        List<Article> last5 = articleDao.getLastestArticles(5);
        List<Journal> best8 = journalDao.getBestJournals(8);
        List<Area> cities = areaDao.getAllAvailableCities();
        List<List<Place>> lastestPlaces = new ArrayList<List<Place>>(5);
        lastestPlaces.add(placeDao.getTopNewPlacesByType(6, PlaceDAO.FOOD_DRINK_TYPE));
        lastestPlaces.add(placeDao.getTopNewPlacesByType(6, PlaceDAO.TRAVEL_TYPE));
        lastestPlaces.add(placeDao.getTopNewPlacesByType(6, PlaceDAO.HEALTH_RELAX_TYPE));
        lastestPlaces.add(placeDao.getTopNewPlacesByType(6, PlaceDAO.ENTERTAINMENT_TYPE));
        lastestPlaces.add(placeDao.getTopNewPlacesByType(6, PlaceDAO.SHOPPING_TYPE));

        model.addAttribute("newPlace", new Place());
        model.addAttribute("cities", cities);
        model.addAttribute("lastarts", last5);
        model.addAttribute("bestjours", best8);
        model.addAttribute("lastestplaces", lastestPlaces);
        return "home";
    }

    // Admin main page
    @RequestMapping(value = "/admin", method = RequestMethod.GET)
    public String adminRedir() {
        return "redirect:/admin/dashboard";
    }

    // Admin routing sections
    @RequestMapping(value = "/admin/{section}", method = RequestMethod.GET)
    public String adminTest(Model model, @PathVariable String section,
            @ModelAttribute("currentAccount") Account currentAccount,
            @RequestParam(value = "a", required = false) String action,
            @RequestParam(value = "t", required = false) String targetid) {
        if (null == currentAccount.getEmail()) {
            return "redirect:/resources/pages/unauthorized.html";
        }

        // Extend action to update, new and orther things
        String extendPath = "";
        if (action != null && action.length() > 0) {
            extendPath += "/" + action;
            if (targetid != null && targetid.length() > 0)
                extendPath += "?k=" + targetid;
        }

        if ("dashboard".equalsIgnoreCase(section)) {
            model.addAttribute("path", "admindashboard" + extendPath);
        } else if ("articles".equalsIgnoreCase(section) && currentAccount.getRole() > 1) {
            model.addAttribute("path", "adminarticles" + extendPath);
        } else if ("accounts".equalsIgnoreCase(section) && currentAccount.getRole() == 3) {
            model.addAttribute("path", "adminaccounts" + extendPath);
        } else if ("areas".equalsIgnoreCase(section) && currentAccount.getRole() == 3) {
            model.addAttribute("path", "adminareas" + extendPath);
        } else if ("places".equalsIgnoreCase(section)) {
            model.addAttribute("path", "adminplaces" + extendPath);
        } else if ("feedbacks".equalsIgnoreCase(section) && currentAccount.getRole() > 1) {
            model.addAttribute("path", "adminfeedbacks" + extendPath);
        } else if ("journals".equalsIgnoreCase(section) && currentAccount.getRole() > 1) {
            model.addAttribute("path", "adminjournals" + extendPath);
        } else {
            return "redirect:/resources/pages/error.html";
        }
        return "admin";
    }

    // Load dashboard on admin site
    @RequestMapping(value = "/admindashboard", method = RequestMethod.GET)
    public String adminTestDash(Model model, @ModelAttribute("currentAccount") Account currentAccount) {
        if (null == currentAccount.getEmail())
            return "redirect:/resources/pages/unauthorized.html";
        // model.addAttribute("curfunc", func);
        Long accounts = accountDao.countAll();
        Long articles = articleDao.countAll();
        List<Feedback> feedbacks = feedbackDao.getAllUnsolved();
        Long journals = journalDao.countAll();
        Long places = placeDao.countAll();
        Long areas = areaDao.countAll();
        List<Place> tempPlaces = placeDao.getAllUsingTemp();
        model.addAttribute("areas", areas);
        model.addAttribute("places", places);
        model.addAttribute("tempplaces", tempPlaces);
        model.addAttribute("journals", journals);
        model.addAttribute("feedbacks", feedbacks);
        model.addAttribute("articles", articles);
        model.addAttribute("accounts", accounts);
        return "admin-dashboard";
    }

    // Search action
    @RequestMapping(value = "/search", method = RequestMethod.GET)
    public String search(@RequestParam(value = "k", required = false) String searchText,
            @RequestParam(value = "t", required = false) String searchTag,
            @RequestParam(value = "aid", required = false) String areaId, Model model) {
        if (searchText != null && searchText.length() != 0) {
            if (areaId == null || areaId.length() == 0)
                areaId = "-1";
            List<Article> artList = articleDao.getSearchArticleResult(searchText);
            List<Place> plaList = placeDao.getSearchPlaceResult(searchText, Integer.parseInt(areaId));
            List<Journal> jourList = journalDao.getSearchJournalResult(searchText);

            model.addAttribute("articles", artList);
            model.addAttribute("places", plaList);
            model.addAttribute("journals", jourList);
        }
        if (searchTag != null && searchTag.length() != 0) {

            Tag tag = tagDao.getTagByName(searchTag);
            if (tag != null) {
                tag.setSearchcount(tag.getSearchcount() + 1);
                tagDao.updateTag(tag);

                List<PlaceTag> listPtag = tagDao.getPlaceByTag(tag.getId());
                List<ArticleTag> listAtag = tagDao.getArticleByTag(tag.getId());
                List<JournalTag> listJtag = tagDao.getJournalByTag(tag.getId());

                List<Article> artList = new ArrayList<Article>();
                List<Place> plaList = new ArrayList<Place>();
                List<Journal> jourList = new ArrayList<Journal>();

                for (PlaceTag pt : listPtag) {
                    plaList.add(pt.getPlace());

                }

                for (ArticleTag at : listAtag) {
                    artList.add(at.getArticle());

                }

                for (JournalTag jt : listJtag) {
                    jourList.add(jt.getJournal());

                }

                model.addAttribute("articles", artList);
                model.addAttribute("places", plaList);
                model.addAttribute("journals", jourList);
            } else {
                Tag t = new Tag();
                t.setName(searchTag);
                t.setSearchcount(1);
                tagDao.insertTag(t);
            }
        }
        return "search-result";

    }

    // Autocomplete ajax action

    @RequestMapping(value = "/autocomplete", method = RequestMethod.POST)
    @ResponseBody
    public List<Object> searchAjax(@RequestParam("k") String searchText, @RequestParam(value = "aid") String areaId,
            Model model) {
        // System.out.println(searchText);
        List<Object> list = new ArrayList<Object>();
        if (searchText.length() != 0) {

            list.add(placeDao.getTopSearchPlaceResult(searchText, 5, Integer.parseInt(areaId)));
            list.add(articleDao.getTopSearchArticleResult(searchText, 5));
            list.add(journalDao.getTopSearchJournalResult(searchText, 5));
            list.add(accountDao.getTopSearchAccountResult(searchText, 5));
        }

        return list;
    }

    // @RequestMapping(value = "/test", method = RequestMethod.GET)
    // public String goTest() {
    //
    // return "test";
    // }
    //
    // @RequestMapping(value = "/test", method = RequestMethod.POST)
    // @ResponseBody
    // public List<Map<String, Object>> goTestPost(@RequestParam("k") String k)
    // {
    // List<Map<String, Object>> list = journalDao.getMostFavJournalsIn7Days(3,
    // JournalDAO.FILTER_PUBLIC);
    // return list;
    // }

    @RequestMapping(value = "/subscribe", method = RequestMethod.POST)
    @ResponseBody
    public String regSubscriber(@RequestParam("em") String email) {
        Subscriber sub = new Subscriber();
        String ptn = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
        if (!Pattern.matches(ptn, email))
            return "{\"status\":-1}";
        sub.setEmail(email);
        int status = accountDao.insertSubscriber(sub);
        return "{\"status\":" + status + "}";
    }
}
