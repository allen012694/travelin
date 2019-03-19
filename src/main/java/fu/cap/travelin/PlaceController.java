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
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;

import fu.cap.travelin.dao.AccountDAO;
import fu.cap.travelin.dao.AreaDAO;
import fu.cap.travelin.dao.FavoriteDAO;
import fu.cap.travelin.dao.JournalDAO;
import fu.cap.travelin.dao.PlaceDAO;
import fu.cap.travelin.dao.SuggestionDAO;
import fu.cap.travelin.dao.TagDAO;
import fu.cap.travelin.model.Account;
import fu.cap.travelin.model.Area;
import fu.cap.travelin.model.Favorite;
import fu.cap.travelin.model.JournalPlace;
import fu.cap.travelin.model.Place;
import fu.cap.travelin.model.PlaceTag;
import fu.cap.travelin.model.Suggestion;
import fu.cap.travelin.model.Tag;

@SessionAttributes({ "currentAccount", "currentPlaces" })
@Controller
public class PlaceController {
    public class PlaceObject {
        Place place;
        Long favCount;
        Long recommendCount;
        Long notRecommendCount;

        public Place getPlace() {
            return place;
        }

        public void setPlace(Place place) {
            this.place = place;
        }

        public Long getFavCount() {
            return favCount;
        }

        public void setFavCount(Long favCount) {
            this.favCount = favCount;
        }

        public Long getRecommendCount() {
            return recommendCount;
        }

        public void setRecommendCount(Long recommendCount) {
            this.recommendCount = recommendCount;
        }

        public Long getNotRecommendCount() {
            return notRecommendCount;
        }

        public void setNotRecommendCount(Long notRecommendCount) {
            this.notRecommendCount = notRecommendCount;
        }

        public PlaceObject(Place place, Long favCount, Long recommendCount, Long notRecommendCount) {
            this.place = place;
            this.favCount = favCount;
            this.recommendCount = recommendCount;
            this.notRecommendCount = notRecommendCount;
        }

        public PlaceObject() {
            // TODO Auto-generated constructor stub
        }
    }

    @Resource(name = "travelinProp")
    private Properties travelinProp;

    @Autowired
    private PlaceDAO placeDao;

    @Autowired
    private AreaDAO areaDao;

    @Autowired
    private TagDAO tagDao;

    @Autowired
    private SuggestionDAO suggestionDao;

    @Autowired
    private FavoriteDAO favoriteDao;

    @Autowired
    private AccountDAO accountDao;

    @Autowired
    private JournalDAO journalDao;

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

    // Show list places admin page
    @RequestMapping(value = "/adminplaces", method = RequestMethod.GET)
    public String getAdminPlaces(Model model) {
        List<Place> list = placeDao.getAll();
        /*
         * model.addAttribute("count", placeDao.countAll());
         * model.addAttribute("page", page);
         */
        model.addAttribute("places", list);
        return "admin-places";
    }

    // Show list places page
    @RequestMapping(value = "/places", method = RequestMethod.GET)
    public String getAllPlaces(Model model, @RequestParam(value = "group", required = false) String[] groupStr,
            @RequestParam(value = "aid", required = false) String areaId,
            @ModelAttribute("currentAccount") Account currentAccount) {
        // check if there is login user
        double maxPage = 0;
        if (areaId == null || areaId.length() == 0)
            areaId = "-1";
        if (groupStr == null) {

            maxPage = (double) placeDao.countAvailable(Integer.parseInt(areaId)) / 10;

            maxPage = Math.ceil(maxPage);

            model.addAttribute("count", maxPage);
        } else {
            List<Integer> group = new ArrayList<Integer>();
            for (String str : groupStr) {
                group.add(Integer.parseInt(str));
            }
            maxPage = (double) placeDao.countAvailableByGroup(group, Integer.parseInt(areaId)) / 10;
            maxPage = Math.ceil(maxPage);
            model.addAttribute("count", maxPage);
            model.addAttribute("group", group);
        }
        List<Area> cities = areaDao.getAllAvailableCities();
        model.addAttribute("curArea", Integer.parseInt(areaId));
        model.addAttribute("cities", cities);
        return "places";
    }

