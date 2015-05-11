<%@ taglib uri='tlds.ascertain' prefix='asc' %>
<%@ taglib uri='tlds.struts-html' prefix='html' %>
<%@ taglib uri='tlds.struts-bean' prefix='bean' %>
<%@ taglib uri='tlds.c' prefix='c' %>

<%-- Create the required JavaScript arrays --%>
<script type="text/javascript">
<!--
   //Create the linked filter JavaScript
    var filterParents = new Array(); // array of parents in ddLinkObj form
    var filterInitialValues = new Array(); // array of initial values for all drop downs
    var filterChildren = new Array(); // array of parent to child mappings
    <c:set var="filterCounter" value="0"/>
    <c:forEach items="${IMM__ISSUE_MANAGEMENT_FILTER_ROWS}" var="filterRow">
        <c:set var="filter" value="${filterRow.col1}" scope="request"/>
        <c:if test="${filter != null && (filter.typeDescription == 'DROPDOWN' || filter.typeDescription == 'MULTISELECT')}">
            var value = '${filter.value}';
            if(value == '') value = 0
            filterInitialValues["dropDownFilterValue(${filter.columnId})"] = value;
            filterChildren["dropDownFilterValue(${filter.columnId})"] = ${filter.childAttributeId};
            var ddLinkObj_${filter.id} = new ddLinkObj(${filter.id}, '');
            ddLinkObj_${filter.id}.setChildArray(filterChildren);
            ddLinkObj_${filter.id}.setInitialValues(filterInitialValues);
            <%-- Setup top link DDL --%>
            <c:if test="${filter.childAttributeId != 0 && filter.linkField == null}">                  
                filterParents[${filterCounter}] = ddLinkObj_${filter.id};
                <c:set var="filterCounter" value="${filterCounter + 1}"/>
            </c:if>
        </c:if>
        
        <c:set var="filter" value="${filterRow.col2}" scope="request"/>
        <c:if test="${filter != null && (filter.typeDescription == 'DROPDOWN' || filter.typeDescription == 'MULTISELECT')}">
            var value = '${filter.value}';
            if(value == '') value = 0
            filterInitialValues["dropDownFilterValue(${filter.columnId})"] = value;
            filterChildren["dropDownFilterValue(${filter.columnId})"] = ${filter.childAttributeId};
            var ddLinkObj_${filter.id} = new ddLinkObj(${filter.id}, '');
            ddLinkObj_${filter.id}.setChildArray(filterChildren);
            ddLinkObj_${filter.id}.setInitialValues(filterInitialValues);
            <%-- Setup top link DDL --%>
            <c:if test="${filter.childAttributeId != 0 && filter.linkField == null}">                  
                filterParents[${filterCounter}] = ddLinkObj_${filter.id};
                <c:set var="filterCounter" value="${filterCounter + 1}"/>
            </c:if>
        </c:if>
    </c:forEach>
//-->
</script>

<asc:showHideBlock description="filters" cookieId="uk.co.cartesian.ascertain.imm.web.action.IssueManagement_filter">
    <%-- Add the hidden filters --%>
    <c:forEach var="filter" items="${IMM__ISSUE_MANAGEMENT_HIDDEN_FILTERS}">
        <html:hidden property="freeTextFilterValue(${filter.columnId})"/>
    </c:forEach>

    <%-- Add the visible filters --%>
    <table width="100%">
        <c:forEach var="filterRow" items="${IMM__ISSUE_MANAGEMENT_FILTER_ROWS}">
            <tr>
                <%-- does col-1 filter span columns --%>
                <td colspan="${filterRow.col1.spanColumns ? 2 : 1}">
                    <%-- Do first column --%>
                    <c:set var="filter" value="${filterRow.col1}" scope="request"/>
                    <jsp:include page="/jsp/imm/IssueManagementFilterRow.jsp"></jsp:include>
                </td>
                <td>
                    <%-- Do second column --%>
                    <c:set var="filter" value="${filterRow.col2}" scope="request"/>
                    <jsp:include page="/jsp/imm/IssueManagementFilterRow.jsp"></jsp:include>
                </td>   
            </tr>
        </c:forEach>

        <%-- Add the tag filter --%>
        <tr>
            <td>
                <table cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="filter_label" nowrap>
                            <asc:message key="imm.label.issue.tag"/>
                        </td>
                        <td class="filter_value">
                            <html:select property="tagId" styleClass="drop-down">
                                <html:options name="TAG_REF_DROPDOWN" property="ids" labelName="TAG_REF_DROPDOWN" labelProperty="labels"/>
                            </html:select>
                        </td>
                    </tr>
                </table>
            </td>   
            <td></td>   
        </tr>

        <tr>
            <td>
                <table cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="filter_label">
                            &nbsp;
                        </td>
                        <td class="filter_value">
                            <html:submit property="method" styleClass="buttonFixedSize">
                                <bean:message key="imm.button.apply"/>
                            </html:submit>
                            <html:reset styleClass="buttonFixedSize">
                                <bean:message key="imm.button.reset"/>
                            </html:reset>
                            <html:submit property="method" styleClass="buttonFixedSize">
                                <bean:message key="imm.button.clear"/>
                            </html:submit>
                        </td>
                    </tr>
                </table>
            </td>
            <td>
                &nbsp;
            </td>
        </tr>
    </table>
</asc:showHideBlock>

<%-- Add block and date filter init stuff --%>
<asc:showHideInit description="filters" cookieId="uk.co.cartesian.ascertain.imm.web.action.IssueManagement_filter"/>

<asc:separator/>

<script type="text/javascript">
<!--
   initLinkDDL(filterParents); // initialise the child values
//-->
</script>
