<%--
  ECMChangeDependency.jsp
  
  Copyright (c) 2018-2018 Dassault Systemes.
  All Rights Reserved.
  This program contains proprietary and trade secret information of 
  Dassault Systemes.
  Copyright notice is precautionary only and does not evidence any actual
  or intended publication of such program
--%>

<%-- Common Includes --%>

<%@include file = "../emxUICommonAppInclude.inc"%>
<%@include file = "../common/emxUIConstantsInclude.inc"%>

<%@page import="com.matrixone.apps.domain.util.ContextUtil"%>
<%@page import="com.matrixone.apps.domain.util.MqlUtil"%>
<%@page import="com.matrixone.apps.domain.DomainObject"%>
<%@page import = "com.matrixone.apps.domain.DomainConstants"%>


<%
  out.clear();
  String urlStr = "";
  String  strContextID = "";
  String strObjectType = "";
  boolean bIsError = false;
  try
  {
    String objectId = emxGetParameter(request,"objectId");
    DomainObject rootDom = new DomainObject(objectId);
    strContextID = rootDom.getInfo(context, "physicalid");
    strContextID = "pid:" + strContextID;
  }
  catch(Exception e)
  {
    bIsError=true;
    session.putValue("error.message", e.getMessage());
  }// End of main Try-catck block
%>
<html>
<head>
<script type="text/javascript" src="../webapps/AmdLoader/AmdLoader.js"></script>
<link rel="stylesheet" type="text/css" href="../webapps/c/UWA/assets/css/standalone.css" />
<script type="text/javascript" src="../webapps/c/UWA/js/UWA_Standalone_Alone.js"></script>
<script type="text/javascript" src="../webapps/WebappsUtils/WebappsUtils.js"></script>
<script type="text/javascript" src="../webapps/UIKIT/UIKIT.js"></script>
<script language="Javascript" src="../common/scripts/emxUIConstants.js"></script>
<script language="Javascript" src="../common/scripts/emxUICore.js"></script>
<script language="Javascript" src="../common/scripts/emxUIModal.js"></script>
<script type="text/javascript" src="../webapps/PlatformAPI/PlatformAPI.js"></script>
<script type="text/javascript" src="../webapps/ENOChangeActionUX/ENOChangeActionUX.js"></script>

<style type="text/css">
    .tile-title{
        font-size: 15px;
        font-family: '3dsregular' tahoma,serif;
        color: #368ec4;
    }
    .module{
        width:100%;
        height:100%;
        margin: 0;
        border: none;
    }
    .moduleWrapper {
        z-index: inherit;
        zoom: 1;
    }
    .module > .moduleHeader {
        display: none;
    }
    .moduleFooter {
        display: none;
    }
