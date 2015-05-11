<%@ taglib uri='tlds.ascertain' prefix='asc' %>
<%@ taglib prefix="tiles" uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="bean" uri="http://struts.apache.org/tags-bean" %>
<%@ taglib prefix="logic" uri="http://struts.apache.org/tags-logic" %>
<%@ page import="uk.co.cartesian.ascertain.dgf.web.helper.DGFConstants"%>

<%
	String graphName = request.getParameter("webGraphName");
	if (graphName == null)
	{
		graphName = DGFConstants.DGF_GRAPH_NAME;
	}

	//The browser tries to cache the image so create a unique id to prevent this
	pageContext.setAttribute("UID", "" + System.currentTimeMillis());
%>


<jsp:include page="/servlet/GraphServlet">
  <jsp:param name="GRAPH_ATTR" value="<%=graphName%>"/>
  <jsp:param name="map" value="1" />
</jsp:include>

<META HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE"/>
<META HTTP-EQUIV="EXPIRES" CONTENT="-1"/>

<asc:showHideBlock description="Network" cookieId="MrecNetworkChart">
<center bgcolor="#FFFFFF">
	<img border=0 src="/servlet/GraphServlet?GRAPH_ATTR=<%=graphName%>&uid=${UID}" USEMAP="#<%=graphName%>"/>
</center>
</asc:showHideBlock>


<asc:separator/>





<asc:block>
	<bean:define id="status" name="UM__MREC_VERSION_BEAN" property="status"/>
	<bean:define id="view" value="${status != 'N'}"></bean:define>
	<table width="100%">
		<tr>
			<td valign="top" width="50%">
				<strong><bean:write name="mrecTpmDform" property="iSideTitle" /></strong>
				<tiles:insert page="/jsp/web/tpm/TPM.jsp" flush="true">
					<tiles:put name="key" value="uk.co.cartesian.ascertain.um.web.action.mrec.MrecMetric.LEFT" />
				</tiles:insert>
			</td>
			<td valign="top" width="50%">
				<strong><bean:write name="mrecTpmDform" property="jSideTitle" /></strong>
				<tiles:insert page="/jsp/web/tpm/TPM.jsp" flush="true">
					<tiles:put name="key" value="uk.co.cartesian.ascertain.um.web.action.mrec.MrecMetric.RIGHT" />
				</tiles:insert>
			</td>
		</tr>
	</table>
</asc:block>
<asc:showHideInit description="Network" cookieId="MrecNetworkChart"/>
