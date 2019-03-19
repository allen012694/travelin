package fu.cap.travelin;

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

import fu.cap.travelin.dao.FeedbackDAO;
import fu.cap.travelin.model.Account;
import fu.cap.travelin.model.Article;
import fu.cap.travelin.model.Feedback;

/**
 * Handles requests for the application home page.
 */
@SessionAttributes({ "currentAccount" })
@Controller
public class FeedbackController {
    @Resource(name = "travelinProp")
    private Properties travelinProp;

    // Dummy currentAccount
    @ModelAttribute("currentAccount")
    public Account populateAccount() {
        return new Account(); // populates account for the first time if null
    }

    @Autowired
    private FeedbackDAO feedbackDao;

    // Show feedback form
    @RequestMapping(value = "/feedback", method = RequestMethod.GET)
    public String feedback(Model model, @ModelAttribute("currentAccount") Account currentAccount,
            @ModelAttribute("newFeedback") Feedback feedback, @ModelAttribute("currentAccount") Account curAcc) {
        model.addAttribute("newFeedback", new Feedback());

        return "feedback";
    }

    // Show new feedback form admin
    @RequestMapping(value = "/adminfeedbacks/new", method = RequestMethod.GET)
    public String createNewArticle(Model model) {
        // Article art = articleDao.getArticleById(Integer.parseInt(artid));
        model.addAttribute("newFeedback", new Article());
        return "admin-mod-feedback";
    }

    // New feedback action
    @RequestMapping(value = "/feedback/new", method = RequestMethod.POST)
    public String newFeedback(@ModelAttribute("newFeedback") Feedback newFeedback, Model model,
            @ModelAttribute("currentAccount") Account curAcc) {
        if (null == curAcc.getEmail())
            return "redirect:/resources/pages/unauthorized.html";
        newFeedback.setDatastatus(1);
        newFeedback.setAccount(curAcc);
        feedbackDao.insertFeedback(newFeedback);

        return "redirect:/resources/pages/thanks.html";
    }

    // Show feedback list admin page
    @RequestMapping(value = "/adminfeedbacks", method = RequestMethod.GET)
    public String getAdminFeedbacks(Model model) {
        List<Feedback> list = feedbackDao.getAll();

        model.addAttribute("feedbacks", list);
        return "admin-feedbacks";
    }

    // Show update feedback form admin page
    @RequestMapping(value = "/adminfeedbacks/update", method = RequestMethod.GET)
    public String updateFb(Model model, @RequestParam("k") String fbId) {
        Feedback curFb = feedbackDao.getFeedbackById(Integer.parseInt(fbId));

        model.addAttribute("curFb", curFb);

        return "admin-mod-feedback";
    }

    // Update feedback action
    @RequestMapping(value = "/feedbacks/update", method = RequestMethod.POST)
    public String updateFeedback(@ModelAttribute("curFb") Feedback feedback, Model model,
            @RequestParam("cururl") String url, @RequestParam("curfunc") String func) {
        // model.addAttribute("accountProfile", account);
        // feedback.setUpdatedaccount(curAcc);
        feedback.setDatastatus(2);
        feedbackDao.updateFeedback(feedback);
        model.addAttribute("curfunc", func);
        return "redirect:/" + url;
    }

    // Delete feedback action
    @RequestMapping(value = "/feedbacks/del", method = RequestMethod.POST)
    // @ResponseBody
    @ResponseStatus(value = HttpStatus.OK)
    public void deleteFeedback(@RequestParam("fid") String feedbackid, Model model, @ModelAttribute("currentAccount") Account currentAccount) {
        Feedback feedback = feedbackDao.getFeedbackById(Integer.parseInt(feedbackid));
        feedback.setDatastatus(-1);
        feedback.setUpdatedaccount(currentAccount);
        feedbackDao.updateFeedback(feedback);
        // return "Yeah";
    }

    // Verify feedback action
    @RequestMapping(value = "/feedbacks/verify", method = RequestMethod.POST)
    // @ResponseBody
    @ResponseStatus(value = HttpStatus.OK)
    public void verifyFeedback(@RequestParam("fid") String feedbackid, Model model, @ModelAttribute("currentAccount") Account currentAccount) {
        Feedback feedback = feedbackDao.getFeedbackById(Integer.parseInt(feedbackid));
        feedback.setUpdatedaccount(currentAccount);
        feedback.setDatastatus(2);
        feedbackDao.updateFeedback(feedback);
        // return "Yeah";
    }

    // Unverify Feedback action
    @RequestMapping(value = "/feedbacks/unverify", method = RequestMethod.POST)
    // @ResponseBody
    @ResponseStatus(value = HttpStatus.OK)
    public void unverifyFeedback(@RequestParam("fid") String feedbackid, Model model, @ModelAttribute("currentAccount") Account currentAccount) {
        Feedback feedback = feedbackDao.getFeedbackById(Integer.parseInt(feedbackid));
        feedback.setDatastatus(1);
        feedback.setUpdatedaccount(currentAccount);
        feedbackDao.updateFeedback(feedback);
        // return "Yeah";
    }

}