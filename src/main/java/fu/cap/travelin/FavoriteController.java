package fu.cap.travelin;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.SessionAttributes;

import fu.cap.travelin.dao.AccountDAO;
import fu.cap.travelin.dao.FavoriteDAO;
import fu.cap.travelin.dao.JournalDAO;
import fu.cap.travelin.dao.PlaceDAO;
import fu.cap.travelin.dao.RelationshipDAO;
import fu.cap.travelin.model.Account;
import fu.cap.travelin.model.Favorite;
import fu.cap.travelin.model.Journal;
import fu.cap.travelin.model.Place;
import fu.cap.travelin.model.Relationship;

@SessionAttributes({ "currentAccount" })
@Controller
public class FavoriteController {
    @Resource(name = "travelinProp")
    private Properties travelinProp;

    @Autowired
    private AccountDAO accountDao;

    @Autowired
    private PlaceDAO placeDao;

    @Autowired
    private RelationshipDAO relationshipDao;

    @Autowired
    private JournalDAO journalDao;

    @Autowired
    private FavoriteDAO favoriteDao;

    // Dummy currentAccount
    @ModelAttribute("currentAccount")
    public Account populateAccount() {
        return new Account(); // populates account for the first time if null
    }

    /***************** Favorite Place *****************/
    @RequestMapping(value = "/favoritePlace/del", method = RequestMethod.POST)
    // @ResponseBody
    @ResponseStatus(value = HttpStatus.OK)
    public void deleteFavoritePlace(@RequestParam("placeid") String pid, Model model,
            @ModelAttribute("currentAccount") Account account) {

        Favorite favoritePlace = favoriteDao.getFavoritePlace(Integer.parseInt(pid), account.getId());
        favoriteDao.deleteFavorite(favoritePlace);
    }

    @RequestMapping(value = "/favoritePlace/new", method = RequestMethod.POST)
    @ResponseStatus(value = HttpStatus.OK)
    public String newFavoritePlace(@ModelAttribute("newFavoritePlace") Favorite newFavoritePlace, Model model,
            @ModelAttribute("currentAccount") Account curAcc, @RequestParam("placeid") String placeid) {

        Place place = placeDao.getPlaceById(Integer.parseInt(placeid));
        newFavoritePlace.setAccount(curAcc);
        newFavoritePlace.setTargetid(place.getId());
        favoriteDao.insertFavoritePlace(newFavoritePlace);
        return "redirect:/places/" + place.getId();
    }

    /***************** Favorite Journal *****************/
    @RequestMapping(value = "/favoriteJournal/del", method = RequestMethod.POST)
    // @ResponseBody
    @ResponseStatus(value = HttpStatus.OK)
    public void deleteFavoriteJournal(@RequestParam("jid") String jid, Model model,
            @ModelAttribute("currentAccount") Account account) {

        Favorite favoriteJournal = favoriteDao.getFavoriteJournal(Integer.parseInt(jid), account.getId());
        favoriteDao.deleteFavorite(favoriteJournal);
    }

    @RequestMapping(value = "/favoriteJournal/new", method = RequestMethod.POST)
    @ResponseStatus(value = HttpStatus.OK)
    public String newFavoriteJournal(@ModelAttribute("newFavoriteJournal") Favorite newFavoriteJournal, Model model,
            @ModelAttribute("currentAccount") Account curAcc, @RequestParam("jid") String jid) {

        Journal journal = journalDao.getJournalById(Integer.parseInt(jid));
        newFavoriteJournal.setAccount(curAcc);
        newFavoriteJournal.setTargetid(journal.getId());

        favoriteDao.insertFavoriteJournal(newFavoriteJournal);
        return "redirect:/journals/" + journal.getId();
    }

    @RequestMapping(value = "/favorite/list", method = RequestMethod.GET)
    public String listFavoriteUser(Model model, @ModelAttribute("currentAccount") Account currentAccount,
            @RequestParam(name = "k", required = false) String accid) {
        int targetAccountId;
        if (accid != null && accid.length() > 0) {
            if (currentAccount.getEmail() != null && currentAccount.getId().intValue() == Integer.parseInt(accid))
                return "redirect:/favorite/list";
            targetAccountId = Integer.parseInt(accid);
        } else if (currentAccount.getEmail() != null) {
            targetAccountId = currentAccount.getId();
        } else {
            return "redirect:/login";
        }
        Account currentProfile = accountDao.getAccountById(targetAccountId);
        List<Favorite> favPlaces = favoriteDao.getFavoritePlacesByAccountId(targetAccountId);
        List<Favorite> favJournals = favoriteDao.getFavoriteJournalsByAccountId(targetAccountId);
        List<Place> listFavPlaces = new ArrayList<Place>();
        List<Journal> listFavJournals = new ArrayList<Journal>();
        // Relationship rs = null;
        for (Favorite favorite : favPlaces) {
            Place pla = placeDao.getPlaceById(favorite.getTargetid());
            listFavPlaces.add(pla);
        }
        // if (currentAccount.getEmail() != null && currentAccount.getId() !=
        // targetAccountId) {
        // rs = relationshipDao.getRelationshipByAccountIds(targetAccountId,
        // currentAccount.getId());
        // }
        for (Favorite favorite : favJournals) {
            Journal jour = journalDao.getJournalById(favorite.getTargetid());
            if (currentAccount.getEmail() != null && currentAccount.getEmail().length() > 0) {
                Relationship rs = relationshipDao.getRelationshipByAccountIds(currentAccount.getId(),
                        jour.getAuthor().getId());
                if (rs == null && jour.getDatastatus() == 2)
                    // case have friends
                    continue;
            }
            if (currentAccount.getEmail() == null && (jour.getDatastatus() == 3 || jour.getDatastatus() == 0))
                // case private & draft
                continue;
            listFavJournals.add(jour);
        }
        // model.addAttribute("accountProfile")
        model.addAttribute("accountProfile", currentProfile);
        model.addAttribute("favPlaces", listFavPlaces);
        model.addAttribute("favJournals", listFavJournals);
        return "myfavlist";
    }
}
