package fu.cap.travelin;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
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

import fu.cap.travelin.dao.AreaDAO;
import fu.cap.travelin.model.Account;
import fu.cap.travelin.model.Area;

@SessionAttributes({ "currentAccount" })
@Controller
public class AreaController {
    @Resource(name = "travelinProp")
    private Properties travelinProp;

    @Autowired
    private AreaDAO areaDao;

    // Dummy currentAccount
    @ModelAttribute("currentAccount")
    public Account populateAccount() {
        return new Account(); // populates account for the first time if null
    }

    // Show area list admin page
    @RequestMapping(value = "/adminareas", method = RequestMethod.GET)
    public String getAdminAreas(Model model) {
        List<Area> list = areaDao.getAll();

        model.addAttribute("areas", list);
        return "admin-areas";
    }

    // Show area page
    @RequestMapping(value = "/areas", method = RequestMethod.GET)
    public String getAllArea(Model model, @ModelAttribute("currentAccount") Account currentAccount) {
        // check if there is login user
        if (null == currentAccount.getEmail())
            return "redirect:/resources/pages/unauthorized.html";

        List<Area> list = areaDao.getAllAvailable();
        model.addAttribute("areas", list);
        return "areas";
    }

    // Show specific area page
    @RequestMapping(value = "/areas/{areaid}", method = RequestMethod.GET)
    public String showEditArea(@PathVariable String areaid, Model model) {
        Area area = areaDao.getAreaById(Integer.parseInt(areaid));
        model.addAttribute("curArea", area);
        return "area";
    }

    // Show new area form page
    @RequestMapping(value = "/areas/new", method = RequestMethod.GET)
    public String showNewArea(Model model) {
        // Article art = articleDao.getArticleById(Integer.parseInt(artid));
        model.addAttribute("newArea", new Area());
        return "mod-area";
    }

    // Show new area form admin page
    @RequestMapping(value = "/adminareas/new", method = RequestMethod.GET)
    public String createNewArea(Model model) {
        // Article art = articleDao.getArticleById(Integer.parseInt(artid));
        model.addAttribute("cities", areaDao.getAllAvailableCities());
        model.addAttribute("newArea", new Area());
        return "admin-mod-area";
    }

