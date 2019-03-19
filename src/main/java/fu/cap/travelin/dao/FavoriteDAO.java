package fu.cap.travelin.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.transaction.annotation.Transactional;

import fu.cap.travelin.model.Favorite;

public class FavoriteDAO {
    private SessionFactory sessionFactory;

    public FavoriteDAO(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    @Transactional
    public Favorite getFavoriteById(int id) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Favorite.class);
        criteria.add(Restrictions.idEq(id));
        List<Favorite> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public void updateFavorite(Favorite newFavorite) {
        Session session = sessionFactory.openSession();
        Favorite current = session.load(Favorite.class, newFavorite.getId());
        session.beginTransaction();
        session.update(newFavorite);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void deleteFavorite(Favorite favorite) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        session.delete(favorite);
        session.getTransaction().commit();
        session.close();
    }

    /********************* Favorite Place zone ***********************/
    @Transactional
    public List<Favorite> getFavoritePlacesByAccountId(int accid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Favorite.class);
        criteria.add(Restrictions.eq("account.id", accid));
        criteria.add(Restrictions.like("targettype", "place"));
        List<Favorite> list = criteria.list();

        return list;
    }

    @Transactional
    public void insertFavoritePlace(Favorite favoritePlace) {
        Session session = sessionFactory.openSession();
        favoritePlace.setTargettype("place");
        session.beginTransaction();
        session.save(favoritePlace);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public Favorite getFavoritePlace(int placeid, int accountid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Favorite.class);
        criteria.add(Restrictions.eq("targetid", placeid));
        criteria.add(Restrictions.like("targettype", "place"));
        criteria.add(Restrictions.eq("account.id", accountid));
        List<Favorite> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    /********************** Favorite Journal zone ***********************/
    @Transactional
    public List<Favorite> getFavoriteJournalsByAccountId(int accid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Favorite.class);
        criteria.add(Restrictions.eq("account.id", accid));
        criteria.add(Restrictions.like("targettype", "journal"));
        List<Favorite> list = criteria.list();

        return list;
    }

    @Transactional
    public void insertFavoriteJournal(Favorite favoriteJournal) {
        Session session = sessionFactory.openSession();
        favoriteJournal.setTargettype("journal");
        session.beginTransaction();
        session.save(favoriteJournal);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public Favorite getFavoriteJournal(int journalid, int accountid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Favorite.class);
        criteria.add(Restrictions.eq("targetid", journalid));
        criteria.add(Restrictions.like("targettype", "journal"));
        criteria.add(Restrictions.eq("account.id", accountid));
        List<Favorite> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public Long countFavPlace(int placeid) {
        return (Long) sessionFactory.getCurrentSession().createCriteria(Favorite.class)
                .add(Restrictions.eq("targetid", placeid)).add(Restrictions.like("targettype", "place"))
                .setProjection(Projections.rowCount()).uniqueResult();
    }

    @Transactional
    public Long countFavJournal(int journalid) {
        return (Long) sessionFactory.getCurrentSession().createCriteria(Favorite.class)
                .add(Restrictions.eq("targetid", journalid)).add(Restrictions.like("targettype", "journal"))
                .setProjection(Projections.rowCount()).uniqueResult();
    }
}