</style>
<script>
    var rootNode;

    function loadDependencyContent()
     {
         if(rootNode)
         {
             getTopWindow().window.close();
         }
         else
         {   
             require(['DS/PlatformAPI/PlatformAPI',
                      'DS/ENOChangeActionUX/scripts/Models/CAModel',
                      'DS/ENOChangeActionUX/scripts/Views/CADependeciesView',
                      'DS/ENOChangeActionUX/scripts/CAWidgetConfiguration',
                      'DS/ENOChangeActionUX/scripts/ChangeAction',
                      'DS/ENOChangeActionUX/scripts/CASpinner',
                      'DS/ENOChangeActionUX/scripts/CAUtility',
                      ],
                     function(PlatformAPI, CAModel, CADependeciesView,CAWidgetConfiguration, ChangeAction, CASpinner, CAUtility){
                 
                 WidgetUwaUtils.setupEnoviaServer();
		         window.enoviaServer.widgetName = "ChangeActionManagement";
		         window.enoviaServer.widgetId = window.widget.id;
		         window.enoviaServer.tenant = widget.getValue("x3dPlatformId") ? widget.getValue("x3dPlatformId") : 'OnPremise';
				 
				 var e6wUrl = widget.getUrl(),
                 runYourApp = widget.getUrl().match(/[?&]runYourApp=([^&]*)?/), //override myapps url.
                 myAppsUrl = PlatformAPI.getApplicationConfiguration('app.urls.myapps'),
                 proxy = (window.UWA.Data.proxies["passport"] ? "passport" : "ajax"), 
                 e6wUrl = e6wUrl.substring(0, e6wUrl.indexOf('/enterprisechangemgt'));
                 if (!myAppsUrl || runYourApp) {
                    var myAppsUrl = e6wUrl;
                 }
                 var curTenant = "";
                <%
                    if(!FrameworkUtil.isOnPremise(context)){
                %>
                    curTenant = "<%=XSSUtil.encodeForJavaScript(context, context.getTenant())%>";
                <%
                    }
                %>
                 
                 window.enoviaServerCAWidget = {
                    sRealURL: e6wUrl,
                    storageUrl: myAppsUrl,
					baseURL: "",
                    myRole: "",
                    proxy: "passport",
                    _getUrl: function() {
                        this.baseURL = this.sRealURL ||  this.storageUrl;
						return this.baseURL;
                    },
                    computeUrl: function (relativeURL) {
                        return this._getUrl() + relativeURL;
                    },
                    getSecurityContext: function () {
                        return this.mySecurityContext;
                    },
                    getRole: function () {
                        return this.myRole;
                    },
                    is3DSpace: true,
                    wsCallTimeout: 30000,
                    mySecurityContext: "",
                    UXPref : "New",
                    arrOid: [],
                    InterCom: UWA.Utils.InterCom,
                    compassSocket: null,
                    prefIntercomServer: null,
                    compassSocketName: "",
                    prefSocketName: "",
                    collabspace: "",
                    tenant:curTenant,
                 };
                 var randomName = "wdg_" + new Date().getTime();
                 CAWidgetConfiguration.setupIntercomConnections.call(this, widget, enoviaServerCAWidget, randomName);
                 widget.body.setStyle("min-height", "50px");
                 CASpinner.doWait(widget.body);
                 ChangeAction.populateSecurityContext()
                    .then(function (securityContextDetails){
                        
                        var caModel = new CAModel({
                             'id': '<%=strContextID%>',
                             lifecycleHTML: "<span id ='lifecycleSpan'></span>"
                        });
                        var options = {};
                        var physicalID = '<%=strContextID%>';
						var promisesArr = [];
						var promiseForUserAccess;
						var promiseForDependAccess = CAUtility.getDependUserAccess(physicalID);
                        var promiseForDependencyInfo = CAUtility.getCADependencies(physicalID);
						promisesArr.push(promiseForDependAccess, promiseForDependencyInfo);
						Promise.all(promisesArr)
						.then(function(resp){
							resp.forEach(function(respEach){
								if ((respEach) && UWA.is(respEach.dependUserAccess)) {
                                         caModel.set("dependUserAccess", respEach.dependUserAccess);
                                }
								else if ((respEach) && UWA.is(respEach.elements)) {
                                    console.log('Dependency retrieval successful');
									if(physicalID === respEach.originid){
										var dependencyElem = CAUtility.buildDependencyModel(respEach.elements, respEach.originid);
										caModel.set('dependencyObjects', dependencyElem);
										setTimeout(function(){
											var Content = new UWA.createElement('div', {
												'id': 'main-container',
												styles: { height: '100%', width: '100%', display: 'flex' },
												html: [
												  {
													  tag: 'div',
													  id: 'skeleton-container',
													  styles: { height: '100%', width: '100%' }
												  },
												  {
													  tag: 'div',
													  id: 'slidein-container',
													  styles: { height: '100%', width: '0', position: 'fixed', zIndex: '1', top: '0', right: '0', overflowX: 'hidden', transition: '.5s', borderLeft: '0 solid #d1d4d4', background: 'white' }
												  }
												]
											}); 
											var maincontainer = document.getElementById('maincontainer');
											maincontainer.appendChild(Content);
											var skeletonContainer = Content.getElement("#skeleton-container");
											var realizedViewMainContainerElem = document.getElementById('dependencyViewMainContainer');
											var realizedviewContainerDivelem = UWA.createElement('div', {
													 'class' : 'divElem', 
													 'id' : 'realizedViewContainer',
													 'styles' : {
														 'height' : '100%',
														 'width': '100%'
													 }
											});
											skeletonContainer.appendChild(realizedViewMainContainerElem);
											realizedViewMainContainerElem.appendChild(realizedviewContainerDivelem);
											var options = { model: caModel };
											var descrtipView = new CADependeciesView(options);
											descrtipView.model = caModel;
											descrtipView.container = realizedviewContainerDivelem;
											descrtipView.render();
											CASpinner.endWait(widget.body);
										}, 1000);
									}     
                                }
							});
						},
						function(error){
							console.log("failed");
                            return Promise.reject(error);
						});
						/*CAUtility.getCADependencies(physicalID).then(function(resp){
                            console.log('Dependency retrieval successful');
                            if(physicalID === resp.originid){
                                var dependencyElem = CAUtility.buildDependencyModel(resp.elements, resp.originid);
                                caModel.set('dependencyObjects', dependencyElem);
                                setTimeout(function(){
                                    var Content = new UWA.createElement('div', {
                                        'id': 'main-container',
                                        styles: { height: '100%', width: '100%', display: 'flex' },
                                        html: [
                                          {
                                              tag: 'div',
                                              id: 'skeleton-container',
                                              styles: { height: '100%', width: '100%' }
                                          },
                                          {
                                              tag: 'div',
                                              id: 'slidein-container',
                                              styles: { height: '100%', width: '0', position: 'fixed', zIndex: '1', top: '0', right: '0', overflowX: 'hidden', transition: '.5s', borderLeft: '0 solid #d1d4d4', background: 'white' }
                                          }
                                        ]
                                    }); 
                                    var maincontainer = document.getElementById('maincontainer');
                                    maincontainer.appendChild(Content);
                                    var skeletonContainer = Content.getElement("#skeleton-container");
                                    var realizedViewMainContainerElem = document.getElementById('dependencyViewMainContainer');
                                    var realizedviewContainerDivelem = UWA.createElement('div', {
                                             'class' : 'divElem', 
                                             'id' : 'realizedViewContainer',
                                             'styles' : {
                                                 'height' : '100%',
                                                 'width': '100%'
                                             }
                                    });
                                    skeletonContainer.appendChild(realizedViewMainContainerElem);
                                    realizedViewMainContainerElem.appendChild(realizedviewContainerDivelem);
                                    var options = { model: caModel };
                                    var descrtipView = new CADependeciesView(options);
                                    descrtipView.model = caModel;
                                    descrtipView.container = realizedviewContainerDivelem;
                                    descrtipView.render();
                                    CASpinner.endWait(widget.body);
                                }, 1000);
                            }
                        },
                        function(error){
                            console.log("CA Dependency retrieval failed");
                            CASpinner.endWait(widget.body);
                            return Promise.reject(error);
                        });*/
                    },
                    function(error){
                        console.log("Populate Security Context failed");
                        CASpinner.endWait(widget.body);
                        return Promise.reject(error);
                 });
             });
         }
     }
    
</script>
</head>
<body onLoad = "loadDependencyContent();" style="overflow:hidden;">
<div id="maincontainer"></div>
<div id="dependencyViewMainContainer"></div>
</body>
</html>  
