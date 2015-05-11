<%@ taglib uri='tlds.ascertain' prefix='asc'%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="tiles" uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="bean" uri="http://struts.apache.org/tags-bean" %>
<%@ page import="uk.co.cartesian.ascertain.um.web.action.mrec.MrecChartable"%>

<asc:filterManager attributeName="UM_MREC_CHART_FILTER_MANAGER">
	<asc:createFilter name="UmMrecEdge" formProperty="edgeId" />
	<asc:createFilter name="UmFileMrecDefinition" formProperty="mrecDefinitionId_file"/>

	<asc:linkFilter source="UmFileMrecDefinition" target="UmMrecEdge" noBackwardLink="true"/>
</asc:filterManager>


<script>
//set javascript handlers (jquery)
$(document).ready(function() {
	// add the show/hide function to 'Type' radio button
	$("#isTime").click(function(){
		$(".fileBlock").hide();
		$(".timeBlock").show();
	});
	$("#isFile").click(function(){
		$(".timeBlock").hide();
		$(".fileBlock").show();
	});

	// add validation handler to the form
	$("form[name='mrecChartDform']").submit(function() {
		if ( $("input[@name='mrecType']:checked").val() == 'FILE') {
			if ( $("#UmFileMrecDefinition").val() == 0 || $("#UmMrecEdge").val() == 0 ) {
				alert( 'Please select an Edge and a Reconciliation' );
				return false;
			}
		} else {
			if ( $("[name='mrecDefinitionId_time']").val() == 'XXX_NULL_XXX' ) {
				alert( 'Please select a Reconciliation' );
				return false;
			}
		}
		return true;
	});
});
</script>

