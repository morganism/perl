package uk.co.cartesian.ascertain.um.web.action.mrec;

import java.util.LinkedList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import uk.co.cartesian.ascertain.dgf.persistence.bean.GraphRef;
import uk.co.cartesian.ascertain.dgf.persistence.bean.NodeRef;
import uk.co.cartesian.ascertain.dgf.persistence.dao.GraphRefDatabaseDAO;
import uk.co.cartesian.ascertain.dgf.persistence.dao.NodeRefDatabaseDAO;
import uk.co.cartesian.ascertain.um.persistence.bean.mrec.MrecCategoryRef;
import uk.co.cartesian.ascertain.um.persistence.dao.mrec.MrecCategoryRefDatabaseDAO;
import uk.co.cartesian.ascertain.utils.exception.WebApplicationException;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;
import uk.co.cartesian.ascertain.utils.persistence.exceptions.ReadException;
import uk.co.cartesian.ascertain.web.tpm.ModularResultSetTPM;
import uk.co.cartesian.ascertain.web.tpm.action.TPMRepository;

public class MrecDefinitionDisplay extends Action {

	private static final String FILTER_GRAPH = "filterGraphId";
	private static final String FILTER_CATEGORY = "filterMrecCategoryId";

	static Logger logger = LogInitialiser.getLogger(MrecDefinitionDisplay.class.getName());

	public static final String MREC_CATEGORIES = "UM__MREC_CATEGORIES";
	public static final String MREC_NODES = "UM__MREC_NODES";
	public static final String MREC_GRAPHS = "UM__MREC_GRAPHS";

	public static final String _READ_BILLING_CHAIN_NODE_REF =  "SELECT * FROM DGF.V_BILLING_CHAIN_NODE_REF ORDER BY UPPER(NAME)";
	
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception
	{
		logger.debug("MrecDefinitionDisplay:execute(...) - START");
		final HttpSession session = request.getSession();
		final DynaActionForm dForm = (DynaActionForm)form;

		if( "Reset".equals(request.getParameter("method")) ){
			dForm.reset(mapping, request);
		}

		try {
			ModularResultSetTPM mtpm = (ModularResultSetTPM) TPMRepository.getTPM(session,MrecDefinitionSetup.TMP_UID);

			StringBuffer whereClause = new StringBuffer();

			Integer mrecCategoryId = (Integer)dForm.get(FILTER_CATEGORY);
			Integer graphId = (Integer)dForm.get(FILTER_GRAPH);
			String description = dForm.getString("filterDescription");
			String type = dForm.getString("type");

			if( description != null && description.matches("[\\w\\*]+") ){
				whereClause.append("   AND UPPER(t.name) LIKE '"+description.toUpperCase().replaceAll("\\*", "%")+"'\n");
			}

			if( mrecCategoryId != -1 ){
				whereClause.append("   AND t0.mrec_category_id = " + mrecCategoryId + "\n");
			}

			if( ! ("All").equalsIgnoreCase(type) ){
				whereClause.append("   AND t.mrec_type = '" + type + "' \n");
			}

			for (String nodeId : ((String[])dForm.get("lhsNodes"))) {
				whereClause.append("   AND t.mrec_definition_id in ( SELECT u.mrec_definition_id FROM um.v_mrec_def_lhs_nodes u WHERE u.node_id = "+nodeId+" )\n" );
			}

			for (String nodeId : ((String[])dForm.get("rhsNodes"))) {
				whereClause.append("   AND t.mrec_definition_id in ( SELECT u.mrec_definition_id FROM um.v_mrec_def_rhs_nodes u WHERE u.node_id = "+nodeId+" )\n" );
			}

			if( graphId != -1 ){
				whereClause.append("   AND t.graph_id = " + graphId + "\n");
			}

			mtpm.updateVariableWhereClauseElements(whereClause.toString());

			getFilters(request);

		} catch (Exception e) {
			String msg = "Could not initialise the form values?";
			logger.error("MrecDefinitionDisplay:execute(...) - " + msg, e);
			throw new WebApplicationException(msg + "\n" + e.toString());
		}

		return mapping.findForward("success");
	}

	private void getFilters(HttpServletRequest request) throws ReadException {
		//Fill category filter list
		List<MrecCategoryRef> list = new LinkedList<MrecCategoryRef>();
		MrecCategoryRefDatabaseDAO.readAll(list,true);
		request.setAttribute(MREC_CATEGORIES, list);

		//Fill nodes filter list - list them all at this point could filter out nodes not joined to an mrec
		List<NodeRef>nodeList = new LinkedList<NodeRef>();
		NodeRefDatabaseDAO.readUsingQuery( _READ_BILLING_CHAIN_NODE_REF , nodeList );
		request.setAttribute(MREC_NODES, nodeList);

		//Fill graph filter list
		List<GraphRef>graphList = new LinkedList<GraphRef>();
		graphList.add(new GraphRef(new Integer(-1),"All"));
		GraphRefDatabaseDAO.readAll(graphList);
		request.setAttribute(MREC_GRAPHS, graphList);
	}
}
