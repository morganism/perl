<%@ taglib uri='tlds.c' prefix='c' %>
<%@ taglib uri='tlds.ascertain' prefix='asc' %>
<%@ taglib uri='tlds.struts-html' prefix='html' %>
<%@ taglib uri='tlds.struts-tiles' prefix='tiles' %>
<%@ taglib uri='tlds.struts-logic' prefix='logic' %>

<tiles:importAttribute name="page" scope="page" ignore="true"/>
<tiles:importAttribute name="title" scope="page" ignore="true"/>
<tiles:importAttribute name="disablePrinterIcon" scope="page" ignore="true"/>

<%-- Add the title bar to the page --%>    
<c:if test="${title != null && title !=''}">
    <tiles:importAttribute name="titleBar" scope="page"/>
    <tiles:importAttribute name="titleBarMenuItems" scope="page" ignore="true"/>
    <tiles:insert page="${titleBar}">
        <tiles:put name="title" value="${title}" />
        <tiles:put name="titleBarMenuItems" beanName="titleBarMenuItems" />
        <tiles:put name="disablePrinterIcon" value="${disablePrinterIcon}"/>
    </tiles:insert>
</c:if>
 
<%-- Now add any info, warning or error messages --%>
<logic:messagesPresent message="true" property="WEB__DEFAULT_ERROR">
    <div class="bg-error-colour fg-inverse-colour header bold">
        <html:messages id="message" message="true" property="WEB__DEFAULT_ERROR">
            &#8226;&nbsp;<c:out value="${message}"/><br/>
        </html:messages>
    </div>
</logic:messagesPresent>
<logic:messagesPresent message="false" property="WEB__DEFAULT_ERROR">
    <div class="bg-error-colour fg-inverse-colour header bold">
        <html:messages id="message" message="false" property="WEB__DEFAULT_ERROR">
            &#8226;&nbsp;<c:out value="${message}"/><br/>
        </html:messages>
    </div>
</logic:messagesPresent>
<logic:messagesPresent message="true" property="WEB__DEFAULT_WARNING">
    <div class="bg-quaternary-colour fg-inverse-colour header bold">
        <html:messages id="message" message="true" property="WEB__DEFAULT_WARNING">
            &#8226;&nbsp;<c:out value="${message}"/><br/>
        </html:messages>
    </div>
</logic:messagesPresent>
<logic:messagesPresent message="true" property="WEB__DEFAULT_MESSAGE">
    <div class="bg-quaternary-colour fg-inverse-colour header bold">
        <html:messages id="message" message="true" property="WEB__DEFAULT_MESSAGE">
            &#8226;&nbsp;<c:out value="${message}"/><br/>
        </html:messages>
    </div>
</logic:messagesPresent>

<%-- Insert the page specific content--%>
<tiles:get name="page"/>