    // New area action
    @RequestMapping(value = "/areas/new", method = RequestMethod.POST)
    public String newArea(@ModelAttribute("newArea") Area newArea, Model model,
            @RequestParam(value = "image") MultipartFile uploadImage, @RequestParam("cururl") String url,
            @RequestParam("curfunc") String func, @ModelAttribute("currentAccount") Account currentAccount) {
        // Article art = articleDao.getArticleById(Integer.parseInt(artid));
        // model.addAttribute("newArt", new Article());
        newArea.setCreatedaccount(currentAccount);
        newArea.setDatastatus(1);

        // if (newArea.getParentarea().getId() == -1)
        // newArea.setParentarea(null);

        areaDao.insertArea(newArea);
        if (!uploadImage.isEmpty()) {
            try {
                URI uri = new URI(HomeController.class.getResource("").getPath());
                String uploadDir = uri.getPath() + "../../../../../resources/images/" + "areas/";
                if (!new File(uploadDir).exists()) {
                    new File(uploadDir).mkdirs();
                }

                String[] filestr = uploadImage.getOriginalFilename().split("\\.");
                String filename = newArea.getId() + "." + filestr[filestr.length - 1].toLowerCase();
                File uploadFile = new File(uploadDir + filename);

                uploadImage.transferTo(uploadFile);

            } catch (Exception e) {
                e.printStackTrace();
                return "redirect:/resources/pages/error.html";
            }
        } else {
            try {
                URI uri = new URI(HomeController.class.getResource("").getPath());
                String areaDir = uri.getPath() + "../../../../../resources/images/" + "areas/";
                // if (!(new File(newJourDir)).exists()) {
                // (new File(newJourDir)).mkdirs();
                // }
                File defaultTheme = new File(areaDir + "0.jpg");
                File newAreaTheme = new File(areaDir + newArea.getId() + ".jpg");
                Files.copy(defaultTheme.toPath(), newAreaTheme.toPath(), StandardCopyOption.REPLACE_EXISTING);
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

    // Verify area action
    @RequestMapping(value = "/areas/verify", method = RequestMethod.POST)
    // @ResponseBody
    @ResponseStatus(value = HttpStatus.OK)
    public void verifyArea(@RequestParam("id") String areaid, Model model) {
        Area area = areaDao.getAreaById(Integer.parseInt(areaid));
        area.setDatastatus(1);
        areaDao.updateArea(area);
        // return "Yeah";
    }

    // Delete area action (status -1)
    @RequestMapping(value = "/areas/del", method = RequestMethod.POST)
    // @ResponseBody
    @ResponseStatus(value = HttpStatus.OK)
    public void deleteArea(@RequestParam("id") String areaid, Model model) {
        Area area = areaDao.getAreaById(Integer.parseInt(areaid));
        area.setDatastatus(-1);
        areaDao.updateArea(area);
        // return "Yeah";
    }

    @RequestMapping(value = "/areas/unverify", method = RequestMethod.POST)
    // @ResponseBody
    @ResponseStatus(value = HttpStatus.OK)
    public void unverifyArea(@RequestParam("id") String areaid, Model model) {
        Area area = areaDao.getAreaById(Integer.parseInt(areaid));
        area.setDatastatus(0);
        areaDao.updateArea(area);
        // return "Yeah";
    }

    // Show update area page
    @RequestMapping(value = "/areas/update", method = RequestMethod.GET)
    public String showUpdateArea(Model model, @RequestParam("k") String areaId) {
        Area curArea = areaDao.getAreaById(Integer.parseInt(areaId));
        model.addAttribute("curArea", curArea);
        return "mod-area";
    }

    // Show update area admin page
    @RequestMapping(value = "/adminareas/update", method = RequestMethod.GET)
    public String editArea(Model model, @RequestParam("k") String areaId) {
        Area curArea = areaDao.getAreaById(Integer.parseInt(areaId));
        model.addAttribute("cities", areaDao.getAllAvailableCities());
        model.addAttribute("curArea", curArea);
        return "admin-mod-area";
    }

    // Update area action
    @RequestMapping(value = "/areas/update", method = RequestMethod.POST)
    public String updateArea(Model model, @ModelAttribute("curLoca") Area area,
            @RequestParam(value = "image") MultipartFile uploadImage, @RequestParam("cururl") String url,
            @RequestParam("curfunc") String func) {
        area.setDatastatus(1);

        // area.setCreatedaccount(currentAccount);
        // if (area.getParentarea().getId() == -1)
        // area.setParentarea(null);
        areaDao.updateArea(area);

        if (!uploadImage.isEmpty()) {
            try {
                URI uri = new URI(HomeController.class.getResource("").getPath());
                String uploadDir = uri.getPath() + "../../../../../resources/images/" + "areas/";
                if (!new File(uploadDir).exists()) {
                    new File(uploadDir).mkdirs();
                }

                String[] filestr = uploadImage.getOriginalFilename().split("\\.");
                String filename = area.getId() + "." + filestr[filestr.length - 1].toLowerCase();
                File uploadFile = new File(uploadDir + filename);

                uploadImage.transferTo(uploadFile);

            } catch (Exception e) {
                e.printStackTrace();
                return "redirect:/resources/pages/error.html";
            }
        }
        model.addAttribute("curfunc", func);
        return "redirect:/" + url;
    }

    // Get list all cities action
    @RequestMapping(value = "/getAllCities", method = RequestMethod.POST)
    @ResponseBody
    public List<Area> getAllCities() {
        List<Area> list = areaDao.getAllAvailableCities();
        return list;
    }

    // Get detail of area action
    @RequestMapping(value = "/getAreaDescription")
    @ResponseBody
    public Area getAreaDescription(@RequestBody Area area) {
        Area result = areaDao.getAreaById(area.getId());
        return result;
    }
}
