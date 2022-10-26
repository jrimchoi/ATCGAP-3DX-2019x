<%-- 
    Document   : drCascaseForm
    Created on : 02-Jul-2013, 10:10:03
    Author     : farhana
--%>

    <%@page contentType="text/html" pageEncoding="UTF-8"%>
        <%@ taglib prefix="s" uri="/struts-tags" %>
            <%@taglib uri="/WEB-INF/drv6toolsHTML.tld" prefix="drCore"%>
                <!DOCTYPE html>
                <html>

                <drCore:drPageTagHandler pageHeader="drV6Tools.cascade.cascadecompletedform.title" cancelLabel="Close" cancelButtonImgSrc="../common/images/buttonDialogCancel.gif" cancelAction="javascript:closeWindow();">

                    <head>

                        <meta http-equiv="X-UA-Compatible" content="IE=8" />
                        <title><s:property value="getText('drV6Tools.cascade.cascadeform.title')" /></title>
                        <link rel="stylesheet" type="text/css" href="../common/styles/emxUIDefault.css" />
                        <link rel="stylesheet" type="text/css" href="../common/styles/emxUIForm.css" />
                        <link rel="stylesheet" type="text/css" href="../common/styles/emxUIDialog.css" />
                        <link rel="stylesheet" type="text/css" href="../common/styles/emxUIToolbar.css" />
                        <link rel="stylesheet" type="text/css" href="../common/styles/emxUIDOMLayout.css" />
                        <script type="text/javascript" src="../common/scripts/emxUISlideIn.js"></script>
                        <script type="text/javascript" src="../drV6Tools/cascade/js/drCascadeUtil.js"></script>
                        <script type="text/javascript" src="../drV6Tools/common/js/jquery-1.9.1.js"></script>
                        <script type="text/javascript" src="../drV6Tools/common/js/json.js"></script>
                        <script type="text/javascript">
                            var targetLocation = '<s:property value="windowType" />';
                            var bolReload = '<s:property value="refreshTable" />';
                            var errorMessage = '<s:property value="errorMsg"/>';
                            var operationPerformed = '<s:property value="operationPerformed"/>';
                            var json = '<s:property value="json" escape="false" escapeJavaScript="true"/>';
                            var showObject = false;
                            var closeChildWindow = false;

                            $(document).ready(function() {
                                if (operationPerformed == "range") {
                                    showObject = false;
                                    rangeSubmit(json);
                                }


                                if (errorMessage == '' || errorMessage == null) {
                                    refreshWindow();
                                    if (operationPerformed == "Update") {
                                        closeWindow();
                                    }

                                }


                            });



                            function closeWindow() {



                                if (targetLocation === "slidein") {
                                    top.closeSlideInDialog();

                                } else if (targetLocation === "card" || targetLocation === "sidepanel") { // used if tvc installed				 
                                    parent.tvc.inlineFrame.close();


                                } else {
                                    // targte location popup								
                                    if (top.opener) {
                                        top.close();
                                    }

                                }

                            }


                            function reloadParent(parentToReferesh, bolReloadTable, bolShowObject) {

                                if (bolReloadTable == true) {
                                    if (parentToReferesh != null) {
                                        parentToReferesh.location.reload();
                                    }

                                }
                                if (bolShowObject == true) {
                                    if (parentToReferesh != null && parentToReferesh.frames['content'] != null) {
                                        parentToReferesh.frames['content'].location.href = "../common/emxTree.jsp?objectId=<s:property value='objectID'/>";
                                    }
                                }

                            }

                            function refreshWindow() {

                                var parentType;

                                if (bolReload == "true") {
                                    parentType = "Table";
                                } else {
                                    parentType = "TopMenu";
                                }


                                if (parentType == "Table") {
                                    if (targetLocation === "slidein") {
                                        reloadParent(this.parent.frames['content'], true, showObject);
                                    } else if (targetLocation === "card" || targetLocation === "sidepanel") { // used if tvc installed
                                        if (parent.tableContentFrame != null) {
                                            parent.tableContentFrame.tvcReloadTableContent();
                                        }


                                    } else {
                                        // targte location popup								
                                        if (top.opener) {
                                            reloadParent(this.parent.opener, true, showObject);
                                        }

                                    }
                                }

                                if (parentType == "TopMenu") {
                                    if (targetLocation === "slidein") {
                                        top.closeSlideInDialog();
                                        showObject = true;
                                        reloadParent(this.parent, false, showObject);

                                    } else if (targetLocation === "card" || targetLocation === "sidepanel") { // used if tvc installed								
                                        if (parent.tableContentFrame != null) {
                                            parent.tableContentFrame.tvcReloadTableContent();
                                        } else {
                                            parent.tvcReloadPage();
                                        }


                                    } else {
                                        // targte location popup								
                                        if (top.opener) {
                                            top.close();
                                            reloadParent(this.parent.opener, false, showObject);
                                        }

                                    }
                                }

                            }

                            function openObject() {
                                if (targetLocation === "slidein") {
                                    this.parent.frames['content'].location.href = "../common/emxTree.jsp?objectId=<s:property value='objectID'/>";
                                } else if (targetLocation === "card" || targetLocation === "sidepanel") { // used if tvc installed		
                                    this.location.href = "../common/emxTree.jsp?objectId=<s:property value='objectID'/>";

                                } else {
                                    // targte location popup								
                                    if (top.opener) {
                                        this.parent.opener.location.href = "../common/emxTree.jsp?objectId=<s:property value='objectID'/>";
                                    }

                                }

                                closeWindow();
                            }                           
                        </script>

                    </head>

                    <body>
                        <form id="form1">
                            <div id="divPageBody">

                                <table border="1" width="100%" cellspacing="0" cellpadding="3" id="formTable">
                                    <tr class="fieldContainer">

                                    </tr>
                                    <tr class="fieldContainer">
                                        <td class="label">

                                            <s:property value="operationPerformed" />

                                        </td>
                                    </tr>
                                    <tr class="fieldContainer">


                                        <s:if test="%{errorMsg==null || errorMsg==''}">
                                            <td class="label">
                                                <s:property value="getText('drV6Tools.cascade.cascadecompletedform.completed')" />
                                            </td>
                                        </s:if>
                                        <s:else>
                                            <td class="labelRequired">
                                                <s:property value="getText('drV6Tools.cascade.cascadecompletedform.errored')" />
                                            </td>
                                        </s:else>


                                    </tr>

                                    <tr class="fieldContainer">
                                        <td class="label">



                                            <a href="#" onclick="javascript:openObject();"><s:property value="objectTNR" /></a>
                                        </td>
                                    </tr>

                                    <tr class="fieldContainer"></tr>
                                    <tr class="fieldContainer">
                                        <td class="labelRequired">

                                            <s:property value="errorMsg" />
                                        </td>

                                    </tr>
                                    <tr class="fieldContainer">
                                        <td class="labelRequired">
                                            <s:property value="fullErrorMsg" />
                                        </td>
                                    </tr>
                                </table>




                            </div>
                        </form>
                    </body>
                </drCore:drPageTagHandler>

                </html>