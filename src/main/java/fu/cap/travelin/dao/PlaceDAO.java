package fu.cap.travelin.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Property;
import org.hibernate.criterion.Restrictions;
import org.hibernate.transform.AliasToEntityMapResultTransformer;
import org.springframework.transaction.annotation.Transactional;

import fu.cap.travelin.model.Place;

public class PlaceDAO {
    public static final int FOOD_DRINK_TYPE = 1;
    public static final int TRAVEL_TYPE = 2;
    public static final int HEALTH_RELAX_TYPE = 3;
    public static final int ENTERTAINMENT_TYPE = 4;
    public static final int SHOPPING_TYPE = 5;
    public static final int NO_EXCEPT = 0;

    private SessionFactory sessionFactory;

    public PlaceDAO(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public PlaceDAO() {
    }

    @Transactional
    public List<Place> getAll() {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Place.class);
        List<Place> list = criteria.list();

        return list;
    }

    @Transactional
    public List<Place> getAllAvailable() {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Place.class);
        criteria.add(Restrictions.not(Restrictions.eq("datastatus", -1)));
        List<Place> list = criteria.list();

        return list;
    }

    @Transactional
    public List<Place> getAvailableByPage(Integer page, Integer steps, String order, List<Integer> group, int areaId) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Place.class);
        criteria.add(Restrictions.eq("datastatus", 1));
        if (areaId != -1)
            criteria.add(Restrictions.eq("area.id", areaId));

        if (group.size() > 0) {
            criteria.add(Restrictions.in("type", group));
        }
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
        List<Place> list = criteria.list();

        return list;
    }

    // get all temp places which has connect to at least 1 created journal
    @Transactional
    public List<Place> getAllUsingTemp() {
        Session session = sessionFactory.getCurrentSession();
        String sql = "select te.Id from " + "(select * from Place where DataStatus = 0) as te " + "left join "
                + "(select PlaceId, count(*) as CountRef from JournalPlace group by PlaceId) as re "
                + "on te.Id = re.PlaceId " + "where re.CountRef >= 1 " + "order by te.CreatedDate desc";
        SQLQuery query = session.createSQLQuery(sql);
        // query.addEntity(Place.class);
        // query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
        query.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE);
        List<Map<String, Object>> tlist = query.list();
        List<Integer> ids = new ArrayList<Integer>();
        for (Map<String, Object> te : tlist) {
            ids.add((Integer) te.get("Id"));
        }
        List<Place> list;
        if (ids.size() > 0)
            list = getPlacesByIds(ids);
        else
            list = new ArrayList<Place>();
        // System.out.println(list.size());
        // System.out.println(list.get(0).getName());
        return list;
    }

    @Transactional
    public List<Place> getPlacesByIds(List<Integer> ids) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Place.class);
        criteria.add(Property.forName("id").in(ids));
        criteria.addOrder(Order.desc("createddate"));
        List<Place> list = criteria.list();
        return list;
    }

    @Transactional
    public List<Place> getAllTemp() {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Place.class);
        criteria.addOrder(Order.desc("createddate"));
        criteria.add(Restrictions.eq("datastatus", 0));
        List<Place> list = criteria.list();
        return list;
    }

    @Transactional
    public Place getPlaceById(int id) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Place.class);
        criteria.add(Restrictions.idEq(id));
        List<Place> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public void updatePlace(Place newPlace) {
        Session session = sessionFactory.openSession();
        Place current = session.load(Place.class, newPlace.getId());
        session.beginTransaction();
        session.update(newPlace);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void insertPlace(Place place) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        session.save(place);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public List<Place> getSearchPlaceResult(String searchText, int areaId) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Place.class);
        if (areaId != -1)
            criteria.add(Restrictions.eq("area.id", areaId));

        criteria.add(Restrictions.like("name", "%" + searchText + "%").ignoreCase());
        List<Place> list = criteria.list();
        return list;
        // SELECT * FROM Article WHERE Title like '%searchText%'
    }

    @Transactional
    public List<Place> getTopSearchPlaceResult(String searchText, int amount, int areaId) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Place.class);
        if (areaId != -1)
            criteria.add(Restrictions.eq("area.id", areaId));

        criteria.add(Restrictions.like("name", "%" + searchText + "%").ignoreCase());
        criteria.addOrder(Order.desc("updateddate"));

        criteria.setMaxResults(amount);
        List<Place> list = criteria.list();
        return list;
        // SELECT * FROM Article WHERE Title like '%searchText%'

    }

    @Transactional
    public List<Place> getAllByPage(Integer page, Integer steps) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Place.class);
        criteria.setFirstResult((page - 1) * steps);
        criteria.setMaxResults(steps);
        List<Place> list = criteria.list();

        return list;
    }

    @Transactional
    public Long countAvailable(int areaId) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Place.class);
        if (areaId != -1)
            criteria.add(Restrictions.eq("area.id", areaId));
        return (Long) criteria.add(Restrictions.eq("datastatus", 1)).setProjection(Projections.rowCount())
                .uniqueResult();
    }

    @Transactional
    public Long countAvailableByGroup(List<Integer> group, int areaId) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Place.class);
        if (areaId != -1)
            criteria.add(Restrictions.eq("area.id", areaId));

        return (Long) criteria.add(Restrictions.eq("datastatus", 1)).add(Restrictions.in("type", group))
                .setProjection(Projections.rowCount()).uniqueResult();
    }

    @Transactional
    public Long countAll() {
        return (Long) sessionFactory.getCurrentSession().createCriteria(Place.class)
                .setProjection(Projections.rowCount()).uniqueResult();
    }

    @Transactional
    public List<Place> getTopNewPlacesByType(int amount, int type) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Place.class);
        // criteria.setFirstResult((page - 1) * steps);
        criteria.add(Restrictions.eq("type", type));
        criteria.add(Restrictions.eq("datastatus", 1));
        criteria.addOrder(Order.desc("createddate"));
        criteria.setMaxResults(amount);
        List<Place> list = criteria.list();

        return list;
    }

    @Transactional
    public List<Place> getTopNewPlacesByTypeAndArea(int amount, int type, int areaid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Place.class);
        // criteria.setFirstResult((page - 1) * steps);
        criteria.add(Restrictions.eq("type", type));
        criteria.add(Restrictions.eq("area.id", areaid));
        criteria.add(Restrictions.eq("datastatus", 1));
        criteria.addOrder(Order.desc("createddate"));
        criteria.setMaxResults(amount);
        List<Place> list = criteria.list();

        return list;
    }

    // get places with most like or upvote
    @Transactional
    public List<Map<String, Object>> getTopRecommendedPlaces(int amount, int type, int areaid, int except) {
        Session session = sessionFactory.getCurrentSession();
        String exceptStr = (except > NO_EXCEPT) ? (" and Id != " + except) : "";
        String sql = "select pla.*, ifnull(recrank.RecommendCount,0) as RecCount from "
                + "(select * from Place where DataStatus = 1 and Type = " + type + " and AreaId = " + areaid + exceptStr
                + ") as pla " + "left join "
                + "(select PlaceId,sum(Recommend) as RecommendCount from Suggestion where DataStatus = 1 group by PlaceId) as recrank "
                + "on pla.Id = recrank.PlaceId " + "order by RecCount desc " + "limit " + amount;
        SQLQuery query = session.createSQLQuery(sql);
        query.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE);
        List<Map<String, Object>> list = query.list();
        return list;
    }

    @Transactional
    public List<Place> getTopNewPlacesByTypeAndArea(int amount, int type, int areaid, int except) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Place.class);
        criteria.add(Restrictions.eq("type", type));
        criteria.add(Restrictions.eq("area.id", areaid));
        if (except > NO_EXCEPT)
            criteria.add(Restrictions.ne("id", except));
        criteria.addOrder(Order.desc("createddate"));
        criteria.setMaxResults(amount);
        List<Place> list = criteria.list();
        return list;
    }
}
