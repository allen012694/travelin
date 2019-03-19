package fu.cap.travelin.dao;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Property;
import org.hibernate.criterion.Restrictions;
import org.springframework.transaction.annotation.Transactional;

import fu.cap.travelin.model.Account;
import fu.cap.travelin.model.Conversation;
import fu.cap.travelin.model.Message;

public class MessageDAO {
    private SessionFactory sessionFactory;

    public MessageDAO(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public MessageDAO() {
    }

    @Transactional
    public List<Conversation> getAvailableConversationsForAccount(int accountid) {

        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Conversation.class);
        /*
         * criteria.add(Restrictions.or(Restrictions.like(
         * "accountfirst.username", "%" + searchText + "%").ignoreCase(),
         * Restrictions.like("accountsecond.username", "%" + searchText +
         * "%").ignoreCase()));
         */
        criteria.add(Restrictions.or(
                Restrictions.and(Restrictions.eq("accountfirst.id", accountid),
                        Restrictions.or(Restrictions.eq("datastatus", 2), Restrictions.eq("datastatus", 3))),
                Restrictions.and(Restrictions.eq("accountsecond.id", accountid),
                        Restrictions.or(Restrictions.eq("datastatus", 1), Restrictions.eq("datastatus", 3)))));
        criteria.addOrder(Order.desc("updateddate"));
        List<Conversation> list = criteria.list();
        return list;
    }

    @Transactional
    public List<Conversation> getAvailableConversationsForAccountBySearch(int accountid, List<Integer> searchIdList) {

        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Conversation.class);

        criteria.add(Restrictions.or(Restrictions.in("accountfirst.id", searchIdList),
                Restrictions.in("accountsecond.id", searchIdList)));

