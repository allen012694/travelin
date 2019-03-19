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

import fu.cap.travelin.dao.ArticleDAO;
import fu.cap.travelin.dao.CommentDAO;
import fu.cap.travelin.dao.LikingDAO;
import fu.cap.travelin.dao.TagDAO;
import fu.cap.travelin.model.Account;
import fu.cap.travelin.model.Article;
import fu.cap.travelin.model.ArticleTag;
import fu.cap.travelin.model.Comment;
import fu.cap.travelin.model.Liking;
import fu.cap.travelin.model.Tag;

@SessionAttributes({ "currentAccount" })
@Controller
public class ArticleController {

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

    @Resource(name = "travelinProp")
    private Properties travelinProp;

    @Autowired
    private ArticleDAO articleDao;

    @Autowired
    private CommentDAO commentDao;

    @Autowired
    private TagDAO tagDao;

    @Autowired
    private LikingDAO likingDao;

    // Dummy currentAccount
    @ModelAttribute("currentAccount")
    public Account populateAccount() {
        return new Account(); // populates account for the first time if null
    }

    // Article list admin page
    @RequestMapping(value = "/adminarticles", method = RequestMethod.GET)
    public String getAdminArticles(Model model) {
        List<Article> list = articleDao.getAll();

        model.addAttribute("articles", list);
        return "admin-articles";
    }

    // Article list
    @RequestMapping(value = "/articles", method = RequestMethod.GET)
    public String getAllArticle(Model model,
            @RequestParam(value = "page", required = false, defaultValue = "1") String page,
            @RequestParam(value = "steps", required = false, defaultValue = "6") String steps,
            @RequestParam(value = "type", required = false, defaultValue = "last") String type,
            @ModelAttribute("currentAccount") Account currentAccount) {
        // check if there is login user
        model.addAttribute("lastarticles", articleDao.getLastestArticles(3, ArticleDAO.NO_EXCEPT));
        model.addAttribute("hotArticles", articleDao.getMostLikedArticles7Days(3, ArticleDAO.NO_EXCEPT));
        model.addAttribute("articles",
                articleDao.getAvailableByPage(Integer.parseInt(page), Integer.parseInt(steps), type));
        model.addAttribute("count", articleDao.countAvailable());
        model.addAttribute("hotTags", tagDao.getTopSearchTags(10));
        model.addAttribute("page", page);
        return "articles";
    }

    // Article detail show page
    @RequestMapping(value = "/articles/{artid}", method = RequestMethod.GET)
    public String showEditArticle(@PathVariable String artid, Model model,
            @ModelAttribute("currentAccount") Account account) {
        Article art = articleDao.getArticleById(Integer.parseInt(artid));
        List<Comment> comments = commentDao.getArticleCommentsByArticleId(art.getId());
        List<Liking> likes = new ArrayList<Liking>();

        if (null != account.getEmail()) {
            // return "redirect:/login";
            for (Comment cmt : comments) {
                likes.add(likingDao.getLikeComment(cmt.getId(), account.getId()));
            }
            Liking likeArticles = likingDao.getLikeArticle(art.getId(), account.getId());
            model.addAttribute("likeArticles", likeArticles);
        }

        List<ArticleTag> artTags = tagDao.getArticleTags(art.getId());

        List<String> atags = new ArrayList<String>();
        for (ArticleTag atag : artTags) {
            atags.add(atag.getTag().getName());
        }
        Long countLikeArticle = likingDao.countLikeArticle(art.getId());
        List<LikeCmt> countLikeComments = new ArrayList<LikeCmt>();
        for (Comment cmt : comments) {
            Long countLikeComment = likingDao.countLikeComment(cmt.getId());

            countLikeComments.add(new LikeCmt(cmt.getId(), countLikeComment));
        }

        model.addAttribute("lastarticles", articleDao.getLastestArticles(3, art.getId()));
        model.addAttribute("hotArticles", articleDao.getMostLikedArticles7Days(3, art.getId()));
        model.addAttribute("countLikeComment", countLikeComments);
        model.addAttribute("curTags", atags);
        model.addAttribute("newComment", new Comment());
        model.addAttribute("comments", comments);
        model.addAttribute("likes", likes);
        model.addAttribute("curArt", art);
        model.addAttribute("countLikeArticle", countLikeArticle);
        model.addAttribute("hotTags", tagDao.getTopSearchTags(10));
        return "article";
    }

