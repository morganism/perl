<%@ taglib uri='tlds.ascertain' prefix='asc' %>
<%@ taglib uri='tlds.struts-html' prefix='html' %>
<%@ taglib uri='tlds.struts-bean' prefix='bean' %>
<%@ taglib uri='tlds.struts-tiles' prefix='tiles' %>
<%@ taglib uri='tlds.c' prefix='c' %>


<c:set var="FILTER_TYPE" value="${filter.typeDescription}"/>
<c:set var="DISABLED" value="false"/>

<c:if test="${filter.error == 'true'}">
    <c:set var="DISABLED" value="true"/>
</c:if>    
<table cellspacing="0" cellpadding="0">
    <tr>
		<td class="filter_label" nowrap>
            <c:out value="${filter.label}"/>
		</td>
		<td class="filter_value">
		    <c:choose>
                <c:when test="${FILTER_TYPE == 'DROPDOWN'}">
                    <c:set var="ddValues" value="${filter.options}"/>
                    <c:if test="${filter.columnId == 'COL_3007'}">
                        <asc:notPrivileged id="3001">
                            <c:set var="DISABLED" value="true"/>
                        </asc:notPrivileged>
                    </c:if>    
                    <c:if test="${filter.childAttributeId != 0}">
                        <c:set var="ONCHANGE" value="ddLinkObj_${filter.id}.update(this, ${filter.childAttributeId});"/>
                    </c:if>
                    <html:select property="dropDownFilterValue(${filter.columnId})" styleId="dropDownFilterValue(${filter.columnId})" styleClass="drop-down" onchange="${ONCHANGE}" disabled="${DISABLED}">
                        <html:options collection="ddValues" property="value" labelProperty="label"/>
                    </html:select>
                </c:when>
                <c:when test="${FILTER_TYPE == 'MULTISELECT'}">
                    <c:set var="ddValues" value="${filter.options}"/>
                    <c:if test="${filter.columnId == 'COL_3007'}">
                        <asc:notPrivileged id="3001">
                            <c:set var="DISABLED" value="true"/>
                        </asc:notPrivileged>
                    </c:if>    
                    <c:if test="${filter.childAttributeId != 0}">
                        <c:set var="ONCHANGE" value="ddLinkObj_${filter.id}.update(this, ${filter.childAttributeId});"/>
                    </c:if>
                    <html:select property="multiSelectFilterValue(${filter.columnId})" styleId="multiSelectFilterValue(${filter.columnId})" styleClass="drop-down" onchange="${ONCHANGE}" disabled="${DISABLED}" multiple="true">
                        <html:options collection="ddValues" property="value" labelProperty="label"/>
                    </html:select>
                </c:when>
		        <c:when test="${FILTER_TYPE == 'DATE'}">
		            <tiles:insert page="/jsp/web/DateTimeWidget.jsp">
		                <tiles:put name="property" value="dateFilterValue(${filter.columnId})"/>
		            </tiles:insert>
		        </c:when>
		        <c:when test="${FILTER_TYPE == 'DATERANGE'}">
		            <table cellpadding="0" cellspacing="0">
		                <tr>
		                    <td>
		                        <tiles:insert page="/jsp/web/DateTimeWidget.jsp">
		                            <tiles:put name="property" value="dateRangeFilterValue(${filter.columnId}_from)"/>
		                        </tiles:insert>
		                    </td>
		                    <td>
		                        &nbsp;&nbsp;&nbsp;<b>to</b>&nbsp;&nbsp;&nbsp;
		                    </td>
		                    <td>
		                        <tiles:insert page="/jsp/web/DateTimeWidget.jsp">
		                            <tiles:put name="property" value="dateRangeFilterValue(${filter.columnId}_to)"/>
		                        </tiles:insert>
		                    </td>
		                </tr>
		            </table>
		        </c:when>
		        <c:when test="${FILTER_TYPE == 'DATETIME'}">
		            <table cellpadding="0" cellspacing="0">
		                <tr>
		                    <td>
		                        <tiles:insert page="/jsp/web/DateTimeWidget.jsp">
		                            <tiles:put name="property" value="dateTimeFilterValue(${filter.columnId})"/>
                                    <tiles:put name="type" value="datetime"/>
		                        </tiles:insert>
		                    </td>
		                </tr>
		            </table>
		        </c:when>
		        <c:when test="${FILTER_TYPE == 'FREETEXT'}">
		            <html:text property="freeTextFilterValue(${filter.columnId})" styleClass="text-field" disabled="${DISABLED}"/>
		        </c:when>
		        <c:when test="${FILTER_TYPE == 'FREETEXT_REG'}">
		            <html:text property="freeTextRegExpFilterValue(${filter.columnId})" styleId="${filter.columnId}" styleClass="text-field" onfocus="handleFreeTextRegExpFocus(this, '${filter.defaultText}');" onblur="handleFreeTextRegExpBlur(this, '${filter.defaultText}');"/>
		            <script>
		                setFreeTextRegExpStyle('${filter.columnId}', '${filter.defaultText}');
		            </script>
		        </c:when>
		    </c:choose>
		</td>
    </tr>
</table>
