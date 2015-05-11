<%@ taglib uri='tlds.ascertain' prefix='asc' %>
<%@ taglib uri='tlds.struts-bean' prefix='bean' %>
<%@ taglib uri='tlds.struts-html' prefix='html' %>
<%@ taglib uri='tlds.struts-tiles' prefix='tiles' %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<asc:filterManager attributeName="UM_METRIC_DETAILS_FILTER_MANAGER" reload="false">
	<asc:createFilter name="DgfEdge" formProperty="edgeId" />
	<asc:createFilter name="UmEdgeMetricDefinition" formProperty="edgeMetricId"/>

	<asc:createFilter name="DgfNode" formProperty="nodeId" />
	<asc:createFilter name="UmNodeMetricDefinition" formProperty="nodeMetricId"/>

	<asc:createFilter name="UmSource" formProperty="sourceId" />
	<asc:createFilter name="UmSourceType" formProperty="sourceTypeId"/>

	<asc:createFilter name="UmEdrType" formProperty="edrTypeId" />
	<asc:createFilter name="UmEdrSubType" formProperty="edrSubTypeId"/>

	<asc:linkFilter source="DgfEdge" target="UmEdgeMetricDefinition" noBackwardLink="false"/>
	<asc:linkFilter source="DgfNode" target="UmNodeMetricDefinition" noBackwardLink="false"/>
	<asc:linkFilter source="UmSourceType" target="UmSource" noBackwardLink="true"/>
	<asc:linkFilter source="UmEdrType" target="UmEdrSubType" noBackwardLink="true"/>
</asc:filterManager>

<script>
	//set javascript handlers (jquery)
	$(document).ready(function() {
		// add the show/hide function to 'Type' radio button
		$("#isNode").click(function(){
			$(".edgeBlock").hide();
			$(".nodeBlock").show();
		});
		$("#isEdge").click(function(){
			$(".nodeBlock").hide();
			$(".edgeBlock").show();
		});
	
		// add validation handler to the form
	    $("form[name='metricDetailsReportDform']").submit(function() {
	        if ( $("#fromDate_i_f").val() == '' || $("#toDate_i_f").val() == '') {
	            alert( 'Please enter a Sample Date range.' );
	            return false;
	        }
	        return true;
	    });
	});
</script>

<script type="text/javascript" > 
	function toggleComparator(type,rowID,periodID)
	{
		//alert( "type:" + type + "\nrowID:" + rowID + "\nperiodID:" + periodID );	
		$.ajax({
			url:     "/um/um/metricDetailsReportProcessDispatch.do?method=toggleComparator&type=" + type + "&fMetricId=" + rowID + "&dPeriodId=" + periodID,
			success: function(){ tpmActionCall( 'uk.co.cartesian.ascertain.um.web.action.MetricDetailsReport', 'navigate', 'refresh'); }	
		});	
	}
</script>

