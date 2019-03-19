package fu.cap.travelin.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.transaction.annotation.Transactional;

import fu.cap.travelin.model.ArticleTag;
import fu.cap.travelin.model.JournalTag;
import fu.cap.travelin.model.PlaceTag;
import fu.cap.travelin.model.Tag;

public class TagDAO {
    private SessionFactory sessionFactory;

    public TagDAO(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public TagDAO() {
    }

    @Transactional
    public List<Tag> getAll() {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Tag.class);
        List<Tag> list = criteria.list();

        return list;
    }

    @Transactional
    public Tag getTagById(int id) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Tag.class);
        criteria.add(Restrictions.idEq(id));
        List<Tag> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public void updateTag(Tag newTag) {
        Session session = sessionFactory.openSession();
        Tag current = session.load(Tag.class, newTag.getId());
        session.beginTransaction();
        session.update(newTag);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void insertTag(Tag tag) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        session.save(tag);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public void findOrInsertTag(Tag tag) {
        Tag t = this.getTagByName(tag.getName());
        if (t != null) {
            tag.setId(t.getId());
            return;
        }
        this.insertTag(tag);
    }

    @Transactional
    public Tag getTagByName(String tName) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Tag.class);
        criteria.add(Restrictions.like("name", tName));
        List<Tag> list = criteria.list();
        if (!list.isEmpty())
            return list.get(0);
        return null;
    }

    @Transactional
    public void deleteTag(Tag tag) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        session.delete(tag);
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public List<Tag> getSearchTagResult(String searchText) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Tag.class);
        criteria.add(Restrictions.like("title", "%" + searchText + "%").ignoreCase());
        List<Tag> list = criteria.list();
        return list;
        // SELECT * FROM Article WHERE Title like '%searchText%'
    }

    @Transactional
    public List<Tag> getTopSearchTags(int amount) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(Tag.class);
        // criteria.add(Restrictions.eq())
        criteria.addOrder(Order.desc("searchcount"));
        criteria.setMaxResults(amount);
        List<Tag> list = criteria.list();
        return list;
    }

    /*********************** Article Tag zone **************************/
    @Transactional
    public void insertArticleTags(List<ArticleTag> arttags) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        for (ArticleTag arttag : arttags) {
            session.save(arttag);
        }
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public List<ArticleTag> getArticleTags(int articleId) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(ArticleTag.class);
        criteria.add(Restrictions.eq("article.id", articleId));
        List<ArticleTag> list = criteria.list();
        return list;
    }

    @Transactional
    public void cleanArticleTags(int articleId) {
        Session session = sessionFactory.getCurrentSession();
        Query query = session.createQuery("delete ArticleTag where ArticleId = :articleid");
        query.setParameter("articleid", articleId);

        int rs = query.executeUpdate();
    }

    @Transactional
    public List<ArticleTag> getArticleByTag(int tagId) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(ArticleTag.class);
        criteria.add(Restrictions.eq("tag.id", tagId));
        List<ArticleTag> list = criteria.list();
        return list;

    }

    /************************* Place Tag zone **************************/
    @Transactional
    public void insertPlaceTags(List<PlaceTag> placetags) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        for (PlaceTag placetag : placetags) {
            session.save(placetag);
        }
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public List<PlaceTag> getPlaceTags(int placeId) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(PlaceTag.class);
        criteria.add(Restrictions.eq("place.id", placeId));
        List<PlaceTag> list = criteria.list();
        return list;
    }

    @Transactional
    public void cleanPlaceTags(int placeId) {
        Session session = sessionFactory.getCurrentSession();
        Query query = session.createQuery("delete PlaceTag where PlaceId = :placeid");
        query.setParameter("placeid", placeId);

        int rs = query.executeUpdate();
    }

    @Transactional
    public List<PlaceTag> getPlaceByTag(int tagId) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(PlaceTag.class);
        criteria.add(Restrictions.eq("tag.id", tagId));
        List<PlaceTag> list = criteria.list();
        return list;

    }

    /*********************** Journal Tag zone **************************/
    @Transactional
    public void insertJournalTags(List<JournalTag> journaltags) {
        Session session = sessionFactory.openSession();
        session.beginTransaction();
        for (JournalTag journaltag : journaltags) {
            session.save(journaltag);
        }
        session.getTransaction().commit();
        session.close();
    }

    @Transactional
    public List<JournalTag> getJournalTags(int journalId) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(JournalTag.class);
        criteria.add(Restrictions.eq("journal.id", journalId));
        List<JournalTag> list = criteria.list();
        return list;
    }

    @Transactional
    public void cleanJournalTags(int journalId) {
        Session session = sessionFactory.getCurrentSession();
        Query query = session.createQuery("delete JournalTag where JournalId = :journalid");
        query.setParameter("journalid", journalId);

        int rs = query.executeUpdate();
    }

    @Transactional
    public List<JournalTag> getJournalByTag(int tagId) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(JournalTag.class);
        criteria.add(Restrictions.eq("tag.id", tagId));
        List<JournalTag> list = criteria.list();
        return list;
    }
}