    @RequestMapping(value = "/placesbypage", method = RequestMethod.GET)
    public String getAllPlacess(Model model, @RequestParam(value = "group", required = false) String[] groupStr,
            @RequestParam(value = "aid", required = false) String areaId,
            @RequestParam(value = "page", required = false, defaultValue = "1") String page,
            @RequestParam(value = "steps", required = false, defaultValue = "10") String steps,
            @RequestParam(value = "type", required = false, defaultValue = "last") String type,
            @ModelAttribute("currentAccount") Account currentAccount) {
        List<Integer> group = new ArrayList<Integer>();
        if (areaId == null || areaId.length() == 0)
            areaId = "-1";
        if (groupStr != null) {

            for (String str : groupStr) {
                group.add(Integer.parseInt(str));
            }
        }
        List<Place> placelist = placeDao.getAvailableByPage(Integer.parseInt(page), Integer.parseInt(steps), type,
                group, Integer.parseInt(areaId));

        List<PlaceObject> places = new ArrayList<PlaceObject>();
        for (Place place : placelist) {
            PlaceObject placeObj = new PlaceObject(place, favoriteDao.countFavPlace(place.getId()),
                    suggestionDao.countRecommendPlace(place), suggestionDao.countNotRecommendPlace(place));
            places.add(placeObj);
        }
        model.addAttribute("places", places);

        model.addAttribute("page", page);

        return "placespage";
    }

    // Delete place action
    @RequestMapping(value = "/places/del", method = RequestMethod.POST)
    // @ResponseBody
    @ResponseStatus(value = HttpStatus.OK)
    public void deleteArticle(@RequestParam("pid") String placeid, Model model) {
        Place place = placeDao.getPlaceById(Integer.parseInt(placeid));
        place.setDatastatus(-1);
        placeDao.updatePlace(place);
        // return "Yeah";
    }

    // Verify place action
    @RequestMapping(value = "/places/verify", method = RequestMethod.POST)
    // @ResponseBody
    @ResponseStatus(value = HttpStatus.OK)
    public void verifyArticle(@RequestParam("pid") String placeid, @RequestParam("kid") String accid, Model model) {
        Place place = placeDao.getPlaceById(Integer.parseInt(placeid));
        Account acc = new Account();
        acc.setId(Integer.parseInt(accid));
        place.setCreatedaccount(acc);
        place.setDatastatus(1);
        placeDao.updatePlace(place);
        // return "Yeah";
    }

    // Unverify place action
    @RequestMapping(value = "/places/unverify", method = RequestMethod.POST)
    // @ResponseBody
    @ResponseStatus(value = HttpStatus.OK)
    public void unverifyArticle(@RequestParam("pid") String placeid, Model model) {
        Place place = placeDao.getPlaceById(Integer.parseInt(placeid));
        place.setDatastatus(0);
        place.setCreatedaccount(null);
        placeDao.updatePlace(place);
        // return "Yeah";
    }

