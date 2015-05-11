<%@ taglib uri='tlds.ascertain' prefix='asc'%>
<%@ taglib uri='http://struts.apache.org/tags-tiles' prefix='tiles'%>
<%@ taglib prefix="bean" uri="http://struts.apache.org/tags-bean" %>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="logic" uri="http://struts.apache.org/tags-logic" %>
<%@ taglib prefix='c' uri="http://java.sun.com/jsp/jstl/core" %>

<tiles:importAttribute name="ROW_ID" scope="page" ignore="false"/>
<tiles:importAttribute name="CELL_DATA" scope="page" ignore="false"/>
<tiles:importAttribute name="COLUMN_DATA" scope="page" ignore="false"/>


<c:forEach var="columnData" items="${COLUMN_DATA}" varStatus="status">
	<c:if test="${columnData.id == 'mrec_definition_id'}">
			<c:set var="MREC_DEFINITION_ID" value="${CELL_DATA[status.index].value}"/>
	</c:if>
	<c:if test="${columnData.id == 'd_period_url'}">
			<c:set var="D_PERIOD" value="${CELL_DATA[status.index].value}"/>
	</c:if>
	<c:if test="${columnData.id == 'mrec_type'}">
			<c:set var="MREC_TYPE" value="${CELL_DATA[status.index].value}"/>
	</c:if>
	<c:if test="${columnData.id == 'mrec_line_type'}">
		<c:if test="${CELL_DATA[status.index].value == 'i Side' || CELL_DATA[status.index].value == 'i File Set'}">
			<c:set var="STYLE" value="background-color: #E4E1F7;"/>
		</c:if>
		<c:if test="${CELL_DATA[status.index].value == 'j Side' || CELL_DATA[status.index].value == 'j File Set'}">
			<c:set var="STYLE" value="background-color: #F7E1E6;"/>
		</c:if>
	</c:if>
	<c:if test="${columnData.id == 'issue_count'}">
		<c:if test="${! empty CELL_DATA[status.index].value}">
			<c:set var="STYLE" value="background-color: #E4F2E5;"/>
			<c:set var="ISSUE_COUNT" value="${CELL_DATA[status.index].value}"/>
			<c:if test="${CELL_DATA[status.index].value > 0}">
				<c:set var="STYLE" value="background-color: #FFFF00;"/>
			</c:if>
		</c:if>
	</c:if>
</c:forEach>

<%-- Add the cell data --%>
<c:forEach var="columnData" items="${COLUMN_DATA}" varStatus="status">
    <c:if test="${columnData.state == columnData.EXPANDED}">
        <%-- Display cell data --%>
    	<c:choose>
			<c:when test="${columnData.id == 'issue_count'}">
				<td style="${STYLE}" align="right">
					<c:if test="${! empty ISSUE_COUNT}">
						<c:if test="${ISSUE_COUNT > 0}">
							<c:if test="${MREC_TYPE == 'F'}">
								<html:link href="/imm/issueManagementSetup.do?imId=3002&filter_35004=${MREC_DEFINITION_ID}&amp;filter_35010=${mrecChartDform.map.edgeId}&amp;filter_35030=${D_PERIOD}&amp;filter_3017=0" target="drill_mrec_issues" onclick="defaultAutoResizePopUpForLink('drill_mrec_issues','950','1050');" title="View Issues">
									<c:out value="${ISSUE_COUNT}"/>
								</html:link>
							</c:if>
							<c:if test="${MREC_TYPE == 'T'}">
								<html:link href="/imm/issueManagementSetup.do?imId=3002&filter_35004=${MREC_DEFINITION_ID}&amp;filter_35030=${D_PERIOD}&amp;filter_3017=0" target="drill_mrec_issues" onclick="defaultAutoResizePopUpForLink('drill_mrec_issues','950','1050');" title="View Issues">
									<c:out value="${ISSUE_COUNT}"/>
								</html:link>
							</c:if>
						</c:if>
						<c:if test="${ISSUE_COUNT == 0}">
							<c:out value="${ISSUE_COUNT}"/>
						</c:if>
					</c:if>
				</td>
			</c:when>
    		<c:when test="${columnData.type == columnData.NUMBER_TYPE}">
                <td style="${STYLE}" align="right" valign="top">
		            <c:out value="${CELL_DATA[status.index].value}" escapeXml="false"/>
		        </td>
            </c:when>
            <c:when test="${columnData.id == 'mrec_line_type'}">
                <td style="${STYLE}" align="right" valign="top">
                <c:if test="${CELL_DATA[status.index].value == 'i Side'}">
                    <bean:write name="mrecChartDform" property="iSideTitle" />
                </c:if>
                <c:if test="${CELL_DATA[status.index].value == 'j Side'}">
                    <bean:write name="mrecChartDform" property="jSideTitle" />
                </c:if>
                </td>
            </c:when>
            <c:otherwise>
                <td style="${STYLE}" align="left" valign="top">
		            <c:out value="${CELL_DATA[status.index].value}" escapeXml="false"/>
		        </td>
            </c:otherwise>
        </c:choose>
    </c:if>
    <c:if test="${columnData.state == columnData.COLLAPSED}">
        <td width="1">
        	&nbsp;
        </td>
    </c:if> 
</c:forEach>
