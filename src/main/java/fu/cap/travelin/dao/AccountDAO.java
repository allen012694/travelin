package fu.cap.travelin.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.transaction.annotation.Transactional;

import fu.cap.travelin.model.Account;
import fu.cap.travelin.model.Subscriber;

public class AccountDAO {
    private SessionFactory sessionFactory;

    public AccountDAO(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public AccountDAO() {
    }

    @Transactional
    public Account checkLogin(String email, String password) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Account.class);
        criteria.add(Restrictions.like("email", email));
        criteria.add(Restrictions.like("password", password));
        // criteria.add(Restrictions.like("datastatus", 1));
        List<Account> rs = criteria.list();
        // if (!rs.isEmpty()) return 1;
        // return -1;
        if (!rs.isEmpty())
            return rs.get(0);
        return null;
    }

    @Transactional
    public void insertAccount(Account account) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        session.save(account);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public Account getAccountByEmail(String email) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Account.class);
        criteria.add(Restrictions.like("email", email));
        List<Account> list = criteria.list();

        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public Account getAccountByUsername(String username) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Account.class);
        criteria.add(Restrictions.like("username", username));
        List<Account> list = criteria.list();

        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public void updateAccount(Account newAccount) {
        Session session = sessionFactory.openSession();
        Account current = session.load(Account.class, newAccount.getId());
        session.beginTransaction();
        session.update(newAccount);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public List<Account> getAllAccount() {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Account.class);
        List<Account> list = criteria.list();

        return list;
    }

    @Transactional
    public Account getAccountById(int id) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Account.class);
        criteria.add(Restrictions.idEq(id));
        List<Account> list = criteria.list();

        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public Long countAvailable() {
        return (Long) sessionFactory.getCurrentSession().createCriteria(Account.class)
                .add(Restrictions.eq("datastatus", 1)).setProjection(Projections.rowCount()).uniqueResult();
    }

    @Transactional
    public Long countAll() {
        return (Long) sessionFactory.getCurrentSession().createCriteria(Account.class)
                .setProjection(Projections.rowCount()).uniqueResult();
    }

    @Transactional
    public List<Account> getAllByPage(Integer page, Integer steps) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Account.class);
        criteria.setFirstResult((page - 1) * steps);
        criteria.setMaxResults(steps);
        List<Account> list = criteria.list();

        return list;
    }

    @Transactional
    public List<Account> getTopSearchAccountResult(String searchText, int amount) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Account.class);
        criteria.add(Restrictions.like("username", "%" + searchText + "%").ignoreCase());
        criteria.setMaxResults(amount);
        List<Account> list = criteria.list();
        return list;
        // SELECT * FROM Account WHERE Title like '%searchText%'
    }

    /*********************** Subscribe *************************/
    @Transactional
    public int insertSubscriber(Subscriber subscriber) {
        try {
            Session session = sessionFactory.openSession();
            session.beginTransaction();
            session.save(subscriber);
            session.getTransaction().commit();
            session.close();
        } catch (Exception e) {
            // TODO: handle exception
            return 2;
        }
        return 1;
    }

}
