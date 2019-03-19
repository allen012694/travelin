package fu.cap.travelin.dao;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Property;
import org.hibernate.criterion.Restrictions;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.SessionAttributes;

import fu.cap.travelin.model.Account;
import fu.cap.travelin.model.Journal;
import fu.cap.travelin.model.Notification;
import fu.cap.travelin.model.NotificationObject;

@SessionAttributes({ "currentAccount" })
public class NotificationDAO {
    private SessionFactory sessionFactory;

    // Dummy currentAccount
    @ModelAttribute("currentAccount")
    public Account populateAccount() {
        return new Account(); // populates account for the first time if null
    }

    public NotificationDAO(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public NotificationDAO() {
    }

    @Transactional
    public List<Notification> getNotificationsForAccount(int accid) {
        List<NotificationObject> nObjs = getNotificationObjectsByAccount(accid);
        if (nObjs == null || nObjs.size() == 0)
            return null;
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Notification.class);
        // criteria.add(Restrictions.like("account.id", accid));
        criteria.add(Property.forName("object").in(nObjs));
        criteria.add(Restrictions.eq("status", 1));
        List<Notification> list = criteria.list();
        return list;
    }

    @Transactional
    public List<NotificationObject> getNotificationObjectsByAccount(int accid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(NotificationObject.class);
        criteria.add(Restrictions.like("account.id", accid));
        List<NotificationObject> list = criteria.list();
        return list;
    }

    @Transactional
    public void updateSeenNotification(int notiId) {
        Session session = sessionFactory.openSession();
        Notification noti = session.load(Notification.class, notiId);
        noti.setStatus(0);
        session.beginTransaction();
        session.update(noti);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void insertNotification(Notification noti) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        session.save(noti);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void insertNotifications(List<Notification> notis) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        for (Notification noti : notis) {
            session.save(noti);
        }
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void notifyToFriendsAboutJournal(List<Account> friends, Journal journal) {
        // Get Notification Object Journal
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(NotificationObject.class);
        criteria.add(Property.forName("account").in(friends));
        criteria.add(Restrictions.like("objecttype", "journal"));
        List<NotificationObject> notiObjs = criteria.list();

        // Create list of Notification and insert to DB
        if (notiObjs != null && notiObjs.size() > 0) {
            List<Notification> notis = new ArrayList<Notification>();
            for (NotificationObject notiObj : notiObjs) {
                notis.add(new Notification(notiObj, "share", journal.getAuthor(), 1, journal.getId()));
            }
            insertNotifications(notis);
        }
    }

    @Transactional
    public void insertNotificationObjects(List<NotificationObject> notiObjs) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        for (NotificationObject notiObj : notiObjs) {
            session.save(notiObj);
        }
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public NotificationObject getNotiObjByTypeAndAccount(String type, int accountId) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(NotificationObject.class);
        criteria.add(Restrictions.like("account.id", accountId));
        criteria.add(Restrictions.like("objecttype", type));
        List<NotificationObject> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public Notification getNotificationById(int nId) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Notification.class);
        criteria.add(Restrictions.idEq(nId));
        List<Notification> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }
}
