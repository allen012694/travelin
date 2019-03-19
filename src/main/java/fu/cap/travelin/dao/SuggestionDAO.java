package fu.cap.travelin.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.transaction.annotation.Transactional;

import fu.cap.travelin.model.Place;
import fu.cap.travelin.model.Suggestion;

public class SuggestionDAO {
    private SessionFactory sessionFactory;

    public SuggestionDAO(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public SuggestionDAO() {
    }

    @Transactional
    public List<Suggestion> getAll() {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Suggestion.class);
        List<Suggestion> list = criteria.list();

        return list;
    }

    @Transactional
    public List<Suggestion> getAllAvailable() {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Suggestion.class);
        criteria.add(Restrictions.not(Restrictions.eq("dataStatus", -1)));
        List<Suggestion> list = criteria.list();

        return list;
    }

    @Transactional
    public Suggestion getSuggestionById(int id) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Suggestion.class);
        criteria.add(Restrictions.idEq(id));
        List<Suggestion> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public List<Suggestion> getSuggestionByPlaceId(int placeid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Suggestion.class);
        criteria.add(Restrictions.not(Restrictions.eq("datastatus", -1)));
        criteria.add(Restrictions.eq("place.id", placeid));
        criteria.addOrder(Order.desc("createddate"));
        List<Suggestion> list = criteria.list();

        return list;
    }

    @Transactional
    public void updateSuggestion(Suggestion newSuggestion) {
        Session session = sessionFactory.openSession();
        Suggestion current = session.load(Suggestion.class, newSuggestion.getId());
        session.beginTransaction();
        session.update(newSuggestion);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void insertSuggestion(Suggestion suggestion) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        session.save(suggestion);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public Long countRecommendPlace(Place place) {
        return (Long) sessionFactory.getCurrentSession().createCriteria(Suggestion.class)
                .add(Restrictions.eq("place", place)).add(Restrictions.eq("recommend", 1))
                .setProjection(Projections.rowCount()).uniqueResult();
    }

    @Transactional
    public Long countNotRecommendPlace(Place place) {
        return (Long) sessionFactory.getCurrentSession().createCriteria(Suggestion.class)
                .add(Restrictions.eq("place", place)).add(Restrictions.eq("recommend", 0))
                .setProjection(Projections.rowCount()).uniqueResult();
    }
}
