package fu.cap.travelin.dao;

import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.hibernate.transform.AliasToEntityMapResultTransformer;
import org.springframework.transaction.annotation.Transactional;

import fu.cap.travelin.model.Article;

public class ArticleDAO {
    private SessionFactory sessionFactory;
    public static final int NO_EXCEPT = 0;

    public ArticleDAO(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public ArticleDAO() {
    }

    @Transactional
    public List<Article> getAll() {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Article.class);
        List<Article> list = criteria.list();

        return list;
    }

    @Transactional
    public List<Article> getAllByPage(Integer page, Integer steps) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Article.class);
        criteria.setFirstResult((page - 1) * steps);
        criteria.setMaxResults(steps);
        List<Article> list = criteria.list();

        return list;
    }

    @Transactional
    public List<Article> getAvailableByPage(Integer page, Integer steps, String order) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Article.class);
        criteria.add(Restrictions.eq("datastatus", 1));
        switch (order) {
        /* case "hot": criteria.addOrder(Order.desc("createddate"));break; */
        case "last":
            criteria.addOrder(Order.desc("createddate"));
            break;
        default:
            break;
        }
        criteria.setFirstResult((page - 1) * steps);
        criteria.setMaxResults(steps);
        List<Article> list = criteria.list();

        return list;
    }

    @Transactional
    public Long countAvailable() {
        return (Long) sessionFactory.getCurrentSession().createCriteria(Article.class)
                .add(Restrictions.eq("datastatus", 1)).setProjection(Projections.rowCount()).uniqueResult();
    }

    @Transactional
    public Long countAll() {
        return (Long) sessionFactory.getCurrentSession().createCriteria(Article.class)
                .setProjection(Projections.rowCount()).uniqueResult();
    }

    @Transactional
    public List<Article> getAllAvailable() {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Article.class);
        criteria.add(Restrictions.not(Restrictions.eq("datastatus", -1)));
        List<Article> list = criteria.list();

        return list;
    }

    @Transactional
    public Article getArticleById(int id) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Article.class);
        criteria.add(Restrictions.idEq(id));
        List<Article> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public void updateArticle(Article newArticle) {
        Session session = sessionFactory.openSession();
        Article current = session.load(Article.class, newArticle.getId());
        session.beginTransaction();
        session.update(newArticle);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void insertArticle(Article article) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        session.save(article);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public List<Article> getSearchArticleResult(String searchText) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Article.class);
        criteria.add(Restrictions.like("title", "%" + searchText + "%").ignoreCase());
        List<Article> list = criteria.list();
        return list;
        // SELECT * FROM Article WHERE Title like '%searchText%'
    }

    @Transactional
    public List<Article> getTopSearchArticleResult(String searchText, int amount) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Article.class);
        criteria.add(Restrictions.like("title", "%" + searchText + "%").ignoreCase());
        criteria.setMaxResults(amount);
        List<Article> list = criteria.list();
        return list;
        // SELECT * FROM Article WHERE Title like '%searchText%'
    }

    @Transactional
    public List<Article> getLastestArticles(int amount) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Article.class);
        // criteria.add(Restrictions.like("title", "%" + searchText +
        // "%").ignoreCase());
        criteria.add(Restrictions.eq("datastatus", 1));
        criteria.addOrder(Order.desc("createddate"));
        criteria.setMaxResults(amount);
        List<Article> list = criteria.list();
        return list;
    }

    @Transactional
    public List<Article> getArticle(int id) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Article.class);
        criteria.add(Restrictions.idEq(id));
        List<Article> list = criteria.list();
        return list;
        // SELECT * FROM Article WHERE Title like '%searchText%'
    }

    @Transactional
    public List<Article> getLastestArticles(int amount, int except) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Article.class);
        criteria.add(Restrictions.eq("datastatus", 1));
        if (except > NO_EXCEPT)
            criteria.add(Restrictions.ne("id", except));
        criteria.addOrder(Order.desc("createddate"));
        criteria.setMaxResults(amount);
        List<Article> list = criteria.list();
        return list;
    }

    @Transactional
    public List<Map<String, Object>> getMostLikedArticles7Days(int amount, int except) {
        Session session = sessionFactory.getCurrentSession();
        String exceptStr = (except > NO_EXCEPT) ? (" and Id != " + except) : "";
        String sql = "select art.*, ifnull(artlikerank.LikeCount,0) as LiCount from "
                + "(select * from Article where DataStatus = 1" + exceptStr
                + " and CreatedDate between date_sub(now(), interval 7 day) and now()) as art left join "
                + "(select TargetId, count(*) as LikeCount from Liking where TargetType like 'article' group by TargetId) as artlikerank "
                + "on art.id = artlikerank.TargetId " + "order by LiCount desc " + "limit " + amount;
        SQLQuery query = session.createSQLQuery(sql);
        query.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE);
        List<Map<String, Object>> list = query.list();
        return list;
    }
}