    // Show a place page
    @RequestMapping(value = "/places/{placeid}", method = RequestMethod.GET)
    public String showEditArticle(@PathVariable String placeid, Model model,
            @ModelAttribute("currentAccount") Account account) {
        Place place = placeDao.getPlaceById(Integer.parseInt(placeid));
        List<Suggestion> suggestions = suggestionDao.getSuggestionByPlaceId(place.getId());
        List<PlaceTag> placeTags = tagDao.getPlaceTags(place.getId());

        // get list tag
        List<String> ptags = new ArrayList<String>();
        for (PlaceTag ptag : placeTags) {
            ptags.add(ptag.getTag().getName());
        }
        if (account.getEmail() != null) {
            Favorite favoriteplace = favoriteDao.getFavoritePlace(place.getId(), account.getId());
            model.addAttribute("fav", favoriteplace);
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

        String imgDirStr = uri.getPath() + "../../../../../resources/images/" + "places/" + place.getId() + "/";
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

        // get top recommended places by area and type
        List<Map<String, Object>> topRecPlaces = placeDao.getTopRecommendedPlaces(3, place.getType(),
                place.getArea().getId(), place.getId());
        for (Map<String, Object> placeWRec : topRecPlaces) {
            Area a = areaDao.getAreaById((Integer) placeWRec.get("AreaId"));
            placeWRec.put("Area", a);
        }

        // get lastest places by area and type
        List<Place> topLastPlaces = placeDao.getTopNewPlacesByTypeAndArea(3, place.getType(), place.getArea().getId(),
                place.getId());

        model.addAttribute("topLastPlaces", topLastPlaces);
        model.addAttribute("topRecPlaces", topRecPlaces);
        model.addAttribute("placeImgs", listImgNames);
        model.addAttribute("curTags", ptags);
        model.addAttribute("newSuggestion", new Suggestion());
        model.addAttribute("suggestions", suggestions);
        model.addAttribute("curPlace", place);
        return "place";
    }

    // Update place action
    @RequestMapping(value = "/places/update", method = RequestMethod.POST)
    public String updatePlace(Model model, @ModelAttribute("curPlace") Place place, @RequestParam("cururl") String url,
            @RequestParam(value = "image") MultipartFile uploadImage, @RequestParam(value = "tags") String tags,
            @RequestParam("curfunc") String func) {
        place.setDatastatus(1);
        place.setPriority(0);
        placeDao.updatePlace(place);
        model.addAttribute("curfunc", func);
        tagDao.cleanPlaceTags(place.getId());
        List<PlaceTag> placetags = new ArrayList<PlaceTag>();
        if (null != tags && 0 < tags.length()) {
            String[] taglist = tags.split(",");
            for (String tag : taglist) {
                Tag t = new Tag();
                t.setName(tag);
                t.setSearchcount(0);
                tagDao.findOrInsertTag(t);
                placetags.add(new PlaceTag(place, t));
            }
        }
        tagDao.insertPlaceTags(placetags);

        if (!uploadImage.isEmpty()) {
            try {
                URI uri = new URI(HomeController.class.getResource("").getPath());
                String uploadDir = uri.getPath() + "../../../../../resources/images/" + "places/" + place.getId() + "/";
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
        // return "redirect:/places";
        return "redirect:/" + url;
    }

    // Show update place page
    @RequestMapping(value = "/places/update", method = RequestMethod.GET)
    public String showUpdatePlace(Model model, @RequestParam("k") String plaId) {
        // Article art = articleDao.getArticleById(Integer.parseInt(artid));
        // model.addAttribute("newPlace", new Place());
        Place curPlace = placeDao.getPlaceById(Integer.parseInt(plaId));
        List<PlaceTag> placeTags = tagDao.getPlaceTags(curPlace.getId());
        String ptags = "";
        for (PlaceTag ptag : placeTags) {
            ptags += ptag.getTag().getName() + ",";
        }
        model.addAttribute("curPlace", curPlace);
        model.addAttribute("curTags", ptags);
        return "mod-place";
    }

    // Show update place admin page
    @RequestMapping(value = "/adminplaces/update", method = RequestMethod.GET)
    public String editPlace(Model model, @RequestParam("k") String plaId) {
        // Article art = articleDao.getArticleById(Integer.parseInt(artid));
        // model.addAttribute("newPlace", new Place());
        Place curPlace = placeDao.getPlaceById(Integer.parseInt(plaId));
        List<Area> cities = areaDao.getAllAvailableCities();
        List<PlaceTag> placeTags = tagDao.getPlaceTags(curPlace.getId());

        // get list tag
        String ptags = "";
        for (PlaceTag ptag : placeTags) {
            // ptags.add(ptag.getTag().getName());
            ptags += ptag.getTag().getName() + ",";
        }
        model.addAttribute("cities", cities);
        model.addAttribute("curPlace", curPlace);
        model.addAttribute("curTags", ptags);
        return "admin-mod-place";
    }

    // Show new place page
    @RequestMapping(value = "/places/new", method = RequestMethod.GET)
    public String showNewPlace(Model model) {
        // Article art = articleDao.getArticleById(Integer.parseInt(artid));
        model.addAttribute("newPlace", new Place());
        return "mod-place";
    }

    // Show new place admin page
    @RequestMapping(value = "/adminplaces/new", method = RequestMethod.GET)
    public String createPlace(Model model) {
        // Article art = articleDao.getArticleById(Integer.parseInt(artid));
        List<Area> cities = areaDao.getAllAvailableCities();
        model.addAttribute("newPlace", new Place());
        model.addAttribute("cities", cities);
        return "admin-mod-place";
    }

    // New place action
    @RequestMapping(value = "/places/new", method = RequestMethod.POST)
    public String newArticle(@ModelAttribute("newPlace") Place newPlace, Model model,
            @RequestParam(value = "image") MultipartFile uploadImage, @RequestParam(value = "tags") String tags,
            @RequestParam("cururl") String url, @RequestParam("curfunc") String func,
            @ModelAttribute("currentAccount") Account currentAccount) {

        newPlace.setDatastatus(1);
        newPlace.setPriority(0);
        newPlace.setCreatedaccount(currentAccount);
        placeDao.insertPlace(newPlace);

        List<PlaceTag> placetags = new ArrayList<PlaceTag>();
        if (null != tags && 0 < tags.length()) {
            String[] taglist = tags.split(",");
            for (String tag : taglist) {
                Tag t = new Tag();
                t.setName(tag);
                t.setSearchcount(0);
                tagDao.findOrInsertTag(t);
                placetags.add(new PlaceTag(newPlace, t));
            }
        }
        tagDao.insertPlaceTags(placetags);

        if (!uploadImage.isEmpty()) {
            try {
                URI uri = new URI(HomeController.class.getResource("").getPath());
                String uploadDir = uri.getPath() + "../../../../../resources/images/" + "places/" + newPlace.getId()
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
                String defaultDir = uri.getPath() + "../../../../../resources/images/" + "places/0/";
                File defaultTheme = new File(defaultDir + "theme.jpg");
                String newPlaceDir = uri.getPath() + "../../../../../resources/images/" + "places/" + newPlace.getId()
                        + "/";
                File newPlaceTheme = new File(newPlaceDir + "theme.jpg");
                if (!(new File(newPlaceDir)).exists()) {
                    (new File(newPlaceDir)).mkdirs();
                }
                Files.copy(defaultTheme.toPath(), newPlaceTheme.toPath(), StandardCopyOption.REPLACE_EXISTING);
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
        model.addAttribute("curfunc", func);
        return "redirect:/" + url;
    }

    // Add a place to a specific journal action
    @RequestMapping(value = "/places/add-to-jour", method = RequestMethod.GET)
    // @ResponseStatus(value = HttpStatus.OK)
    @ResponseBody
    public String addToJour(Model model, @RequestParam("jid") String jid,
            @ModelAttribute("currentPlaces") List<Place> currentPlaces) {
        // System.out.println(jid);
        for (Place place : currentPlaces) {
            if (place.getId() == Integer.parseInt(jid))
                return "{\"placessize\":" + currentPlaces.size() + "}";
        }
        Place newEle = placeDao.getPlaceById(Integer.parseInt(jid));
        currentPlaces.add(newEle);
        model.addAttribute("currentPlaces", currentPlaces);
        return "{\"placessize\":" + currentPlaces.size() + "}";
    }

    // Upload place image action
    @RequestMapping(value = "/places/uploadFileImage", method = RequestMethod.POST)
    @ResponseBody
    public String upImgsPlace(Model model, @RequestParam("upfiles") List<MultipartFile> files,
            @RequestParam("pid") String pid) {
        if (!files.isEmpty()) {
            try {
                URI uri = new URI(HomeController.class.getResource("").getPath());
                String uploadDir = uri.getPath() + "../../../../../resources/images/" + "places/" + pid + "/";
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

    @RequestMapping(value = "/places/addtemp", method = RequestMethod.POST)
    // @ResponseBody
    public String addTempPlace(@ModelAttribute("newTempPlace") Place tempPlace,
            @ModelAttribute("currentPlaces") List<Place> currentPlaces,
            @RequestParam(name = "joid", required = false) String jid, Model model) {
        // System.out.println(tempPlace.getName());
        if (tempPlace.getArea().getId() < 1)
            return "redirect:/journals/new";
        tempPlace.setDatastatus(0);
        tempPlace.setPriority(0);
        placeDao.insertPlace(tempPlace);

        // create default theme picture
        URI uri;
        try {
            uri = new URI(HomeController.class.getResource("").getPath());
            String defaultDir = uri.getPath() + "../../../../../resources/images/" + "places/0/";
            File defaultTheme = new File(defaultDir + "theme.jpg");
            String newPlaceDir = uri.getPath() + "../../../../../resources/images/" + "places/" + tempPlace.getId()
                    + "/";
            File newPlaceTheme = new File(newPlaceDir + "theme.jpg");
            if (!(new File(newPlaceDir)).exists()) {
                (new File(newPlaceDir)).mkdirs();
            }
            Files.copy(defaultTheme.toPath(), newPlaceTheme.toPath(), StandardCopyOption.REPLACE_EXISTING);
        } catch (URISyntaxException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (jid != null && jid.length() > 0) {
            JournalPlace jp = new JournalPlace(journalDao.getJournalById(Integer.parseInt(jid)), tempPlace);
            journalDao.insertJournalPlace(jp);
            return "redirect:/journals/update?k=" + jid;
        } else {
            tempPlace.setArea(areaDao.getAreaById(tempPlace.getArea().getId()));
            currentPlaces.add(tempPlace);
            model.addAttribute("currentPlaces", currentPlaces);
            return "redirect:/journals/new";
        }

    }

    @RequestMapping(value = "/lasthomeplaces", method = RequestMethod.POST)
    @ResponseBody
    public List<List<Place>> getLastestPlacesAjax(@RequestParam("aid") String areaid) {
        int aid = Integer.parseInt(areaid);
        List<List<Place>> lastestPlaces = new ArrayList<List<Place>>(5);
        if (aid == -1) {
            lastestPlaces.add(placeDao.getTopNewPlacesByType(6, PlaceDAO.FOOD_DRINK_TYPE));
            lastestPlaces.add(placeDao.getTopNewPlacesByType(6, PlaceDAO.TRAVEL_TYPE));
            lastestPlaces.add(placeDao.getTopNewPlacesByType(6, PlaceDAO.HEALTH_RELAX_TYPE));
            lastestPlaces.add(placeDao.getTopNewPlacesByType(6, PlaceDAO.ENTERTAINMENT_TYPE));
            lastestPlaces.add(placeDao.getTopNewPlacesByType(6, PlaceDAO.SHOPPING_TYPE));
        } else {
            lastestPlaces.add(placeDao.getTopNewPlacesByTypeAndArea(6, PlaceDAO.FOOD_DRINK_TYPE, aid));
            lastestPlaces.add(placeDao.getTopNewPlacesByTypeAndArea(6, PlaceDAO.TRAVEL_TYPE, aid));
            lastestPlaces.add(placeDao.getTopNewPlacesByTypeAndArea(6, PlaceDAO.HEALTH_RELAX_TYPE, aid));
            lastestPlaces.add(placeDao.getTopNewPlacesByTypeAndArea(6, PlaceDAO.ENTERTAINMENT_TYPE, aid));
            lastestPlaces.add(placeDao.getTopNewPlacesByTypeAndArea(6, PlaceDAO.SHOPPING_TYPE, aid));
        }
        return lastestPlaces;
    }
}
