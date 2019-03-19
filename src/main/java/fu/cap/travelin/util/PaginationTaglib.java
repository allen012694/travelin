package fu.cap.travelin.util;

import java.io.Writer;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.SimpleTagSupport;

public class PaginationTaglib extends SimpleTagSupport {
    private String uri;
    private int page;
    private int count;
    private int max;
    private int steps;
    private String first;
    private String last;
    private String previous;
    private String next;

    private Writer getWriter() {
        JspWriter out = getJspContext().getOut();
        return out;
    }

    @Override
    public void doTag() throws JspException {
        Writer out = getWriter();
        // System.out.println(page);
        try {
            out.write("<nav>");
            out.write("<ul class=\"pagination\">");

            if (page == 1) {
                out.write(constructLink(1, first, "disabled", true));
                out.write(constructLink(1, previous, "disabled", true));
            } else {
                out.write(constructLink(1, first, null, false));
                out.write(constructLink(page - 1, previous, null, false));
            }
            for (int itr = 0; itr < count; itr += steps) {
                if (page == itr / steps + 1) {
                    out.write(constructLink(page, String.valueOf(itr / steps + 1), "active", true));
                } else if (((page - 1) * steps - 5 * steps) <= itr && ((page - 1) * steps + 5 * steps) >= itr) {
                    out.write(constructLink(itr / steps + 1, String.valueOf(itr / steps + 1), null, false));
                }
            }

            if ((page - 1) * steps + steps >= count) {
                out.write(constructLink(page + 1, next, "disabled", true));
                out.write(constructLink((count / steps) + 1, last, "disabled", true));
            } else {
                out.write(constructLink(page + 1, next, null, false));
                out.write(constructLink((count / steps) + 1, last, null, false));
            }

            out.write("</ul>");
            out.write("</nav>");
        } catch (java.io.IOException ex) {
            throw new JspException("Error in Paginator tag", ex);
        }
    }

    private String constructLink(int page, String text, String className, boolean disabled) {
        StringBuilder link = new StringBuilder("<li");
        if (className != null) {
            link.append(" class=\"");
            link.append(className);
            link.append("\"");
        }
        if (disabled)
            link.append(">").append("<a href=\"#\">" + text + "</a></li>");
        else
            link.append(">").append("<a href=\"" + uri + "page=" + page + "\">" + text + "</a></li>");
        return link.toString();
    }

    public String getUri() {
        return uri;
    }

    public void setUri(String uri) {
        this.uri = uri;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public int getMax() {
        return max;
    }

    public void setMax(int max) {
        this.max = max;
    }

    public String getPrevious() {
        return previous;
    }

    public void setPrevious(String previous) {
        this.previous = previous;
    }

    public String getNext() {
        return next;
    }

    public void setNext(String next) {
        this.next = next;
    }

    public int getSteps() {
        return steps;
    }

    public void setSteps(int steps) {
        this.steps = steps;
    }

    public String getfirst() {
        return first;
    }

    public void setfirst(String first) {
        this.first = first;
    }

    public String getlast() {
        return last;
    }

    public void setlast(String last) {
        this.last = last;
    }
}