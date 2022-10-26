/*  emxDSCWorkspaceMgmtTree.js

   Copyright Dassault Systemes, 1992-2007. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program
*/
/*
  Class definitions based on emxUICoreTree for workspace management
 

   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxDSCWorkspaceMgmtTree.js 1.3.1.3.1.1 Mon Oct 20 10:10:32 2008 GMT ds-unamagiri Experimental$
*/


//---------------------------------------------------------------------------------
// emxDSCWorkspaceMgmtTree
//---------------------------------------------------------------------------------     

function emxDSCWorkspaceMgmtTree(strID) {
        this.superclass = emxUICoreTree;
        this.superclass(strID);
        delete this.superclass;

        this.showIcons = true;                          

        //---------------------------------------------------------------------------------
        // Private Properties
        //---------------------------------------------------------------------------------     
        this.className = "emxDSCWorkspaceMgmtTree";                            
} 
emxDSCWorkspaceMgmtTree.prototype = new emxUICoreTree;

// setSelectedNode
emxDSCWorkspaceMgmtTree.prototype.setSelectedNode = function _emxDSCWorkspaceMgmtTree_setSelectedNode(objNode, blnRefresh) {
        if (!this.processing)
		{
                this.selectedID = objNode.nodeID;
                if (blnRefresh)
				{
                        this.refresh(true);
                } 
        } 
}

// getSelectedNode
emxDSCWorkspaceMgmtTree.prototype.getSelectedNode = function _emxDSCWorkspaceMgmtTree_getSelectedNode(objNode)
{
        return this.nodes[this.selectedID];
}

//---------------------------------------------------------------------------------
// emxDSCWorkspaceMgmtTreeNode
//---------------------------------------------------------------------------------     

function emxDSCWorkspaceMgmtTreeNode (strIcon, strSelectedIcon, strIcon2, strText, strURL, strTarget, strURL2, strExpandURL) {
/* 
   Args:
      strIcon           - path relative to DIR_SMALL_ICONS to the node icon or null for none
      strSelectedIcon   - path as above to the icon shown when the node is selected
      strIcon2          - icon for optional trailing icon (path specifics are same as above)
      strText           - text to display
      strURL            - URL when node is selected
      strTarget         - Target frame for strURL or null to display in a modal popup
      strURL2           - URL when icon2 is selected (will always be displayed in a modal popup)
      strExpandURL      - See emxUICoreTreeLoadNode
*/

        this.superclass = emxUICoreTreeLoadNode;
        this.superclass(strIcon, strText, (strExpandURL == "null" || strExpandURL == ""? null : strExpandURL));
        delete this.superclass;
        this.className = "emxDSCWorkspaceMgmtTreeNode";
        this.icon2 = (strIcon2 == "null" || strIcon2 == ""? null : strIcon2);
        this.url = strURL;             
        this.url2 = strURL2;
        this.commandName = null;                
        this.target = (strTarget == "null" || strTarget == ""? null : strTarget);
        this.selectedIcon = getIcon(strSelectedIcon);

        //---------------------------------------------------------------------------------
        // Private Properties
        //---------------------------------------------------------------------------------     
        this.className = "emxUIStructureTreeNode";

}
emxDSCWorkspaceMgmtTreeNode.prototype = new emxUICoreTreeLoadNode;

// getNodeHTML
emxDSCWorkspaceMgmtTreeNode.prototype.getNodeHTML = function _emxUIHistoryTreeNode_getNodeHTML()
{
        var d		= new jsDocument;
        var strLoc	= (top.trees && top.trees[this.tree.id]) ? "top" : "parent";
         // Render icon
        if(this.tree.showIcons && this.icon != null){
                d.write("<td nowrap=\"nowrap\">");
                d.write("<a href=\"javascript:" + strLoc + ".trees['");
                d.write(this.tree.id);
                d.write("'].nodes['");
                d.write(this.nodeID);
                d.write("'].handleClick('icon')\">");
                d.write("<img src=\"");
                var icon = (this.tree.getSelectedNode() == this) ? this.selectedIcon : this.icon;
                d.write(icon);
                d.write("\" border=\"0\" />");
                d.write("</a>");
                d.write("</td>");
        } 

        // Render node text (special case the root node)
        if (this.tree.root == this)
        {
           d.write("<td nowrap=\"nowrap\" class=\"");
           d.write(this.cssClass);
           d.write("\">&nbsp;");
           d.write(this.htmltext);
           d.writeln("</a>&nbsp;</td>");
        }
        else
        {
        d.write("<td nowrap=\"nowrap\" class=\"");
        d.write(this.cssClass);
        d.write("\">&nbsp;");
        d.write("<a href=\"javascript:" + strLoc + ".trees['");
        d.write(this.tree.id);
        d.write("'].nodes['");
        d.write(this.nodeID);
        d.write("'].handleClick('text')\">");
        if (this.tree.getSelectedNode() == this) d.write("<b>");
        d.write(this.htmltext);
        if (this.tree.getSelectedNode() == this) d.write("</b>");
        d.writeln("</a>&nbsp;</td>");
        }
      
        // Render second (trailing) icon
        if(this.tree.showIcons && this.icon2 != null){

                d.write("<td nowrap=\"nowrap\">");
                d.write("<a href=\"javascript:" + strLoc + ".trees['");
                d.write(this.tree.id);
                d.write("'].nodes['");
                d.write(this.nodeID);
                d.write("'].handleClick('icon2')\">");
                d.write("<img src=\"");
                d.write(this.icon2);
                d.write("\" border=\"0\" />");
                d.write("</a>");
                d.write("</td>");
        } 
      
        return d.toString();
}

// handleClick
emxDSCWorkspaceMgmtTreeNode.prototype.emxUICoreTreeNodeHandleClick = emxDSCWorkspaceMgmtTreeNode.prototype.handleClick;
emxDSCWorkspaceMgmtTreeNode.prototype.handleClick = function _emxDSCWorkspaceMgmtTreeNode_handleClick(strTarget) {
        switch(strTarget)
		{
                case "icon":
                case "text":
                        if (this.url != null)
                           if (this.target != null)
                           {
                              this.tree.link(this.url, this.target);
                              this.tree.setSelectedNode(this, true);  // Only change selection if displayed in the target frame
                           }
                           else
                           {
                              showNonModalDialog(this.url, 640, 600);
                           }
                        break;
                case "icon2":
                        if (this.url2 != null) showNonModalDialog(this.url2, 640, 600);
                        break;
                
                default:
                        this.emxUICoreTreeNodeHandleClick(strTarget);
                        break;
       } 
}

