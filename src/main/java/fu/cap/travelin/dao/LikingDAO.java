package fu.cap.travelin.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.transaction.annotation.Transactional;

import fu.cap.travelin.model.Liking;

public class LikingDAO {
    private SessionFactory sessionFactory;

    public LikingDAO(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public LikingDAO() {
    }

    @Transactional
    public Liking getLikeById(int id) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Liking.class);
        criteria.add(Restrictions.idEq(id));
        List<Liking> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public void updateLike(Liking newLike) {
        Session session = sessionFactory.openSession();
        Liking current = session.load(Liking.class, newLike.getId());
        session.beginTransaction();
        session.update(newLike);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void deleteLike(Liking like) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        session.delete(like);
        session.getTransaction().commit();
        session.close();
    }

    // ******* Like comment action *******//
    @Transactional
    public List<Liking> getLikesByCommentId(int commentid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Liking.class);
        criteria.add(Restrictions.eq("targetid", commentid));
        criteria.add(Restrictions.like("targettype", "comment"));
        List<Liking> list = criteria.list();

        return list;
    }

    @Transactional
    public void insertLikeComment(Liking like) {
        Session session = sessionFactory.openSession();
        like.setTargettype("comment");
        session.beginTransaction();
        session.save(like);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public Liking getByCommentId(int commentid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Liking.class);
        criteria.add(Restrictions.eq("targetid", commentid));
        criteria.add(Restrictions.like("targettype", "comment"));
        List<Liking> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public Liking getLikeComment(int commentid, int accountid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Liking.class);
        criteria.add(Restrictions.eq("targetid", commentid));
        criteria.add(Restrictions.like("targettype", "comment"));
        criteria.add(Restrictions.eq("account.id", accountid));
        List<Liking> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    // ******* Like article action *******//
    @Transactional
    public List<Liking> getLikesByArticleId(int articleid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Liking.class);
        criteria.add(Restrictions.eq("targetid", articleid));
        criteria.add(Restrictions.like("targettype", "article"));
        List<Liking> list = criteria.list();

        return list;
    }

    @Transactional
    public Liking getByArticleId(int articleid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Liking.class);
        criteria.add(Restrictions.eq("targetid", articleid));
        criteria.add(Restrictions.like("targettype", "article"));
        List<Liking> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public Liking getLikeArticle(int articleid, int accountid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Liking.class);
        criteria.add(Restrictions.eq("targetid", articleid));
        criteria.add(Restrictions.like("targettype", "article"));
        criteria.add(Restrictions.eq("account.id", accountid));
        List<Liking> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public void insertLikeArticle(Liking like) {
        Session session = sessionFactory.openSession();
        like.setTargettype("article");
        session.beginTransaction();
        session.save(like);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public Long countLikeArticle(int articleid) {
        return (Long) sessionFactory.getCurrentSession().createCriteria(Liking.class)
                .add(Restrictions.eq("targetid", articleid)).add(Restrictions.like("targettype", "article"))
                .setProjection(Projections.rowCount()).uniqueResult();
    }

    @Transactional
    public Long countLikeComment(int commentid) {
        return (Long) sessionFactory.getCurrentSession().createCriteria(Liking.class)
                .add(Restrictions.eq("targetid", commentid)).add(Restrictions.like("targettype", "comment"))
                .setProjection(Projections.rowCount()).uniqueResult();

    }
}
