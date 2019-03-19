package fu.cap.travelin.dao;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;
import org.springframework.transaction.annotation.Transactional;

import fu.cap.travelin.model.Account;
import fu.cap.travelin.model.Relationship;

public class RelationshipDAO {
    private SessionFactory sessionFactory;

    public RelationshipDAO(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public RelationshipDAO() {
    }

    @Transactional
    public void createFriendRequest(Relationship friend) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        session.save(friend);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public Relationship getRelationshipByAccountIds(int accid1, int accid2) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Relationship.class);
        criteria.add(Restrictions.or(Restrictions.eq("accountfirst.id", accid1),
                Restrictions.eq("accountfirst.id", accid2)));
        criteria.add(Restrictions.or(Restrictions.eq("accountsecond.id", accid1),
                Restrictions.eq("accountsecond.id", accid2)));
        List<Relationship> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public Relationship getRelationshipById(int fid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Relationship.class);
        criteria.add(Restrictions.idEq(fid));
        List<Relationship> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public void updateRelationship(Relationship fs) {
        Session session = sessionFactory.openSession();
        Relationship current = session.load(Relationship.class, fs.getId());
        session.beginTransaction();
        session.update(fs);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void acceptRelationship(int rsid) {
        Session session = sessionFactory.openSession();
        Relationship current = session.load(Relationship.class, rsid);
        current.setStatus(1);
        session.beginTransaction();
        session.update(current);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void deleteRelationship(Relationship fs) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        session.delete(fs);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public List<Relationship> getNotRespondedFriendRequestsByReceiverId(int acctwoid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Relationship.class);
        criteria.add(Restrictions.eq("accountsecond.id", acctwoid));
        criteria.add(Restrictions.eq("status", 0));
        List<Relationship> list = criteria.list();
        return list;
    }

    @Transactional
    public List<Relationship> getByFirstAccountId(int accid1) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Relationship.class);
        criteria.add(Restrictions.eq("accountfirst.id", accid1));
        criteria.add(Restrictions.eq("status", 1));
        List<Relationship> list = criteria.list();
        return list;
    }

    @Transactional
    public List<Relationship> getBySecondAccountId(int accid2) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Relationship.class);
        criteria.add(Restrictions.eq("accountsecond.id", accid2));
        criteria.add(Restrictions.eq("status", 1));
        List<Relationship> list = criteria.list();
        return list;
    }

    @Transactional
    public List<Account> getFriendsOf(Account account) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Relationship.class);
        criteria.add(
                Restrictions.or(Restrictions.eq("accountsecond", account), Restrictions.eq("accountfirst", account)));
        criteria.add(Restrictions.eq("status", 1));
        List<Relationship> list = criteria.list();
        List<Account> friends = new ArrayList<Account>();
        if (list != null && list.size() > 0) {
            for (Relationship rls : list) {
                if (rls.getAccountfirst().getId().intValue() == account.getId().intValue()) {
                    friends.add(rls.getAccountsecond());
                } else if (rls.getAccountsecond().getId().intValue() == account.getId().intValue()) {
                    friends.add(rls.getAccountfirst());
                } else {
                    // do nothing;
                }
            }
        }
        return friends;
    }
}
