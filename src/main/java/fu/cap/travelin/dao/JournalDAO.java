package fu.cap.travelin.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.hibernate.transform.AliasToEntityMapResultTransformer;
import org.springframework.transaction.annotation.Transactional;

import fu.cap.travelin.model.Account;
import fu.cap.travelin.model.Journal;
import fu.cap.travelin.model.JournalPlace;

public class JournalDAO {
    // public static final int FILTER_ALL = 1;
    public static final int FILTER_PUBLIC = 1;
    public static final int FILTER_FRIENDS = 2;
    public static final int FILTER_PRIVATE = 3;
    public static final int FILTER_DRAFT = 0;

    private SessionFactory sessionFactory;

    public JournalDAO(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public JournalDAO() {
    }

    @Transactional
    public List<Journal> getAll() {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Journal.class);
        List<Journal> list = criteria.list();

        return list;
    }

    @Transactional
    public List<Journal> getAllPublic(String order) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Journal.class);
        criteria.add(Restrictions.eq("datastatus", 1));
        switch (order) {
        /* case "hot": criteria.addOrder(Order.desc("createddate"));break; */
        case "last":
            criteria.addOrder(Order.desc("createddate"));
            break;
        default:
            break;
        }
        List<Journal> list = criteria.list();

        return list;
    }

    @Transactional
    public Journal getJournalById(int id) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Journal.class);
        criteria.add(Restrictions.idEq(id));
        List<Journal> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public List<Journal> getJournalByAccount(Account target) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Journal.class);
        criteria.add(Restrictions.eq("author.id", target.getId()));
        criteria.add(Restrictions.not(Restrictions.eq("datastatus", -1)));
        List<Journal> list = criteria.list();
        return list;
    }

    @Transactional
    public List<Journal> getJournalByAccount(Account target, int filter) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Journal.class);
        criteria.add(Restrictions.eq("author.id", target.getId()));
        if (filter == JournalDAO.FILTER_FRIENDS)
            criteria.add(Restrictions.or(Restrictions.eq("datastatus", 1), Restrictions.eq("datastatus", 2)));
        else if (filter == JournalDAO.FILTER_PUBLIC)
            criteria.add(Restrictions.eq("datastatus", 1));
        else
            return new ArrayList<Journal>();
        List<Journal> list = criteria.list();
        return list;
    }

    @Transactional
    public void updateJournal(Journal newJournal) {
        Session session = sessionFactory.openSession();
        Journal current = session.load(Journal.class, newJournal.getId());
        session.beginTransaction();
        session.update(newJournal);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void insertJournal(Journal journal) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        session.save(journal);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void insertJournalPlace(JournalPlace jplace) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        session.save(jplace);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void insertJournalPlaces(List<JournalPlace> jplaces) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        for (JournalPlace jplace : jplaces) {
            session.save(jplace);
        }
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void cleanJournalPlaces(int jId) {
        Session session = sessionFactory.getCurrentSession();
        Query query = session.createQuery("delete JournalPlace where JournalId = :jid");
        query.setParameter("jid", jId);

        int rs = query.executeUpdate();
    }

    @Transactional
    public List<JournalPlace> getJournalPlaces(int jId) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(JournalPlace.class);
        criteria.add(Restrictions.eq("journal.id", jId));
        List<JournalPlace> list = criteria.list();
        return list;
    }

    @Transactional
    public List<Journal> getBestJournals(int amount) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Journal.class);
        criteria.addOrder(Order.desc("priority"));
        criteria.setMaxResults(amount);
        criteria.add(Restrictions.eq("datastatus", 1));
        List<Journal> list = criteria.list();
        return list;
    }

    @Transactional
    public List<Journal> getSearchJournalResult(String searchText) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Journal.class);
        criteria.add(Restrictions.like("title", "%" + searchText + "%").ignoreCase());
        List<Journal> list = criteria.list();
        return list;
        // SELECT * FROM Journal WHERE Title like '%searchText%'
    }

    @Transactional
    public List<Journal> getTopSearchJournalResult(String searchText, int amount) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Journal.class);
        criteria.add(Restrictions.like("title", "%" + searchText + "%").ignoreCase());
        criteria.setMaxResults(amount);
        List<Journal> list = criteria.list();
        return list;
        // SELECT * FROM Article WHERE Title like '%searchText%'
    }

    @Transactional
    public List<Journal> getAllByPage(Integer page, Integer steps) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Journal.class);
        criteria.setFirstResult((page - 1) * steps);
        criteria.setMaxResults(steps);
        List<Journal> list = criteria.list();

        return list;
    }

    @Transactional
    public List<Journal> getPublicByPage(Integer page, Integer steps, String order) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Journal.class);
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
        List<Journal> list = criteria.list();

        return list;
    }

    @Transactional
    public Long countPublic() {
        return (Long) sessionFactory.getCurrentSession().createCriteria(Journal.class)
                .add(Restrictions.eq("datastatus", 1)).setProjection(Projections.rowCount()).uniqueResult();
    }

    @Transactional
    public Long countAll() {
        return (Long) sessionFactory.getCurrentSession().createCriteria(Journal.class)
                .setProjection(Projections.rowCount()).uniqueResult();
    }

    @Transactional
    public List<Journal> getLastestJournalsFromAuthor(int amount, int authorId, int filter) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Journal.class);
        criteria.add(Restrictions.eq("author.id", authorId));
        if (filter == JournalDAO.FILTER_FRIENDS)
            criteria.add(Restrictions.or(Restrictions.eq("datastatus", 1), Restrictions.eq("datastatus", 2)));
        else if (filter == JournalDAO.FILTER_PUBLIC)
            criteria.add(Restrictions.eq("datastatus", 1));
        else if (filter == JournalDAO.FILTER_PRIVATE)
            criteria.add(Restrictions.gt("datastatus", 0));
        else
            return new ArrayList<Journal>();
        criteria.setMaxResults(amount);
        criteria.addOrder(Order.desc("createddate"));
        List<Journal> list = criteria.list();

        return list;
    }

    @Transactional
    public List<Journal> getLastestJournalsFromAuthorExcept(int amount, int authorId, int filter, int exceptJourId) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Journal.class);
        criteria.add(Restrictions.eq("author.id", authorId));
        criteria.add(Restrictions.ne("id", exceptJourId));
        if (filter == JournalDAO.FILTER_FRIENDS)
            criteria.add(Restrictions.or(Restrictions.eq("datastatus", 1), Restrictions.eq("datastatus", 2)));
        else if (filter == JournalDAO.FILTER_PUBLIC)
            criteria.add(Restrictions.eq("datastatus", 1));
        else if (filter == JournalDAO.FILTER_PRIVATE)
            criteria.add(Restrictions.gt("datastatus", 0));
        else
            return new ArrayList<Journal>();
        criteria.setMaxResults(amount);
        criteria.addOrder(Order.desc("createddate"));
        List<Journal> list = criteria.list();

        return list;
    }

    @Transactional
    public List<Journal> getMostLikedJournals(int amount, int filter) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Journal.class);

        if (filter == JournalDAO.FILTER_FRIENDS)
            criteria.add(Restrictions.or(Restrictions.eq("datastatus", 1), Restrictions.eq("datastatus", 2)));
        else if (filter == JournalDAO.FILTER_PUBLIC)
            criteria.add(Restrictions.eq("datastatus", 1));
        else if (filter == JournalDAO.FILTER_PRIVATE)
            criteria.add(Restrictions.gt("datastatus", 0));
        else
            return new ArrayList<Journal>();
        criteria.setMaxResults(amount);
        List<Journal> list = criteria.list();
        return list;
    }

    @Transactional
    public List<Map<String, Object>> getMostFavJournalsIn7Days(int amount, int filter) {
        Session session = sessionFactory.getCurrentSession();
        String dstatuscond = "";
        if (filter == JournalDAO.FILTER_FRIENDS)
            dstatuscond = "DataStatus = 1 or DataStatus = 2";
        else if (filter == JournalDAO.FILTER_PUBLIC)
            dstatuscond = "DataStatus = 1";
        else if (filter == JournalDAO.FILTER_PRIVATE)
            dstatuscond = "DataStatus > 0";
        else
            return new ArrayList<Map<String, Object>>();
        String sql = "select jo.*, ifnull(jofavrank.FavoriteCount,0) as FavCount from "
                + "(select * from Journal where " + dstatuscond
                + " and CreatedDate between date_sub(now(), interval 7 day) and now()) as jo left join "
                + "(select TargetId, count(*) as FavoriteCount from Favorite where TargetType like 'journal' group by TargetId) as jofavrank "
                + "on jo.id = jofavrank.TargetId " + "order by FavCount desc " + "limit " + amount;
        SQLQuery query = session.createSQLQuery(sql);
        query.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE);
        List<Map<String, Object>> list = query.list();
        return list;
    }

    @Transactional
    public List<Map<String, Object>> getMostFavJournalsIn7DaysExcept(int amount, int filter, int exceptJourId) {
        Session session = sessionFactory.getCurrentSession();
        String dstatuscond = "";
        if (filter == JournalDAO.FILTER_FRIENDS)
            dstatuscond = "(DataStatus = 1 or DataStatus = 2)";
        else if (filter == JournalDAO.FILTER_PUBLIC)
            dstatuscond = "DataStatus = 1";
        else if (filter == JournalDAO.FILTER_PRIVATE)
            dstatuscond = "DataStatus > 0";
        else
            return new ArrayList<Map<String, Object>>();
        String sql = "select jo.*, ifnull(jofavrank.FavoriteCount,0) as FavCount from "
                + "(select * from Journal where " + dstatuscond + " and Id != " + exceptJourId
                + " and CreatedDate between date_sub(now(), interval 7 day) and now()) as jo left join "
                + "(select TargetId, count(*) as FavoriteCount from Favorite where TargetType like 'journal' group by TargetId) as jofavrank "
                + "on jo.id = jofavrank.TargetId " + "order by FavCount desc " + "limit " + amount;
        SQLQuery query = session.createSQLQuery(sql);
        query.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE);
        List<Map<String, Object>> list = query.list();
        return list;
    }
}
