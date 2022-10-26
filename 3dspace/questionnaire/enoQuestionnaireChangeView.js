function toggleSectionExpand(obj,strRel,index)
{
	var relatedObjectTableTR;
	var expandImg=obj;
	var lifecycleview;
	var blockConditionsPromote;
	var blockConditionsDemote;
	turnOnProgress();
	
	lifecycleview=document.getElementById('calc_'+strRel+'_LifeCycle_'+index);
	relatedObjectTableTR=document.getElementById('calc_'+strRel+'_RelatedItems_'+index);
	blockConditionsPromote=document.getElementById('calc_'+strRel+'_LifeCycle_'+index+'_PromoteConditions');
	blockConditionsDemote=document.getElementById('calc_'+strRel+'_LifeCycle_'+index+'_DemoteConditions');
	
	if(expandImg.getAttribute('toggle')=='closed')
	{
		lifecycleview.setAttribute('style','display: visible');
		if(relatedObjectTableTR)
			relatedObjectTableTR.setAttribute('style','display: visible');
		
		var prevState=blockConditionsPromote.getAttribute('prevState');
		
		blockConditionsPromote.setAttribute('style','display: '+prevState);
		blockConditionsDemote.setAttribute('style','display: '+prevState);

		expandImg.src="images/utilTreeLineNodeOpenSB.gif";
		expandImg.setAttribute('toggle','open');
	}
	else
	{
		lifecycleview.setAttribute('style','display: none');
		if(relatedObjectTableTR)
			relatedObjectTableTR.setAttribute('style','display: none');
		
		var strPrevState=blockConditionsPromote.getAttribute('style');
		if(!strPrevState)
		strPrevState='display: visible';
		blockConditionsPromote.setAttribute('prevState',strPrevState.substring(9));
		
		blockConditionsPromote.setAttribute('style','display: none');
		blockConditionsDemote.setAttribute('style','display: none');
			
		expandImg.src="images/utilTreeLineNodeClosedSB.gif";
		expandImg.setAttribute('toggle','closed');
	}
		
	turnOffProgress();
}

function toggleBlockingView(elem,promoteBlockingConditionField,demoteBlockingConditionField,hideLabel,showLabel){
	if(elem.getAttribute('toggle')=='false'){
		elem.innerHTML=hideLabel;
		elem.setAttribute('toggle','true');
		
		$("#calc_"+promoteBlockingConditionField).fadeIn(300); 
		$("#calc_"+demoteBlockingConditionField).fadeIn(300); 
	}
	else{
		elem.innerHTML=elem.getAttribute("label");
		elem.setAttribute('toggle','false');
		$("#calc_"+promoteBlockingConditionField).fadeOut(300); 
		$("#calc_"+demoteBlockingConditionField).fadeOut(300); 
	}
}

function openActionDialogandRefreshOnClose(url,parentWin){

	var win=showNonModalDialog(url,250,250,true,true);
	$(win).bind("beforeunload", function() { 
             refreshParentWin(parentWin);
	});
}


function refreshParentWin(parentWin) 
{
	var varFrame=findFrame(getTopWindow(),"detailsDisplay");
	varFrame.location.href=varFrame.location.href;
}


function disableParentWin() 
{
     window.document.getElementById('mainDiv').class="disableWin";
}

function getMQLNotices()
{
	var url='../questionnaire/enoQuestionnaireExecute.jsp?mqlNoticeMode=true&validateToken=false';
	emxUICore.getData(url);
}

function getPromoteConditions(objId,promoteField,showHideField)
{
	var url='../questionnaire/enoQuestionnaireExecute.jsp?questionAction=ENOQuestionUI:getPromoteBlockingConditionsHTML&validateToken=false&mqlNoticeMode=true&objectId='+objId;
	var doc=emxUICore.getDataPost(url);
	var promoteBlock=document.getElementById(promoteField);
	var hideConditionsLink=document.getElementById(showHideField);
	var label=hideConditionsLink.getAttribute("label")+"("+doc.substring(0,1)+")";
	hideConditionsLink.setAttribute("label",label);
	
	hideConditionsLink.innerHTML=label;
	promoteBlock.innerHTML= doc.substring(1);
	
}

function getDemoteConditions(objId,demoteField)
{
	var url='../questionnaire/enoQuestionnaireExecute.jsp?questionAction=ENOQuestionUI:getDemoteBlockingConditionsHTML&validateToken=false&mqlNoticeMode=true&objectId='+objId;
	var doc=emxUICore.getDataPost(url);
	var demoteBlock=document.getElementById(demoteField);
	demoteBlock.innerHTML=doc.substring(1);
}

function hideThis()
{	
	$("#calc_JS_Includes").hide(); 
}

