package fu.cap.travelin.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.transaction.annotation.Transactional;

import fu.cap.travelin.model.Feedback;

public class FeedbackDAO {
    private SessionFactory sessionFactory;

    public FeedbackDAO(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public FeedbackDAO() {
    }

    @Transactional
    public List<Feedback> getAll() {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Feedback.class);
        List<Feedback> list = criteria.list();

        return list;
    }

    @Transactional
    public List<Feedback> getAllAvailable() {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Feedback.class);
        criteria.add(Restrictions.not(Restrictions.eq("datastatus", -1)));
        List<Feedback> list = criteria.list();

        return list;
    }

    @Transactional
    public List<Feedback> getAllUnsolved() {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Feedback.class);
        criteria.add(Restrictions.eq("datastatus", 1));
        criteria.addOrder(Order.desc("createddate"));
        List<Feedback> list = criteria.list();

        return list;
    }

    @Transactional
    public Feedback getFeedbackById(int id) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Feedback.class);
        criteria.add(Restrictions.idEq(id));
        List<Feedback> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public void updateFeedback(Feedback newFeedback) {
        Session session = sessionFactory.openSession();
        Feedback current = session.load(Feedback.class, newFeedback.getId());
        session.beginTransaction();
        session.update(newFeedback);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void insertFeedback(Feedback feedback) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        session.save(feedback);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public List<Feedback> getAllByPage(Integer page, Integer steps) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Feedback.class);
        criteria.setFirstResult((page - 1) * steps);
        criteria.setMaxResults(steps);
        List<Feedback> list = criteria.list();

        return list;
    }

    @Transactional
    public Long countAvailable() {
        return (Long) sessionFactory.getCurrentSession().createCriteria(Feedback.class)
                .add(Restrictions.eq("datastatus", 1)).setProjection(Projections.rowCount()).uniqueResult();
    }

    @Transactional
    public Long countAll() {
        return (Long) sessionFactory.getCurrentSession().createCriteria(Feedback.class)
                .setProjection(Projections.rowCount()).uniqueResult();
    }
}
