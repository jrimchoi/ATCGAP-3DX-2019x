<%--
*!================================================================
 *  JavaScript Form Validaion
 * NCRFormValidation.jsp
 *
 *  Copyright (c) 1992-2018 Dassault Systemes. All Rights Reserved.
 *  This program contains proprietary and trade secret information
 *  of MatrixOne,Inc. Copyright notice is precautionary only
 *  and does not evidence any actual or intended publication of such program
 *
 *=================================================================
 *
--%>

<jsp:include page="../enterprisechangemgtapp/ECMCreateFormValidation.jsp" />
<%@page import="matrix.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.matrixone.apps.domain.util.*"%>
<%@page import="com.dassault_systemes.enovia.lsa.Helper"%>
<%@page import ="com.matrixone.servlet.Framework"%>
<% matrix.db.Context context = Framework.getFrameContext(session); %>
<%@include file = "../emxContentTypeInclude.inc"%>

function reloadSupplierLocationFormPQCNCRCreate()
{
	emxFormReloadField("attribute_NCRSupplierLocation");
}
function makeSupplierMandatory()
{
	var fieldvalue= $("#attribute_NCRDefectTypeId").val();
	if(fieldvalue=='External')
	{
		$("[for='attribute_NCRSiteFound']").addClass("createLabelRequired");
		$("[for='attribute_NCRSupplier']").addClass("createLabelRequired");
		$("[for='attribute_NCRSupplierLocation']").addClass("createLabelRequired");
		//$("[name='attribute_NCRSiteFoundDisplay']").attr("required","required");
	}
	else if(fieldvalue=='Internal')
	{
		$("[for='attribute_NCRSiteFound']").removeClass("createLabelRequired");
		$("[for='attribute_NCRSupplier']").removeClass("createLabelRequired");
		$("[for='attribute_NCRSupplierLocation']").removeClass("createLabelRequired");
	}
}
//Function to set TotalQuatity UOM values to other two UOM fields
function reloadDefectiveAndSampleQtyUOMFormPQCNCRProductControlAdd()
{
    var fieldTotalQtyUOM = document.getElementsByName("TotalQtyUOM")[0];
	var FieldValue=fieldTotalQtyUOM.value;

	var fieldDefectiveQtyUOM = document.getElementsByName("DefectiveQtyUOM")[0];
	fieldDefectiveQtyUOM.value=FieldValue;
	fieldDefectiveQtyUOM.disabled = true;

	var fieldSampleSizeUOM = document.getElementsByName("SampleQtyUOM")[0];
    fieldSampleSizeUOM.value=FieldValue;
	fieldSampleSizeUOM.disabled = true;
}

