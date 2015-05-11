<%@ taglib uri='tlds.c' prefix='c' %>
<%@ taglib uri='tlds.fn' prefix='fn' %>
<%@ taglib uri='tlds.ascertain' prefix='asc' %>

<%-- set up page level attributes using the tag --%>
<asc:breadcrumbShow/>
<%-- display crumbs --%><%-- strip spaces
 --%><c:if test="${fn:length(pageScope.BREAD_CRUMB_LIST) > 0}"><%--
     --%><ul id="breadcrumbs" style="overflow: hidden;"><%--
         --%><c:forEach var="crumb" items="${BREAD_CRUMB_LIST}"><%--
             --%><li><a href="${crumb.url}" title="${crumb.fullTitle}">${crumb.title}</a></li><%--
         --%></c:forEach><%--
    --%></ul>
</c:if>