    // New article form show page
    @RequestMapping(value = "/articles/new", method = RequestMethod.GET)
    public String showNewArticle(Model model) {
        // Article art = articleDao.getArticleById(Integer.parseInt(artid));
        model.addAttribute("newArt", new Article());
        // model.addAttribute("cities", areaDao.)
        return "mod-article";
    }

    // New article post admin action
    @RequestMapping(value = "/adminarticles/new", method = RequestMethod.GET)
    public String createNewArticle(Model model) {
        // Article art = articleDao.getArticleById(Integer.parseInt(artid));
        model.addAttribute("newArt", new Article());
        return "admin-mod-article";
    }

    // New article post action
    @RequestMapping(value = "/articles/new", method = RequestMethod.POST)
    public String newArticle(@ModelAttribute("newArt") Article newArt, Model model,
            @ModelAttribute("currentAccount") Account curAcc, @RequestParam(value = "image") MultipartFile uploadImage,
            @RequestParam(value = "tags") String tags, @RequestParam("cururl") String url,
            @RequestParam("curfunc") String func) {
        // Article art = articleDao.getArticleById(Integer.parseInt(artid));
        // model.addAttribute("newArt", new Article());

        newArt.setDatastatus(1);
        newArt.setPriority(0);
        newArt.setAuthor(curAcc);
        articleDao.insertArticle(newArt);

        List<ArticleTag> arttags = new ArrayList<ArticleTag>();
        if (null != tags && 0 < tags.length()) {
            String[] taglist = tags.split(",");
            for (String tag : taglist) {
                Tag t = new Tag();
                t.setName(tag);
                t.setSearchcount(0);
                tagDao.findOrInsertTag(t);
                arttags.add(new ArticleTag(newArt, t));
            }
        }
        tagDao.insertArticleTags(arttags);

        if (!uploadImage.isEmpty()) {
            try {
                URI uri = new URI(HomeController.class.getResource("").getPath());
                String uploadDir = uri.getPath() + "../../../../../resources/images/" + "articles/";
                if (!new File(uploadDir).exists()) {
                    new File(uploadDir).mkdirs();
                }

                String[] filestr = uploadImage.getOriginalFilename().split("\\.");
                String filename = newArt.getId() + "." + filestr[filestr.length - 1].toLowerCase();
                File uploadFile = new File(uploadDir + filename);

                uploadImage.transferTo(uploadFile);

            } catch (Exception e) {
                e.printStackTrace();
                return "redirect:/resources/pages/error.html";
            }
        } else {
            try {
                URI uri = new URI(HomeController.class.getResource("").getPath());
                String artDir = uri.getPath() + "../../../../../resources/images/" + "articles/";
                File defaultTheme = new File(artDir + "0.jpg");
                File newArticleTheme = new File(artDir + newArt.getId() + ".jpg");
                Files.copy(defaultTheme.toPath(), newArticleTheme.toPath(), StandardCopyOption.REPLACE_EXISTING);
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

    // Delete an article action (status -1)
    @RequestMapping(value = "/articles/del", method = RequestMethod.POST)
    // @ResponseBody
    @ResponseStatus(value = HttpStatus.OK)
    public void deleteArticle(@RequestParam("aid") String artid, Model model) {
        Article art = articleDao.getArticleById(Integer.parseInt(artid));
        art.setDatastatus(-1);
        articleDao.updateArticle(art);
        // return "Yeah";
    }

    // Verify an article
    @RequestMapping(value = "/articles/verify", method = RequestMethod.POST)
    // @ResponseBody
    @ResponseStatus(value = HttpStatus.OK)
    public void verifyArticle(@RequestParam("aid") String artid, Model model) {
        Article art = articleDao.getArticleById(Integer.parseInt(artid));
        art.setDatastatus(1);
        articleDao.updateArticle(art);
        // return "Yeah";
    }

    // Unverify an article
    @RequestMapping(value = "/articles/unverify", method = RequestMethod.POST)
    // @ResponseBody
    @ResponseStatus(value = HttpStatus.OK)
    public void unverifyArticle(@RequestParam("aid") String artid, Model model) {
        Article art = articleDao.getArticleById(Integer.parseInt(artid));
        art.setDatastatus(0);
        articleDao.updateArticle(art);
        // return "Yeah";
    }

    // Update article form show admin page
    @RequestMapping(value = "/adminarticles/update", method = RequestMethod.GET)
    public String editArticle(Model model, @RequestParam("k") String artId) {
        Article curArt = articleDao.getArticleById(Integer.parseInt(artId));
        List<ArticleTag> artTags = tagDao.getArticleTags(curArt.getId());
        String atags = "";
        for (ArticleTag atag : artTags) {
            atags += atag.getTag().getName() + ",";
        }
        // System.out.println(atags);
        model.addAttribute("curArt", curArt);
        model.addAttribute("curTags", atags);
        return "admin-mod-article";
    }

    // Update article form show page
    @RequestMapping(value = "/articles/update", method = RequestMethod.GET)
    public String showEditArticle(Model model, @RequestParam("k") String artId) {
        Article curArt = articleDao.getArticleById(Integer.parseInt(artId));
        List<ArticleTag> artTags = tagDao.getArticleTags(curArt.getId());
        String atags = "";
        for (ArticleTag atag : artTags) {
            atags += atag.getTag().getName() + ",";
        }
        // System.out.println(atags);
        model.addAttribute("curArt", curArt);
        model.addAttribute("curTags", atags);
        return "mod-article";
    }

    // Update article action
    @RequestMapping(value = "/articles/update", method = RequestMethod.POST)
    public String updateArt(Model model, @ModelAttribute("curArt") Article article,
            @RequestParam(value = "image") MultipartFile uploadImage, @RequestParam(value = "tags") String tags,
            @RequestParam("cururl") String url, @RequestParam("curfunc") String func) throws IOException {
        article.setDatastatus(1);
        article.setPriority(0);
        articleDao.updateArticle(article);

        tagDao.cleanArticleTags(article.getId());
        List<ArticleTag> arttags = new ArrayList<ArticleTag>();
        if (null != tags && 0 < tags.length()) {
            String[] taglist = tags.split(",");
            for (String tag : taglist) {
                Tag t = new Tag();
                t.setName(tag);
                tagDao.findOrInsertTag(t);
                arttags.add(new ArticleTag(article, t));
            }
        }
        tagDao.insertArticleTags(arttags);

        if (!uploadImage.isEmpty()) {
            try {
                URI uri = new URI(HomeController.class.getResource("").getPath());
                String uploadDir = uri.getPath() + "../../../../../resources/images/" + "articles/";
                if (!new File(uploadDir).exists()) {
                    new File(uploadDir).mkdirs();
                }

                String[] filestr = uploadImage.getOriginalFilename().split("\\.");
                String filename = article.getId() + "." + filestr[filestr.length - 1].toLowerCase();
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

    // New article comment action
    @RequestMapping(value = "/articles/comments/new", method = RequestMethod.POST)
    public String newComment(@ModelAttribute("newComment") Comment newComment, Model model,
            @ModelAttribute("currentAccount") Account curAcc, @RequestParam("articleid") String articleid) {
        // newComment.setDatastatus(1);
        Article art = articleDao.getArticleById(Integer.parseInt(articleid));
        newComment.setAccount(curAcc);
        newComment.setTargetid(art.getId());
        commentDao.insertArticleComment(newComment);

        return "redirect:/articles/" + art.getId();
    }

    // Delete article comment action
    @RequestMapping(value = "/articles/comments/del", method = RequestMethod.POST)
    @ResponseStatus(value = HttpStatus.OK)
    // @ResponseBody
    public void deleteArtComment(@RequestParam("id") String commentid, Model model) {
        Comment comment = commentDao.getCommentById(Integer.parseInt(commentid));
        // comment.setDatastatus(-1);
        // commentDao.updateComment(comment);
        commentDao.deleteComment(comment);
        // return "Yeah";
    }

    // Update article comment action
    @RequestMapping(value = "/articles/updateComment", method = RequestMethod.POST)
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
}