<asc:showHideBlock description="filters" cookieId="MetricDetailsReport">
    <html:form action="/um/metricDetailsReportProcess">
        <table width="100%" border="0">
            <tr>
                <td class="filter_label" valign="top">
                    Sample Date Range
                </td>
                <td width="1">&nbsp;</td>
                <td class="filter_value" valign="top" colspan="3">                  
                    <table cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <tiles:insert page="/jsp/web/DateTimeWidget.jsp">
                                    <tiles:put name="property" value="fromDate"/>
                                    <tiles:put name="nullable" value="false"/>
                                </tiles:insert>
                            </td>
                            <td>
                                &nbsp;&nbsp;to&nbsp;&nbsp;
                            </td>
                            <td>
                                <tiles:insert page="/jsp/web/DateTimeWidget.jsp" >
                                    <tiles:put name="property" value="toDate"/>
                                    <tiles:put name="nullable" value="false"/>
                                </tiles:insert>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>   
             <tr>
                <td class="filter_label" nowrap="nowrap">
                    Type
                </td>
                <td width="1">&nbsp;</td>
                <td class="filter_value" nowrap="nowrap">
                    <bean:define id="isNode" name="metricDetailsReportDform" property="isNodeSelected" />
                    <html:radio property="isNodeSelected" styleId="isNode" value="true" >
                        Node
                    </html:radio>
                    &nbsp;&nbsp;
                    <html:radio property="isNodeSelected" styleId="isEdge" value="false" >
                        Edge
                    </html:radio>
                </td>
            </tr>
			<%-- Initialise the page --%>
			<c:set var="nodeBlockDisplay" value=""/>
			<c:set var="edgeBlockDisplay" value="display: none;"/>
 			<c:if test="${metricDetailsReportDform.map['isNodeSelected']=='false'}">
				<c:set var="nodeBlockDisplay" value="display: none;"/>
				<c:set var="edgeBlockDisplay" value=""/>
			</c:if>
			<tr align="left" class="nodeBlock" style="${nodeBlockDisplay}">
				<asc:showFilterAjaxTD name="DgfNode" selectClass="minwidth80"/>
			</tr>
			<tr align="left" class="nodeBlock" style="${nodeBlockDisplay}">
				<asc:showFilterAjaxTD name="UmNodeMetricDefinition" selectClass="minwidth80"/>
			</tr>

			<tr align="left" class="edgeBlock" style="${edgeBlockDisplay}">
				<asc:showFilterAjaxTD name="DgfEdge" selectClass="minwidth80"/>
			</tr>
			<tr align="left" class="edgeBlock" style="${edgeBlockDisplay}">
				<asc:showFilterAjaxTD name="UmEdgeMetricDefinition" selectClass="minwidth80"/>
			</tr>

			<tr align="left">
				<asc:showFilterAjaxTD name="UmSourceType" selectClass="minwidth80" />
			</tr>
			<tr align="left">
				<asc:showFilterAjaxTD name="UmSource" selectClass="minwidth80"/>
			</tr>

			<tr align="left">
				<asc:showFilterAjaxTD name="UmEdrType" selectClass="minwidth80" />
			</tr>
			<tr align="left">
				<asc:showFilterAjaxTD name="UmEdrSubType" selectClass="minwidth80"/>
			</tr>

			<tr>
				<td class="filter_label">
	                <asc:message key="um.label.isIssue"/>
				</td>
                <td width="1">&nbsp;</td>
		        <td class="filter_value">
		            <html:select property="isIssue" styleClass="minwidth80">
			            <html:options name="MD_REP_Y_OR_N_DROP_DOWN" property="ids" labelName="MD_REP_Y_OR_N_DROP_DOWN" labelProperty="labels"/>
			        </html:select>
		        </td>
			</tr>

			<tr>
				<td class="filter_label">
	                <asc:message key="um.label.isComparator"/>
				</td>
                <td width="1">&nbsp;</td>
		        <td class="filter_value">
		            <html:select property="isComparator" styleClass="minwidth80">
			            <html:options name="MD_REP_Y_OR_N_DROP_DOWN" property="ids" labelName="MD_REP_Y_OR_N_DROP_DOWN" labelProperty="labels"/>
			        </html:select>
		        </td>
			</tr>

			<tr>
				<td class="filter_label">&nbsp;</td>
                <td width="1">&nbsp;</td>
				<td class="filter_value">
					<html:submit property="method" styleClass="buttonFixedSize">
						<bean:message key="web.button.apply"/>
					</html:submit>
                    <html:reset styleClass="buttonFixedSize" onclick="doResetFiltersAjax('UM_METRIC_DETAILS_FILTER_MANAGER'); return true;">
                        <asc:message key="web.button.reset"/>
                    </html:reset>
					<html:submit property="method" styleClass="buttonFixedSize120">
						<bean:message key="um.button.toggle.is.comparator"/>
					</html:submit>
				</td>
			</tr>
		</table>
    </html:form>
</asc:showHideBlock>

<asc:showHideInit description="filters" cookieId="MetricDetailsReport"/>

<asc:separator/>

<asc:block>	
	<tiles:insert page="/jsp/web/tpm/TPM.jsp" flush="true">
		<tiles:put name="key" value="uk.co.cartesian.ascertain.um.web.action.MetricDetailsReport" />
	</tiles:insert>
</asc:block>

