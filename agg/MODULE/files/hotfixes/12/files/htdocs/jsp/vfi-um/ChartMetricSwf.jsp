<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="asc" uri="AscertainTags" %>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="bean" uri="http://struts.apache.org/tags-bean" %>
<%@ taglib prefix="tiles" uri="http://struts.apache.org/tags-tiles" %>

<asc:filterManager attributeName="UM_METRIC_CHART_FILTER_MANAGER" reload="false">
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
// set javascript handlers (jquery)
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
	$("form[name='chartMetricSwfDform']").submit(function() {
		if ( $("input[@name='isNodeSelected']:checked").val() == 'true') {
			if ( $("#UmNodeMetricDefinition").val() == 0 || $("#DgfNode").val() == 0 ) {
				alert( 'Please select a Node and a Metric Definition' );
				return false;
			}
		} else {
			if ( $("#UmEdgeMetricDefinition").val() == 0 || $("#DgfEdge").val() == 0 ) {
				alert( 'Please select an Edge and a Metric Definition' );
				return false;
			}
		}
		return true;
	});

});
</script>

<html:form action="/vfi-um/chartMetricSwfProcess.do?id=${param.id}&clickStreamId=${requestScope.clickStreamId}" >
    <asc:showHideBlock description="Options" cookieId="ChartMetricSwf">
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
                    <bean:define id="isNode" name="chartMetricSwfDform" property="isNodeSelected" />
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
 			<c:if test="${chartMetricSwfDform.map['isNodeSelected']=='false'}">
				<c:set var="nodeBlockDisplay" value="display: none;"/>
				<c:set var="edgeBlockDisplay" value=""/>
			</c:if>
			<tr align="left" class="nodeBlock" style="${nodeBlockDisplay}">
				<asc:showFilterAjaxTD name="DgfNode" selectClass="minwidth80" showAll="true" allText="&lt;Please Select&gt;" />
			</tr>
			<tr align="left" class="nodeBlock" style="${nodeBlockDisplay}">
				<asc:showFilterAjaxTD name="UmNodeMetricDefinition" selectClass="minwidth80" showAll="true" allText="&lt;Please Select&gt;" />
			</tr>

			<tr align="left" class="edgeBlock" style="${edgeBlockDisplay}">
				<asc:showFilterAjaxTD name="DgfEdge" selectClass="minwidth80" showAll="true" allText="&lt;Please Select&gt;" />
			</tr>
			<tr align="left" class="edgeBlock" style="${edgeBlockDisplay}">
				<asc:showFilterAjaxTD name="UmEdgeMetricDefinition" selectClass="minwidth80" showAll="true" allText="&lt;Please Select&gt;" />
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
                <td class="filter_label" nowrap="nowrap">
                    Include Thresholds?
                </td>
                <td width="1">&nbsp;</td>
                <td class="filter_value" nowrap="nowrap">
                <%
                  String incThresh;
                  incThresh = request.getParameter("includeThresholds");
                  if (incThresh == null || "false".equals(incThresh))
                  {
                %>
                    <input type="radio" name="includeThresholds" value="true"/>Yes
                    &nbsp;&nbsp;
                    <input type="radio" name="includeThresholds" value="false" checked="true"/>No
                <%
                  }
                  else
                  {
                %>
                    <input type="radio" name="includeThresholds" value="true" checked="true"/>Yes
                    &nbsp;&nbsp;
                    <input type="radio" name="includeThresholds" value="false"/>No
                <%
                  }
                %>
                </td>
            </tr>

            <tr>
                <td colspan="2" class="filter_label">&nbsp;</td>
                <td class="filter_value">
                    <table cellspacing="0" cellpadding="0" >
                        <tr>
			                <td class="filter_value" valign="top" nowrap="nowrap">
				                <html:submit styleClass="buttonFixedSize">
			                        <asc:message key="web.button.apply"/>
				                </html:submit>
			                    <html:reset styleClass="buttonFixedSize" onclick="doResetFiltersAjax('UM_METRIC_CHART_FILTER_MANAGER'); return true;">
			                        <asc:message key="web.button.reset"/>
			                    </html:reset>
			                </td>
			            </tr>           
        			</table>
        		</td>
        	</tr>        
		</table>
    </asc:showHideBlock>    
