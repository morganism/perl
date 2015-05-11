<%@ taglib prefix='asc' uri='AscertainTags' %>
<%@ taglib prefix='tiles' uri='http://struts.apache.org/tags-tiles' %>
<%@ taglib prefix='html' uri='http://struts.apache.org/tags-html' %>
<%@ taglib prefix="bean" uri="http://struts.apache.org/tags-bean" %>
<%@ taglib prefix="logic" uri="http://struts.apache.org/tags-logic" %>

<html:form action="/um/mrecDefinitionDisplay.do?action=filter">
<asc:showHideBlock description="filters" cookieId="MrecDefinitionFilters">
	<table border="0">
		<tr>
			<td class="filter_label">Name</td>
	        <td class="filter_value">
	            <html:text property="filterDescription" title="Enter text [a-zA-Z_0-9] to filter on.">
				</html:text>
		  </td>
		</tr>
		<tr>
			<td class="filter_label">Category</td>
			<td class="filter_value" colspan="2">
				<html:select property="filterMrecCategoryId" styleClass="fixedwidth80">
					<html:options collection="UM__MREC_CATEGORIES" property="mrecCategoryId" labelProperty="category"/>
				</html:select>
			</td>
		</tr>
		<tr>
			<td class="filter_label">Type</td>
			<td class="filter_value" colspan="2">
				<html:select property="type" styleClass="fixedwidth80">
					<html:option value="All">All</html:option>
					<html:option value="F">Fileset</html:option>
					<html:option value="T">Timeslot</html:option>
				</html:select>
			</td>
		</tr>
		<tr>
			<td class="filter_label">Billing Chain</td>
			<td class="filter_value" colspan="2">
				<html:select property="filterGraphId" styleClass="fixedwidth80">
					<html:options collection="UM__MREC_GRAPHS" property="graphId" labelProperty="name"/>
				</html:select>
			</td>
		</tr>
		<tr>
			<td class="filter_label">Nodes:</td>
			<td class="filter_label"><bean:write name="mrecTpmDform" property="iSideTitle" /></td>
			<td class="filter_label"><bean:write name="mrecTpmDform" property="jSideTitle" /></td>
		</tr>
		<tr>
			<td/>
			<td class="filter_value">
				<html:select property="lhsNodes" multiple="multiple" size="8" styleClass="fixedwidth60" styleId="lhsNodes">
					<html:options collection="UM__MREC_NODES" property="nodeId" labelProperty="name"/>
				</html:select>
			</td>
			<td class="filter_value">
				<html:select property="rhsNodes" multiple="multiple" size="8" styleClass="fixedwidth60" styleId="rhsNodes">
					<html:options collection="UM__MREC_NODES" property="nodeId" labelProperty="name"/>
				</html:select>
			</td>
		</tr>
		<tr>
			<td/>
			<td>
				<html:submit property="method" styleClass="buttonFixedSize">
					<asc:message key="web.button.apply"/>
				</html:submit>
				<html:submit property="method" styleClass="buttonFixedSize">
					<asc:message key="web.button.reset"/>
				</html:submit></td>
	</table>
</asc:showHideBlock>
</html:form>
<asc:separator />
<asc:block>
	<table width="100%">
		<tr>
			<td valign="top" width="100%">
				<tiles:insert page="/jsp/web/tpm/TPM.jsp" flush="true">
					<tiles:put name="key" value="uk.co.cartesian.ascertain.um.web.action.mrec.MrecDefinition" />
				</tiles:insert></td></tr>
	</table>
</asc:block>
<asc:showHideInit description="filters" cookieId="MrecDefinitionFilters"/>
