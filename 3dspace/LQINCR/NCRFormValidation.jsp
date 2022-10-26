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

<jsp:include page="../Complaints/ComplaintsFormValidation.jsp" flush="true"/>
<%@page import="matrix.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.matrixone.apps.domain.util.*"%>
<%@page import="com.dassault_systemes.enovia.lsa.Helper"%>
<%@page import ="com.matrixone.servlet.Framework"%>
<%@include file = "../emxContentTypeInclude.inc"%>
<% matrix.db.Context context = Framework.getFrameContext(session); %>

<script language="javascript">

function reloadSupplierLocationFormPQCNCRCreate()
{
	emxFormReloadField("attribute_NCRSupplierLocation");
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

//Function to Calculate percentage
function setDefaultPercentage()
{
  var fieldTotalQty = document.getElementsByName("TotalQty")[0];
	var FieldValueTotal = fieldTotalQty.value * 1;
	//Setting value
	var fieldDefectiveQty = document.getElementsByName("DefectiveQty")[0];
	var FieldValueDefective = fieldDefectiveQty.value * 1;
	var percentage = 0
	//Setting the vlue
	if(FieldValueTotal != 0 && FieldValueDefective != 0)
		percentage=((FieldValueDefective/FieldValueTotal)*100);

	var fieldDefectRate = document.getElementsByName("DefectRate")[0];
  fieldDefectRate.value = percentage;
  fieldDefectRate.disabled = true;
}

</script>
