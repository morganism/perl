/**
 * 
 */
package uk.co.cartesian.ascertain.imm.web.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import uk.co.cartesian.ascertain.imm.db.dao.IMMDatabaseDAOUtils;
import uk.co.cartesian.ascertain.imm.web.filters.IMMFilter;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;
import uk.co.cartesian.ascertain.utils.parse.SquareBracketSubstitutionParser;
import uk.co.cartesian.ascertain.utils.parse.SubstitutionParser;
import uk.co.cartesian.ascertain.web.session.bean.AscertainSessionUser;

/**
 * @author babramson
 *
 */
public class IMMFilterDropDownXMLServlet 
extends HttpServlet 
{
    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    static Logger logger = LogInitialiser.getLogger(IMMFilterDropDownXMLServlet.class.getName());

    private static final String ATTRIBUTE_FILTER_SQL =
        "select t.dropdown_values_as_sql,\n" + 
        "       t.dropdown_has_null,\n" + 
        "       t.dropdown_has_all,\n" + 
        "       t.link_field\n" +
        "from imm.attribute_filter_conf_ref t where t.attribute_id=?";
    
    private static final String NO_VALUES_LABEL = "<No options available>";
    private static final String NO_VALUES_VALUE = IMMFilter.ALL_VALUE;
    private static final String SQL_ORDER = "\nORDER BY LABEL";
    
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
	throws ServletException, IOException 
	{
        // Check for parameter "html=true"   
        String html = req.getParameter("html");
		if ("true".equals(html))
		{
			processRequestHTML(req, resp);
		}
		else
		{
		processRequest(req, resp);
	}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
	throws ServletException, IOException 
	{
		doGet(req, resp);
	}
	
	/**
	 * @deprecated
	 * Returns an xml representation of a list of html select options
	 * -- slow better to use processRequestHTML
	 */
	private void processRequest(HttpServletRequest req, HttpServletResponse resp)
	{
		Connection connection = null;
        PreparedStatement statement = null;
        ResultSet results = null;
        int reqAttribId = 0;
        Document document;
        Element rootElm;        
        String ddl_sql = "SELECT DISTINCT VALUE, LABEL FROM (";
        
        // Check input!   
        String reqValue = req.getParameter("value");
        
        try {
	        reqAttribId = Integer.parseInt( req.getParameter("attribId") );
        } catch(NumberFormatException nfe){
        	logger.error("IMMFilterDropDownXMLServlet:processRequest() - Input parametes non-numerical!");
        }
        
		if(reqAttribId != 0 && reqValue !=null)
        {
            try
            {
                connection = IMMDatabaseDAOUtils.getAutoConnection();
                
                /* Get dropdown SQL */
                statement = connection.prepareStatement(ATTRIBUTE_FILTER_SQL);
                statement.setInt(1, reqAttribId);
                results = statement.executeQuery();
                
                String sql = "";
                String link_field = "";
                boolean ddl_has_null = false;
                boolean ddl_has_all = false;
                
                if(results.next()){
                	sql 		= results.getString("dropdown_values_as_sql");
                	link_field 	= results.getString("link_field");
                	ddl_has_null= "Y".equals(results.getString("dropdown_has_null"));
                	ddl_has_all= "Y".equals(results.getString("dropdown_has_all"));
                } 
                else 
                {
                	logger.error("IMMFilterDropDownXMLServlet:processRequest() - Failed to read drop down sql.");
                }
                
                // Setup XML
                DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
                DocumentBuilder builder = factory.newDocumentBuilder();
                document = builder.newDocument();
                rootElm = (Element) document.createElement("response");
                document.appendChild(rootElm);
                
                // Prepare DDL SQL
                if(!IMMFilter.ALL_VALUE.equals(reqValue))
                {
                	if(IMMFilter.NULL_VALUE.equals(reqValue))
                	{
                		ddl_sql += sql + ")\nWHERE " + link_field + " is null";
                	}
                	else
                	{
                		ddl_sql += sql + ")\nWHERE " + link_field + "=" + reqValue;
                	}
                }
                else
                {
                	ddl_sql += sql + ")";
                }
                
                ddl_sql+=SQL_ORDER;                

                //Parse the given filter SQL
                SubstitutionParser p = new SquareBracketSubstitutionParser(AscertainSessionUser.getParameters(req));
                ddl_sql = p.parse(ddl_sql);
                
                //Get our results
                statement = connection.prepareStatement(ddl_sql);
                results = statement.executeQuery();

                boolean blnContent = false;
                
                // Add all value
                if(ddl_has_all)
                {
                    appendDDLOption(document, rootElm, IMMFilter.ALL_LABEL, IMMFilter.ALL_VALUE);                  
                    blnContent = true;
                } 
                

                // Add null value
                if(ddl_has_null)
                {
                    appendDDLOption(document, rootElm, IMMFilter.NULL_LABEL, IMMFilter.NULL_VALUE);                      
                    blnContent = true;
                }
                
                
                //Add other values
                while (results.next())
                {
                    appendDDLOption(document, rootElm, results.getString("label") , results.getString("value"));
                    blnContent = true;
                }
                
                // If we have no results and attribute "has no null", indicate no results 
                if(!blnContent && !ddl_has_null && !ddl_has_all)
                {
                	appendDDLOption(document, rootElm, NO_VALUES_LABEL , NO_VALUES_VALUE);
                }
                
                // Set content type
                resp.setContentType("text/xml");
                
                // Output                
                PrintWriter writer = resp.getWriter();
                StreamResult result = new StreamResult(writer);
                Transformer transformer = TransformerFactory.newInstance().newTransformer();
                DOMSource source = new DOMSource(document);
                transformer.transform(source, result); 
				
                writer.close();

            }
            catch (SQLException sqle)
            {
                logger.error("IMMFilterDropDownXMLServlet:processRequest() - Failed to read drop down values. Check SQL:\n" + ddl_sql, sqle);
            }
            catch (ParserConfigurationException pce){
            	logger.error("IMMFilterDropDownXMLServlet:processRequest() - Failed to create XML Document.", pce);
            }
            catch (Exception e){
            	logger.error("IMMFilterDropDownXMLServlet:processRequest() - General exception.", e);
            }
            finally
            {
                try{results.close();} catch(Exception e) {};
                try{statement.close();} catch(Exception e) {};
                try{connection.close();} catch(Exception e) {};
            }
        }
	}
	
	/**
	 * Based on processRequest()
	 * but return a html/text consisting of a list of  <option> elements
	 */
	private void processRequestHTML(HttpServletRequest req, HttpServletResponse resp)
	{
		Connection connection = null;
        PreparedStatement statement = null;
        ResultSet results = null;
        int reqAttribId = 0;
        String ddl_sql = "SELECT DISTINCT VALUE, LABEL FROM (";
        
        // Check input!   
        String reqValue = req.getParameter("value");
        String reqChildValue = req.getParameter("childValue");
        
        try 
        {
	        reqAttribId = Integer.parseInt( req.getParameter("attribId") );
        } 
        catch(NumberFormatException nfe)
        {
        	logger.error("IMMFilterDropDownXMLServlet:processRequestHTML() - Input parametes non-numerical!");
        }

        logger.debug("IMMFilterDropDownXMLServlet:processRequestHTML: Attrib: " + reqAttribId);
        logger.debug("IMMFilterDropDownXMLServlet:processRequestHTML: reqValue: " + reqValue);
		
		if(reqAttribId != 0 && reqValue !=null)
        {
            try
            {
                connection = IMMDatabaseDAOUtils.getAutoConnection();
                
                /* Get dropdown SQL */
                statement = connection.prepareStatement(ATTRIBUTE_FILTER_SQL);
                statement.setInt(1, reqAttribId);
                results = statement.executeQuery();
                
                String sql = "";
                String link_field = "";
                boolean ddl_has_null = false;
                boolean ddl_has_all = false;
                
                if(results.next())
                {
                	sql 		= results.getString("dropdown_values_as_sql");
                	link_field 	= results.getString("link_field");
                	ddl_has_null= "Y".equals(results.getString("dropdown_has_null"));
                	ddl_has_all= "Y".equals(results.getString("dropdown_has_all"));
                	
                } 
                else 
                {
                	logger.error("IMMFilterDropDownXMLServlet:processRequestNoXML() - Failed to read drop down sql.");
                }
                
                // Setup String!
                StringBuilder sb = new StringBuilder();
                
                // Prepare DDL SQL
                if(!IMMFilter.ALL_VALUE.equals(reqValue))
                {
                	if(IMMFilter.NULL_VALUE.equals(reqValue))
                	{
                		ddl_sql += sql + ")\nWHERE " + link_field + " is null";
                	}
                	else
                	{
                		ddl_sql += sql + ")\nWHERE " + link_field + "=" + reqValue;
                	}
                }
                else
                {
                	ddl_sql += sql + ")";
                }
                
                ddl_sql+=SQL_ORDER;                

                //Parse the given filter SQL
                SubstitutionParser p = new SquareBracketSubstitutionParser(AscertainSessionUser.getParameters(req));
                ddl_sql = p.parse(ddl_sql);
                
                //Get our results
                statement = connection.prepareStatement(ddl_sql);
                results = statement.executeQuery();

                boolean blnContent = false;
                
                // Add all value
                if(ddl_has_all)
                {
                    // eg. <option value="IMM_FILTER_ALL">All</option>
                    sb.append("<option value=\"").append(IMMFilter.ALL_VALUE).append("\"");
                    if(IMMFilter.ALL_VALUE.equals(reqChildValue))
                    {
                        sb.append(" selected=\"selected\"");
                    }
                    sb.append(">").append(IMMFilter.ALL_LABEL).append("</option>\n");
                    blnContent = true;
                } 

                // Add null value
                if(ddl_has_null)
                {
                    sb.append("<option value=\"").append(IMMFilter.NULL_VALUE).append("\"");
                    if(IMMFilter.NULL_VALUE.equals(reqChildValue))
                    {
                        sb.append(" selected=\"selected\"");
                    }
                    sb.append(">").append("&lt;").append(IMMFilter.NULL_LABEL_TEXT).append("&gt;").append("</option>\n");
                    blnContent = true;
                }
                
                //Add other values
                while (results.next())
                {
                    sb.append("<option value=\"").append(results.getString("value")).append("\"");
                    if(results.getString("value").equals(reqChildValue))
                    {
                        sb.append(" selected=\"selected\"");
                    }
                    sb.append(">").append(results.getString("label")).append("</option>\n");
                    blnContent = true;
                }
                
                // If we have no results and attribute "has no null", indicate no results 
                if(!blnContent && !ddl_has_null && !ddl_has_all)
                {
                    sb.append("<option value=\"").append(NO_VALUES_VALUE).append("\">").append(NO_VALUES_LABEL).append("</option>");
                }
                
                // Set content type
                resp.setContentType("text/html");
                
                // Output                
                PrintWriter writer = resp.getWriter();
                writer.print(sb.toString());
                writer.close();
            }
            catch (SQLException sqle)
            {
                logger.error("IMMFilterDropDownXMLServlet:processRequestNoXML() - Failed to read drop down values. Check SQL:\n" + ddl_sql, sqle);
            }
            catch (Exception e){
            	logger.error("IMMFilterDropDownXMLServlet:processRequestNoXML() - General exception.", e);
            }
            finally
            {
                try{results.close();} catch(Exception e) {};
                try{statement.close();} catch(Exception e) {};
                try{connection.close();} catch(Exception e) {};
            }
        }
	}

	private void appendDDLOption(Document _document, Element _root, String label, String value)
	{
		// Construct XML for response
        Element elm = (Element) _document.createElement("item");
        Element elmLabel = (Element) _document.createElement("label");
        Element elmValue = (Element) _document.createElement("value");
       
        elmLabel.appendChild( _document.createTextNode(label));
        elmValue.appendChild( _document.createTextNode(value));
        
        elm.appendChild(elmLabel);
        elm.appendChild(elmValue);
        _root.appendChild(elm);
	}
}
