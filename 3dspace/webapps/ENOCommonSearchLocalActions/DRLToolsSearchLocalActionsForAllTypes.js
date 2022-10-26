
define('DS/ENOCommonSearchLocalActions/DRLToolsSearchLocalActionsForAllTypes',[ 'UWA/Class','UWA/Class/Debug',
'UWA/Class/Events'
], function(UWAClass,
UWADebug,
UWAEvents
) {
	var ActionsHandler = UWAClass.singleton(UWAEvents, UWADebug, {
		executeAction: function (actions_data) {
		var newForm= document.createElement('form');
		document.body.appendChild(newForm);
		newForm.method = "POST"; 
		var input1   = document.createElement('input');
		input1.type="hidden";
		input1.name  ="objectId";
		input1.value=actions_data.object_id;
		var input2   = document.createElement('input');
		input2.type="hidden";
		input2.name  ="action";
		newForm.appendChild(input1);
		newForm.appendChild(input2);
		var today=new Date();
		var suffix=today.getTime();
		var winName = "_self";
		var formActionURl = "../drV6Tools/drSearchActions.jsp?";
		formActionURl += "&actionId="+actions_data.action_id;
		formActionURl += "&emxTableRowId="+actions_data.object_ids;
		formActionURl += "&objectId="+newForm.objectId.value;
		formActionURl += "&suiteKey=Framework&StringResourceFileId=emxFrameworkStringResource&SuiteDirectory=common&widgetId=null";
		newForm.action = formActionURl;
		newForm.action.value="New";
		newForm.target = "listHidden";
		newForm.method = "post";
		addSecureToken(newForm);
		newForm.submit();
		removeSecureToken(newForm);
	},
	});
	return ActionsHandler;
});