<html:form action='<%="/um/mrecChartProcess.do"+MrecChartable.getRequestParameters(request)%>'>
	<asc:showHideBlock description="Options" cookieId="MrecChartForm">
		<table width="100%" border="0">
		    <tr>		
				<td class="filter_label">Start</td>
	            <td width="1">&nbsp;</td>
		    	<td class="filter_value">
					<tiles:insert page="/jsp/web/DateTimeWidget.jsp">
	      				<tiles:put name="property" value="from"/>
						<tiles:put name="nullable" value="false"/>
					</tiles:insert>
				</td>
			</tr>
		    <tr>
				<td class="filter_label">End</td>
	            <td width="1">&nbsp;</td>
				<td class="filter_value">
					<tiles:insert page="/jsp/web/DateTimeWidget.jsp" >
	      				<tiles:put name="property" value="to"/>
						<tiles:put name="nullable" value="false"/>
					</tiles:insert>
				</td>
			</tr>
			<tr>
                <td class="filter_label">
                    Type
                </td>
	            <td width="1">&nbsp;</td>
                <td class="filter_value">
                    Fileset&nbsp;<html:radio value="FILE" property="mrecType" styleId="isFile" />
                    &nbsp;&nbsp;&nbsp;
                    Timeslot&nbsp;<html:radio value="TIME" property="mrecType" styleId="isTime" /> 
                </td>	    
			</tr>
			<%-- Initialise the page --%>
			<c:set var="timeBlockDisplay" value=""/>
			<c:set var="fileBlockDisplay" value="display: none;"/>
 			<c:if test="${mrecChartDform.map['mrecType']=='FILE'}">
				<c:set var="timeBlockDisplay" value="display: none;"/>
				<c:set var="fileBlockDisplay" value=""/>
			</c:if>
			<tr id="recon_time"  class="timeBlock" style="${timeBlockDisplay};">
	            <td class="filter_label">Reconciliation</td>
	            <td width="1">&nbsp;</td>
	            <td class="filter_value">
	                <html:select property="mrecDefinitionId_time" styleClass="fixedwidth100">
	                    <html:options name="UM__MREC_TIME_LIST" property="ids" labelName="UM__MREC_TIME_LIST" labelProperty="labels"/>
	                </html:select>
	            </td>
	        </tr>
			<tr align="left" class="fileBlock"  style="${fileBlockDisplay};">
				<asc:showFilterAjaxTD name="UmFileMrecDefinition" selectClass="fixedwidth100" showAll="true" allText="&lt;Please Select&gt;" />
			</tr>
			<tr align="left" class="fileBlock"  style="${fileBlockDisplay};">
				<asc:showFilterAjaxTD name="UmMrecEdge" selectClass="fixedwidth100"  showAll="true" allText="&lt;Please Select&gt;"/>
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
                  if (incThresh == null || "true".equals(incThresh))
                  {
                %>
                    <input type="radio" name="includeThresholds" value="true" checked="true"/>Yes
                    &nbsp;&nbsp;
                    <input type="radio" name="includeThresholds" value="false"/>No
                <%
                  }
                  else
                  {
                %>
                    <input type="radio" name="includeThresholds" value="true"/>Yes
                    &nbsp;&nbsp;
                    <input type="radio" name="includeThresholds" value="false" checked="true"/>No
                <%
                  }
                %>
                </td>
            </tr>
            <tr>
                <td class="filter_label" nowrap="nowrap">
                    Display Type?
                </td>
                <td width="1">&nbsp;</td>
                <td class="filter_value" nowrap="nowrap">
                <%
                  String displayType;
                displayType = request.getParameter("displayType");
                  if (displayType == null || "percentage".equals(displayType))
                  {
                %>
                    <input type="radio" name="displayType" value="absolute"/>Absolute
                    &nbsp;&nbsp;
                    <input type="radio" name="displayType" value="percentage" checked="true"/>Percentage
                <%
		  }
		  else
                  {
                %>
                    <input type="radio" name="displayType" value="absolute" checked="true"/>Absolute
                    &nbsp;&nbsp;
                    <input type="radio" name="displayType" value="percentage"/>Percentage
                <%
                  }
                %>
                </td>
            </tr>
	    <tr>
                <td class="filter_label" nowrap="nowrap">
                    Reconciliation Type?
                </td>
                <td width="1">&nbsp;</td>
                <td class="filter_value" nowrap="nowrap">
                <%
                  String reconciliationType;
                reconciliationType = request.getParameter("reconciliationType");
                  if (reconciliationType == null || "value".equals(reconciliationType))
                  {
                %>
                    <input type="radio" name="reconciliationType" value="value" checked="true"/>Value
                    &nbsp;&nbsp;
                    <input type="radio" name="reconciliationType" value="forecast"/>Forecast
                <%
                  }
                  else
                  {
                %>
                    <input type="radio" name="reconciliationType" value="value"/>Value
                    &nbsp;&nbsp;
                    <input type="radio" name="reconciliationType" value="forecast" checked="true"/>Forecast
                <%
                  }
                %>
                </td>
            </tr>
            <tr>
                <td class="filter_label"></td>               
	            <td width="1">&nbsp;</td>
                <td class="filter_value">
                    <html:submit property="method" styleClass="buttonFixedSize" styleId="generateButton">
                        <asc:message key="web.button.generate"/>
                    </html:submit>
                    <html:reset styleClass="buttonFixedSize" onclick="doResetFiltersAjax('UM_MREC_CHART_FILTER_MANAGER'); return true;">
                        <asc:message key="web.button.reset"/>
                    </html:reset>
                </td>
            </tr>
        </table>
	</asc:showHideBlock>

    <asc:showHideInit description="Options" cookieId="MrecChartForm"/> 
			
	<asc:separator />

    <c:choose>
        <c:when test="${mrecChartDform.map.mrecType == 'FILE'}">
            <c:set var="mrecDefinitionIdValue" value="${mrecChartDform.map.mrecDefinitionId_file}"/>
        </c:when>
        <c:otherwise>
            <c:set var="mrecDefinitionIdValue" value="${mrecChartDform.map.mrecDefinitionId_time}"/>
        </c:otherwise>
    </c:choose>
	<c:if test="${mrecDefinitionIdValue != '' && mrecDefinitionIdValue != 'XXX_NULL_XXX'}">
		<asc:block>
			<script type="text/javascript" src="/swf/web/amcharts/js/cart_swfobject.js"></script>
		    <div id="flashcontent_mrecChart">
		        <strong>An error occurred.</strong>
		    </div>
		    <script type='text/javascript'>

            // <![CDATA[
            var so = new SWFObject('/swf/web/amcharts/amline.swf', 'amline', '100%', '450', '8', '#FFFFFF');
                so.addVariable('path', '/swf/web/amcharts/');
                so.addVariable('settings_file', '/swf/web/amcharts/settings/amline_settings_metric_chart.xml'); 
                so.addVariable('data_file', escape('/servlet/MrecChartSwfDataServlet'));            
                so.addVariable('preloader_color', '#999999');
                so.addVariable('additional_chart_settings', '<settings><connect>true</connect><add_time_stamp>true</add_time_stamp><redraw>true</redraw><max_columns>2</max_columns></settings>');
                so.addParam('wmode', 'transparent');
                so.addVariable('chart_id', 'amline');
                so.write('flashcontent_mrecChart');
            // ]]>

            lineOfInterest = 0;                 

            function raiseCase()
            {
                var formData = "";

                //alert( "Rollover:graph_index=" + bulletGraphIndex + "\nvalue=" + bulletYVal + "\nseries=" + bulletXVal );
                                
                if( $('input[name=mrecType]:checked').val() == 'FILE' )
                {
                    formData += "&mrecType=FILE";
                    formData += "&mrecDefinitionId_file=" + $('[name=mrecDefinitionId_file]').val();
                    formData += "&mrecDefinitionName_file=" + escape( $('[name=mrecDefinitionId_file] option:selected').text() );
                    formData += "&edgeId=" + $('[name=edgeId]').val();
                    formData += "&edgeName=" + escape( $('[name=edgeId] option:selected').text() );						
                }
                else
                {
                    formData += "&mrecType=TIME";
                    formData += "&mrecDefinitionId_time=" + $('[name=mrecDefinitionId_time]').val();
                    formData += "&mrecDefinitionName_time=" + escape( $('[name=mrecDefinitionId_time] option:selected').text() );
                }

                var filterData   = "filterFrom=" + escape( $('[name=from]').val() ) + "&filterTo=" + escape( $('[name=to]').val() );
                var rangeData    = "zoomFrom=" + escape( zoomFrom ) + "&zoomTo=" + escape( zoomTo );
                var selectedData = "bulletGraphIndex=" + bulletGraphIndex + "&bulletYVal=" + bulletYVal + "&bulletXVal=" + bulletXVal;

                if( bulletGraphIndex != null && bulletYVal != null &&  bulletXVal != null )
                {
                    $.ajax({
                        type:    "POST",  
                        url:     "/servlet/MrecCaseServlet",
                        data:	 "issueTypeId=35500&" + formData + "&" + filterData + "&" + rangeData + "&" + selectedData,
                        success: function( result ){
                            alert( "Case " + result + " has been raised" ); 
                        }
                    });
                }
            }

        </script>	
		</asc:block>
		
		<asc:separator />
	
		<tiles:insert page="/um/um/mrecChartDataSetup.do" />
						
	</c:if>
</html:form>

