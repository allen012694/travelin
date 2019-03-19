package fu.cap.travelin;

import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import fu.cap.travelin.dao.ArticleDAO;
import fu.cap.travelin.dao.CommentDAO;
import fu.cap.travelin.dao.JournalDAO;
import fu.cap.travelin.dao.LikingDAO;
import fu.cap.travelin.model.Account;
import fu.cap.travelin.model.Article;
import fu.cap.travelin.model.Comment;
import fu.cap.travelin.model.Liking;

@SessionAttributes({ "currentAccount" })
@Controller
public class LikingController {
    @Resource(name = "travelinProp")
    private Properties travelinProp;

    @Autowired
    private JournalDAO journalDao;

    @Autowired
    private ArticleDAO articleDao;

    @Autowired
    private LikingDAO likingDao;

    @Autowired
    private CommentDAO commentDao;

    // Dummy currentAccount
    @ModelAttribute("currentAccount")
    public Account populateAccount() {
        return new Account(); // populates account for the first time if null
    }

    @RequestMapping(value = "/likeComment/del", method = RequestMethod.POST)
    @ResponseBody
    public String deleteLikeComment(@RequestParam("commentid") String commentid, Model model,
            @ModelAttribute("currentAccount") Account account) {

        Liking like = likingDao.getLikeComment(Integer.parseInt(commentid), account.getId());

        likingDao.deleteLike(like);

        return likingDao.countLikeComment(Integer.parseInt(commentid)).toString();
    }

    @RequestMapping(value = "/likeComment/new", method = RequestMethod.POST)
    @ResponseBody
    public String newLikeComment(@ModelAttribute("newLike") Liking newLike, Model model,
            @ModelAttribute("currentAccount") Account curAcc, @RequestParam("commentid") String commentid) {

        Comment comment = commentDao.getCommentById(Integer.parseInt(commentid));
        newLike.setAccount(curAcc);
        newLike.setTargetid(comment.getId());
        likingDao.insertLikeComment(newLike);
        return likingDao.countLikeComment(Integer.parseInt(commentid)).toString();
    }

    @RequestMapping(value = "/likeArticle/del", method = RequestMethod.POST)
    @ResponseBody
    public String deleteLikeArticle(@RequestParam("articleid") String articleid, Model model,
            @ModelAttribute("currentAccount") Account account) {

        Liking like = likingDao.getLikeArticle(Integer.parseInt(articleid), account.getId());
        likingDao.deleteLike(like);
        return likingDao.countLikeArticle(Integer.parseInt(articleid)).toString();
    }

    @RequestMapping(value = "/likeArticle/new", method = RequestMethod.POST)
    @ResponseBody
    public String newLikeArticle(@ModelAttribute("newLike") Liking newLike, Model model,
            @ModelAttribute("currentAccount") Account curAcc, @RequestParam("articleid") String articleid) {

        Article article = articleDao.getArticleById(Integer.parseInt(articleid));
        newLike.setAccount(curAcc);
        newLike.setTargetid(article.getId());
        likingDao.insertLikeArticle(newLike);
        return likingDao.countLikeArticle(Integer.parseInt(articleid)).toString();
    }

}