        criteria.add(Restrictions.or(
                Restrictions.and(Restrictions.eq("accountfirst.id", accountid),
                        Restrictions.or(Restrictions.eq("datastatus", 2), Restrictions.eq("datastatus", 3))),
                Restrictions.and(Restrictions.eq("accountsecond.id", accountid),
                        Restrictions.or(Restrictions.eq("datastatus", 1), Restrictions.eq("datastatus", 3)))));
        criteria.addOrder(Order.desc("updateddate"));
        List<Conversation> list = criteria.list();
        return list;
    }

    @Transactional
    public Message getMessageById(int id) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Message.class);
        criteria.add(Restrictions.idEq(id));
        List<Message> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public void updateMessage(Message newMessage) {
        Session session = sessionFactory.openSession();
        Message current = session.load(Message.class, newMessage.getId());
        session.beginTransaction();
        session.update(newMessage);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void insertMessage(Message message) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        session.save(message);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public Conversation getPrivateConversation(int accountid1, int accountid2) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Conversation.class);
        criteria.add(Restrictions.or(Restrictions.eq("accountfirst.id", accountid1),
                Restrictions.eq("accountsecond.id", accountid1)));
        criteria.add(Restrictions.or(Restrictions.eq("accountfirst.id", accountid2),
                Restrictions.eq("accountsecond.id", accountid2)));
        // criteria.add(Restrictions.gt("datastatus", 0));
        criteria.addOrder(Order.desc("updateddate"));
        List<Conversation> list = criteria.list();
        if (list.size() > 0)
            return list.get(0);
        return null;
    }

    @Transactional
    public void updateConversation(Conversation conv) {
        Session session = sessionFactory.openSession();
        session.load(Message.class, conv.getId());
        session.beginTransaction();
        session.update(conv);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public List<Message> getConversationMessages(int convId) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Message.class);
        criteria.add(Restrictions.eq("conversation.id", convId));
        // criteria.add(Restrictions.eq("datastatus",3));
        criteria.addOrder(Order.desc("createddate"));
        // criteria.setMaxResults(20);
        List<Message> list = criteria.list();
        return list;
    }

    @Transactional
    public List<Message> getConversationMessagesForAccount(Conversation conversation, Account account) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Message.class);
        criteria.add(Restrictions.eq("conversation.id", conversation.getId()));
        // criteria.add(Restrictions.eq("datastatus",3));
        if (account.getId().intValue() == conversation.getAccountfirst().getId().intValue()) {
            criteria.add(Restrictions.or(Restrictions.eq("datastatus", 3), Restrictions.eq("datastatus", 2)));
        } else if (account.getId().intValue() == conversation.getAccountsecond().getId().intValue()) {
            criteria.add(Restrictions.or(Restrictions.eq("datastatus", 3), Restrictions.eq("datastatus", 1)));
        } else {
            return null;
        }
        criteria.addOrder(Order.desc("createddate"));
        // criteria.setMaxResults(20);
        List<Message> list = criteria.list();
        return list;
    }

    @Transactional
    public List<Message> getUnreadMessageByAccount(int accid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Message.class);
        // criteria.add(Restrictions.eq("conversation.id", convId));
        // criteria.add(Restrictions.eq("conversation.datastatus", 1));
        criteria.add(Restrictions.not(Restrictions.eq("fromaccount.id", accid)));
        criteria.add(Restrictions.eq("isread", false));
        // criteria.addOrder(Order.desc("conversation.updateddate"));
        criteria.addOrder(Order.desc("createddate"));
        // criteria.setMaxResults(20);
        List<Message> list = criteria.list();
        return list;
    }

    @Transactional
    public List<Message> getUnreadMessageByConversationOnAccount(int accid, int convid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Message.class);
        criteria.add(Restrictions.eq("conversation.id", convid));
        criteria.add(Restrictions.not(Restrictions.eq("fromaccount.id", accid)));
        criteria.addOrder(Order.desc("createddate"));
        List<Message> list = criteria.list();
        return list;
    }

    @Transactional
    public List<Message> getTopConversationMessages(int convid, int manytop) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Message.class);
        criteria.add(Restrictions.eq("conversation.id", convid));
        criteria.addOrder(Order.desc("createddate"));
        criteria.setMaxResults(manytop);
        List<Message> list = criteria.list();
        return list;
    }

    @Transactional
    public int checkUnreadInConversationTowardAccount(int convid, int accid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Message.class);
        criteria.add(Restrictions.eq("conversation.id", convid));
        criteria.add(Restrictions.not(Restrictions.eq("fromaccount.id", accid)));
        criteria.add(Restrictions.eq("isread", false));
        criteria.addOrder(Order.desc("createddate"));
        List<Message> list = criteria.list();
        if (list == null)
            return 0;
        return list.size();
    }

    @Transactional
    public Conversation getConversationById(int convid) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Conversation.class);
        criteria.add(Restrictions.idEq(convid));
        List<Conversation> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public void refreshConversationForAccount(int convid, int accid) {
        Session session = sessionFactory.openSession();
        Conversation target = session.load(Conversation.class, convid);
        if (target.getDatastatus() == 0) {
            if (target.getAccountfirst().getId() == accid)
                target.setDatastatus(2);
            else if (target.getAccountsecond().getId() == accid)
                target.setDatastatus(1);
        } else if (target.getDatastatus() == 1) {
            if (target.getAccountfirst().getId() == accid)
                target.setDatastatus(3);
        } else if (target.getDatastatus() == 2) {
            if (target.getAccountsecond().getId() == accid)
                target.setDatastatus(3);
        } else {
            // Do nothing
        }
        session.beginTransaction();
        session.update(target);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void insertConversation(Conversation conv) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        session.save(conv);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void seenMessageForAccount(int convid, int accid) {
        Session session = sessionFactory.openSession();
        Query query = session.createQuery(
                "update Message set isread = true where fromaccount.id != :accid and isread = false and conversation.id = :convid");
        query.setInteger("accid", accid);
        query.setInteger("convid", convid);
        query.executeUpdate();
        session.close();
    }

    @Transactional
    public List getUnseenConversationForAccount(int accountId) {
        // select count(*), conversationid from Message where isread = false &
        // fromaccountid != ? & conversationid in (?...?) group by
        // conversationid
        List<Conversation> convsAvail = getAvailableConversationsForAccount(accountId);
        if (convsAvail == null || convsAvail.size() == 0)
            return new ArrayList();
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Message.class);
        criteria.setProjection(Projections.projectionList().add(Projections.rowCount())
                .add(Projections.groupProperty("conversation")));
        criteria.add(Property.forName("conversation").in(convsAvail));
        criteria.add(Restrictions.eq("isread", false));
        criteria.add(Restrictions.not(Restrictions.eq("fromaccount.id", accountId)));
        List list = criteria.list();
        return list;
    }

    @Transactional
    public void removeConversationFromAccountHistory(Account account, Conversation conversation) {
        Session session = sessionFactory.openSession();
        Query query = session.createQuery("update Conversation set datastatus = :dstatus where id = :convid");
        Query queryMes1, queryMes2;
        query.setInteger("convid", conversation.getId());
        int dstatus = 0;
        if (conversation.getAccountfirst().getId().intValue() == account.getId().intValue()) {
            queryMes1 = session.createQuery(
                    "update Message set datastatus = 1 where conversation.id = :convid and datastatus = 3");
            queryMes2 = session.createQuery(
                    "update Message set datastatus = 0 where conversation.id = :convid and datastatus = 2");
            if (conversation.getDatastatus() == 3)
                dstatus = 1;
            else if (conversation.getDatastatus() == 2)
                dstatus = 0;
            else
                dstatus = conversation.getDatastatus();
        } else if (conversation.getAccountsecond().getId().intValue() == account.getId().intValue()) {
            queryMes1 = session.createQuery(
                    "update Message set datastatus = 2 where conversation.id = :convid and datastatus = 3");
            queryMes2 = session.createQuery(
                    "update Message set datastatus = 0 where conversation.id = :convid and datastatus = 1");
            if (conversation.getDatastatus() == 3)
                dstatus = 2;
            else if (conversation.getDatastatus() == 1)
                dstatus = 0;
            else
                dstatus = conversation.getDatastatus();
        } else {
            // do nothing
            return;
        }
        queryMes1.setInteger("convid", conversation.getId());
        queryMes2.setInteger("convid", conversation.getId());
        query.setInteger("dstatus", dstatus);

        queryMes1.executeUpdate();
        queryMes2.executeUpdate();
        query.executeUpdate();
        session.close();
    }
}
