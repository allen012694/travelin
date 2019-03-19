package fu.cap.travelin;

import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.SessionAttributes;

import fu.cap.travelin.dao.AccountDAO;
import fu.cap.travelin.dao.ArticleDAO;
import fu.cap.travelin.dao.PlaceDAO;
import fu.cap.travelin.dao.SuggestionDAO;
import fu.cap.travelin.model.Account;
import fu.cap.travelin.model.Place;
import fu.cap.travelin.model.Suggestion;

@SessionAttributes({ "currentAccount" })
@Controller
public class SuggestionController {
    @Resource(name = "travelinProp")
    private Properties travelinProp;

    // Dummy currentAccount
    @ModelAttribute("currentAccount")
    public Account populateAccount() {
        return new Account(); // populates account for the first time if null
    }

    @Autowired
    private SuggestionDAO suggestionDao;

    @Autowired
    private AccountDAO accountDao;

    @Autowired
    private ArticleDAO articleDao;

    @Autowired
    private PlaceDAO placeDao;

    // New suggestion action
    @RequestMapping(value = "/suggestions/new", method = RequestMethod.POST)
    public String newSuggestion(@ModelAttribute("newSuggestion") Suggestion newSuggestion, Model model,
            @ModelAttribute("currentAccount") Account curAcc, @RequestParam("placeid") String placeid) {
        newSuggestion.setDatastatus(1);
        Place place = placeDao.getPlaceById(Integer.parseInt(placeid));
        newSuggestion.setAuthor(curAcc);
        newSuggestion.setPlace(place);
        suggestionDao.insertSuggestion(newSuggestion);

        return "redirect:/places/" + place.getId();
    }

    // Delete suggestion action
    @RequestMapping(value = "/suggestions/del", method = RequestMethod.POST)
    @ResponseStatus(value = HttpStatus.OK)
    // @ResponseBody
    public void deleteArticle(@RequestParam("id") String suggestionid, Model model) {
        Suggestion Suggestion = suggestionDao.getSuggestionById(Integer.parseInt(suggestionid));
        Suggestion.setDatastatus(-1);
        suggestionDao.updateSuggestion(Suggestion);
        // return "Yeah";
    }

    // Update suggestion action
    @RequestMapping(value = "/updateSuggestion", method = RequestMethod.POST)
    @ResponseBody
    public Suggestion updateArt(@RequestBody Suggestion Suggestion) {
        // Suggestion.setDatastatus(1);
        // SuggestionDao.updateSuggestion(Suggestion);
        // System.out.println(Suggestion.getId());
        Suggestion curSuggestion = suggestionDao.getSuggestionById(Suggestion.getId());
        curSuggestion.setContent(Suggestion.getContent());
        suggestionDao.updateSuggestion(curSuggestion);
        return curSuggestion;
    }
}