</html:form>

<asc:showHideInit description="Options" cookieId="ChartMetricSwf"/>

<bean:define id="edgeMetricIdFormValue" name="chartMetricSwfDform" property="edgeMetricId" />
<bean:define id="nodeMetricIdFormValue" name="chartMetricSwfDform" property="nodeMetricId" />
<c:if test="${edgeMetricIdFormValue != '' or nodeMetricIdFormValue != ''}">
	<asc:separator/>
	
	<asc:block>
		<div id="flashcontent_ChartMetricSwf">
		    <strong>An error occurred.</strong>
		</div>
		<script type='text/javascript'>
		
		    // <![CDATA[
		        var so = new SWFObject('/swf/web/amcharts/amline.swf', 'amline', '100%', '450', '8', '#FFFFFF');
		        so.addVariable('path', '/swf/web/amcharts/');
		        so.addVariable('settings_file', '/swf/web/amcharts/settings/amline_settings_metric_chart.xml'); 
		        so.addVariable('data_file', escape('/servlet/VFIChartMetricSwfDataServlet?clickStreamId=${requestScope.clickStreamId}&includeThresholds=<%=request.getParameter("includeThresholds") %>'));
		        so.addVariable('preloader_color', '#999999');
		        so.addVariable('additional_chart_settings', '<settings><connect>true</connect><add_time_stamp>true</add_time_stamp><values><y_left><min>0</min></y_left></values></settings>');
		        so.addParam('wmode', 'transparent');
		        so.addVariable('chart_id', 'amline');
		        so.write('flashcontent_ChartMetricSwf');
		    // ]]>

	        lineOfInterest = 0;
			    
			function raiseCase()
			{	
                //alert( "Rollover:graph_index=" + bulletGraphIndex + "\nvalue=" + bulletYVal + "\nseries=" + bulletXVal );
				
				var formData = "sourceId="     + $('[name=sourceId]').val() 	+ "&" + 
							   "sourceTypeId=" + $('[name=sourceTypeId]').val() + "&" + 
							   "edrTypeId="    + $('[name=edrTypeId]').val()	+ "&" + 
							   "edrSubTypeId=" + $('[name=edrSubTypeId]').val();
				   
				if( $('input[name=isNodeSelected]:checked').val() == 'true' )
				{
					formData += "&nodeId=" + $('[name=nodeId]').val() + "&nodeMetricId=" + $('[name=nodeMetricId]').val();					
					formData += "&nodeName=" + escape( $('[name=nodeId] option:selected').text() );
					formData += "&nodeMetricName=" + escape( $('[name=nodeMetricId] option:selected').text() );   	  
				}
				else
				{
					formData += "&edgeId=" + $('[name=edgeId]').val() + "&edgeMetricId=" + $('[name=edgeMetricId]').val();					
					formData += "&edgeName=" + escape( $('[name=edgeId] option:selected').text() );
					formData += "&edgeMetricName=" + escape( $('[name=edgeMetricId] option:selected').text() );				
				}				 
				
				var filterData   = "filterFrom=" + escape( $('[name=fromDate]').val() ) + "&filterTo=" + escape( $('[name=toDate]').val() );
				var rangeData    = "zoomFrom=" + escape( zoomFrom ) + "&zoomTo=" + escape( zoomTo );
				var selectedData = "bulletGraphIndex=" + bulletGraphIndex + "&bulletYVal=" + bulletYVal + "&bulletXVal=" + bulletXVal;

				if( bulletGraphIndex != null && bulletYVal != null &&  bulletXVal != null )
				{
					$.ajax({
						type:    "POST",  
						url:     "/servlet/MetricCaseServlet",
						data:  "issueTypeId=35500&" + formData + "&" + filterData + "&" + rangeData + "&" + selectedData,
						success: function( result ){ 
							alert( "Case " + result + " has been raised" ); 
						}	
					});
				}				
			}
							    
		</script>
    </asc:block>
</c:if>

