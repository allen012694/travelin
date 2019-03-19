package fu.cap.travelin.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.transaction.annotation.Transactional;

import fu.cap.travelin.model.Comment;

public class CommentDAO {
    private SessionFactory sessionFactory;

    public CommentDAO(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public CommentDAO() {
    }

    @Transactional
    public Comment getCommentById(int id) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Comment.class);
        criteria.add(Restrictions.idEq(id));
        List<Comment> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public void deleteComment(Comment cmt) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        session.delete(cmt);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void updateComment(Comment newComment) {
        Session session = sessionFactory.openSession();
        Comment current = session.load(Comment.class, newComment.getId());
        session.beginTransaction();
        session.update(newComment);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void insertComment(Comment comment) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        session.save(comment);
        session.getTransaction().commit();
        session.close();
    }

    /********************* Article Comment zone **********************/
    @Transactional
    public List<Comment> getArticleCommentsByArticleId(int articleid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Comment.class);
        // criteria.add(Restrictions.not(Restrictions.eq("datastatus", -1)));
        criteria.add(Restrictions.eq("targetid", articleid));
        criteria.add(Restrictions.like("targettype", "article"));
        criteria.addOrder(Order.desc("createddate"));
        List<Comment> list = criteria.list();

        return list;
    }

    @Transactional
    public void insertArticleComment(Comment comment) {
        Session session = sessionFactory.openSession();
        comment.setTargettype("article");
        session.beginTransaction();
        session.save(comment);
        session.getTransaction().commit();
        session.close();
    }

    /********************* Journal Comment zone **********************/
    @Transactional
    public List<Comment> getJournalCommentsByJournalId(int journalid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Comment.class);
        // criteria.add(Restrictions.not(Restrictions.eq("datastatus", -1)));
        criteria.add(Restrictions.eq("targetid", journalid));
        criteria.add(Restrictions.like("targettype", "journal"));
        criteria.addOrder(Order.desc("createddate"));
        List<Comment> list = criteria.list();

        return list;
    }

    @Transactional
    public void insertJournalComment(Comment comment) {
        Session session = sessionFactory.openSession();
        comment.setTargettype("journal");
        session.beginTransaction();
        session.save(comment);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public Comment getCommentsByJournalId(int journalid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Comment.class);
        criteria.add(Restrictions.eq("targetid", journalid));
        criteria.add(Restrictions.like("targettype", "journal"));
        List<Comment> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;

    }

    @Transactional
    public Comment getCommentsByArticleId(int articleid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Comment.class);
        criteria.add(Restrictions.eq("targetid", articleid));
        criteria.add(Restrictions.like("targettype", "article"));
        List<Comment> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;

    }
}