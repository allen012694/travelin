package fu.cap.travelin.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.transaction.annotation.Transactional;

import fu.cap.travelin.model.Area;

public class AreaDAO {
    private SessionFactory sessionFactory;

    public AreaDAO(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public AreaDAO() {
    }

    @Transactional
    public List<Area> getAllAvailable() {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Area.class);
        criteria.add(Restrictions.eq("datastatus", 1));
        List<Area> list = criteria.list();

        return list;
    }

    @Transactional
    public List<Area> getAllAvailableCities() {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Area.class);
        criteria.add(Restrictions.eq("datastatus", 1));
        criteria.add(Restrictions.isNull("parentarea.id"));
        List<Area> list = criteria.list();

        return list;
    }

    @Transactional
    public List<Area> getAll() {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Area.class);
        List<Area> list = criteria.list();

        return list;
    }

    @Transactional
    public Area getAreaById(int id) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Area.class);
        criteria.add(Restrictions.idEq(id));
        List<Area> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public void updateArea(Area newArea) {
        Session session = sessionFactory.openSession();
        Area current = session.load(Area.class, newArea.getId());
        session.beginTransaction();
        session.update(newArea);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void insertArea(Area area) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        session.save(area);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public List<Area> getAllByPage(Integer page, Integer steps) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Area.class);
        criteria.setFirstResult((page - 1) * steps);
        criteria.setMaxResults(steps);
        List<Area> list = criteria.list();

        return list;
    }

    @Transactional
    public Long countAvailable() {
        return (Long) sessionFactory.getCurrentSession().createCriteria(Area.class)
                .add(Restrictions.eq("datastatus", 1)).setProjection(Projections.rowCount()).uniqueResult();
    }

    @Transactional
    public Long countAll() {
        return (Long) sessionFactory.getCurrentSession().createCriteria(Area.class)
                .setProjection(Projections.rowCount()).uniqueResult();
    }
}
