
<%@include file="../common/emxNavigatorInclude.inc"%>
<%@page import="com.dassault_systemes.enovia.actiontasks.Helper"%>
<%@page import="matrix.db.Context"%>
<%@page import="com.matrixone.servlet.Framework"%>
<%@page import="com.dassault_systemes.enovia.actiontasks.ActionTasksException"%>
<script language="javascript" src="../common/scripts/emxUICore.js"></script>

<%!
	private String getString(Context context, String key) throws ActionTasksException {
		try {
			return Helper.getI18NString(context, key);
		} catch (Exception e) {
			throw new ActionTasksException(e);
		}
	}
%>

<script type="text/javascript" language="javascript">
function refreshTableACTSummary() {
	var frame = findFrame(getTopWindow(), "ACTSummary");
	if (frame == null) {
		frame = findFrame(getTopWindow(), "detailsDisplay");
	}
	if (frame == null) {
		frame = findFrame(getTopWindow(), "content");
	}
	frame.location.href=frame.location.href;
}

</script>
