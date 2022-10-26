<%@include file = "../common/emxNavigatorInclude.inc"%>

<%@ page import="com.matrixone.infra.ws.keymgt.v2.CredentialSet.*"%>
<%@ page import="com.matrixone.infra.ws.keymgt.v2.ServiceKey.*"%>
<%@ page import="com.matrixone.infra.ws.keymgt.v2.holders.ServiceKeyHolder.*"%>
<%@ page import="com.matrixone.infra.ws.keymgt.v2.impl.V2KeyService.*"%>

<%--
    Document   : gapDownloadZipUtility.jsp
    Author     : ENGMASA
    Modified :  19/10/2010 -> New UI (New WS spec)
                26/05/2011 -> Replace Post by GEt for AIX
--%>
                <html>  
                <HEAD>
                    <script src="scripts/emxUIAdminConsoleUtil.js"></script>
                    <link rel=stylesheet type="text/css" href="styles/emxUIPlmOnline.css">
                </HEAD>
                <%  
                        String target = "gapDownloadZipSearchForm.jsp";
                       
                %>   
                	<FRAMESET name="frameRow" id="frameRow" framespacing="1" rows="100"> 
                		<FRAMESET style="height:100%" name="frameCol" id="frameCol" cols="100,0">  
                			<FRAME style=" margin-top: 4% ; border: 0px" width="100%" height="98%" name="sommaire" id="sommaire" target="Topos" src="<%=target%>" scrolling="auto">
                			<FRAME name="Topos" id="Topos" src="" scrolling="auto" > 
                		</FRAMESET>
                		<FRAMESET >
                    		<FRAME name="banniere" id="banniere" scrolling="auto" target="sommaire" src="" marginwidth="0" marginheight="0">
                		</FRAMESET>
                		<NOFRAMES> 
                		<P>Cette page utilise des cadres, mais votre navigateur ne les prend pas 
                		en charge.</p> 
                		</NOFRAMES>
                	</FRAMESET>
                
                </html>
