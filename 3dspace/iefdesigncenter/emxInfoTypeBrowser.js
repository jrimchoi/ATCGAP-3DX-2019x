/*  emxInfoTypeBrowser.js

   Copyright Dassault Systemes, 1992-2007. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

*/
//=================================================================
// JavaScript Object Browser
// by Nicholas C. Zakas
//=================================================================
// Version 1.1 - April 3, 2001
// - Added option to not select abstract types.
// Version 1.0 - March 1, 2001
// - Works in Netscape 4.x, Netscape 6, and IE 4.0+.
//=================================================================

//=================================================================
// Part 1: Base Objects
//=================================================================
// These objects are used by the tab control for various functions.
// Nothing in this section should be modified or else major errors
// will occur.
//=================================================================

//-----------------------------------------------------------------
// Object jsDocument
// This object is used to eliminate overhead for string concatentation.
//-----------------------------------------------------------------
function jsDocument() {
  this.text = new Array();    //array to store the string
  this.write = function (str) { this.text[this.text.length] = str; }
  this.writeln = function (str) { this.text[this.text.length] = str + "\n"; }
  this.toString = function () { return this.text.join(""); }
  this.writeHTMLHeader = function () {
      this.write("<html><head>");
      for (var i=0; i < arguments.length; i++) {
        this.write("<link rel=\"stylesheet\" href=\"");
        this.write(arguments[i]);
        this.write("\">");
      }
      this.write("</head>");
  }
  this.writeBody = function (style) { this.writeln("<body" + (style ? " class=\"" + style + "\"" : "") + "><form>"); }
  this.writeHTMLFooter = function () { this.writeln("</form></body></html>"); }
}

//local copy of the tree
var localTypeBrowser = null;

//pointer to currently displayed tree
var localTree = null;

//=================================================================
// Part 2: Global Constants
//=================================================================
// This data in this section may be changed in order to customize
// the tab interface.
//=================================================================

//location of the icons
var DIR_ICONS = "images/";
var DIR_TREE = "images/";
var DIR_UTIL = "images/";

//stylesheet
var CSS_FILE = "tree.css";

//tree file
var TREE_FILE = "emxTypeSelectorTree.jsp";

//tree images
var IMG_LINE_VERT = DIR_TREE + "LineVert.gif";
var IMG_LINE_LAST = DIR_TREE + "LineLast.gif";
var IMG_LINE_LAST_OPEN = DIR_TREE + "LineLastOpen.gif";
var IMG_LINE_LAST_CLOSED = DIR_TREE + "LineLastClosed.gif";
var IMG_LINE_NODE = DIR_TREE + "LineNode.gif";
var IMG_LINE_NODE_OPEN = DIR_TREE + "LineNodeOpen.gif";
var IMG_LINE_NODE_CLOSED = DIR_TREE + "LineNodeClosed.gif";

//radio button images
var IMG_RADIO_ON = DIR_TREE + "radioon.gif";
var IMG_RADIO_OFF = DIR_TREE + "radiooff.gif";
var IMG_RADIO_DISABLED = DIR_TREE + "radiooffdisabled.gif";

//checkbox images
var IMG_CHECK_ON = DIR_TREE + "checkon.gif";
var IMG_CHECK_OFF = DIR_TREE + "checkoff.gif";
var IMG_CHECK_DISABLED = DIR_TREE + "checkoffdisabled.gif";

//spacer image
var IMG_SPACER = DIR_UTIL + "utilSpace.gif";

//text/icon for root
var ROOT_NAME = "Types";
var ROOT_ICON = DIR_ICONS + "iconType.gif";

//text/icon for loading node
var LOAD_NAME = "Loading...";
var LOAD_ICON = DIR_ICONS + "iconLoading.gif";

//=================================================================
// Part 3: Type Browser Control Objects and Object Methods
//=================================================================
// This section defines the objects that control the tab control
// and should not be modified in any way.  Doing so could cause
// the tab control to malfunction.
//=================================================================

//-----------------------------------------------------------------
// Object jsTypeBrowser
// This object controls all data about types and subtypes.
//
// Parameters:
//  bAbstractSelect (boolean) - whether you can select abstract types or not.
//-----------------------------------------------------------------
function jsTypeBrowser(bAbstractSelect, bMultiSelect) {

  //can you select abstract types?
  this.abstractSelect = bAbstractSelect;
  this.multiSelect = bMultiSelect || false;

  //the frames
  this.treeFrame = "treeDisplay";

  //the tree
  this.tree = new jsTypeTree();
  
  //methods
  this.getValue = _jsTypeBrowser_getValue;
  
  //save local copy
  localTypeBrowser = this;
}

//-----------------------------------------------------------------
// Method jsTypeBrowser.getValue()
// This method gets the value of the selected item(s) in the tree.
//
// Parameters:
//  none.
// Returns:
//  A string representing the selected items.
//-----------------------------------------------------------------
function _jsTypeBrowser_getValue() {

  if (this.multiSelect) {
    var s = "";
    
    for (key in this.tree.nodeMap) {
      if (this.tree.nodeMap[key].checked)
        s += (s.length > 0 ? "," : "") + this.tree.nodeMap[key].name;
    }
    
    return s;
  } else {
    if (this.tree.selectedNodeID != "-1")
      return this.tree.getNode(this.tree.selectedNodeID).name;
    else
      return "";
  }
}

//-----------------------------------------------------------------
// Object jsTypeTree
// This object represents the tree.
//
// Parameters:
//  none.
//-----------------------------------------------------------------
function jsTypeTree() {

  //the root node of the tree
  this.root = new jsTypeTreeNode(ROOT_NAME, ROOT_ICON);
  this.root.expanded = true;
  this.root.tree = this;
  
  //id of the tree
  this.id = -1;
  
  //map of all tree nodes
  this.nodeMap = new Array;
  this.nodeMap[this.root.name] = this.root;
  
  //selected node
  this.selectedNodeID = this.root.nodeID;
  
  //scrolling information
  this.scrollX = 0;
  this.scrollY = 0;
  
  //methods
  this.draw = _jsTypeTree_draw;
  this.drawChild = _jsTypeTree_drawChild;
  this.drawMiscImages = _jsTypeTree_drawMiscImages;
  this.drawPlusMinusImage = _jsTypeTree_drawPlusMinusImage;
  this.getNode = _jsTypeTree_getNode;
  this.getScrollPosition = _jsTypeTree_getScrollPosition;
  this.refresh = _jsTypeTree_refresh;
  this.setScrollPosition = _jsTypeTree_setScrollPosition;
  this.toggleExpand = _jsTypeTree_toggleExpand;
  
  localTree = this;
}

//-----------------------------------------------------------------
// Function _jsTypeTree_draw()
// This function draws the tree.
//
// Parameters:
//  d (jsDocument) - the document object to write to.
//  node (jsTypeTreeNode) - the node to draw for.
// Returns:
//  nothing.
//-----------------------------------------------------------------
function _jsTypeTree_draw() {

  this.refresh();
}

//-----------------------------------------------------------------
// Method _jsTypeTree_drawChild()
// This function draws an individual node onto a jsDocument.
//
// Parameters:
//  d (jsDocument) - the document object to write to.
//  node (jsTypeTreeNode) - node to draw image for.
// Returns:
//  nothing.
//-----------------------------------------------------------------
function _jsTypeTree_drawChild(d, node) {

  //begin table
  
  d.write("<table border=0 cellspacing=0 cellpadding=0><tr>");
  
  if (node.indent > 0) {
    //determine what needs to be added
    this.drawMiscImages(d, node);
    
    //get whether this node has children and if it's expanded or not
    this.drawPlusMinusImage(d, node);
  }
  
  //the root doesn't need a radio button
  if (node.name != ROOT_NAME && node.name != LOAD_NAME) {
    //draw radio button
    d.write("<td width=\"18\">");
    
    //check to see if this is abstract, it might not be selectable
    if (node.isAbstract && !localTypeBrowser.abstractSelect) {    
      d.write("<img src=\"");
      d.write(localTypeBrowser.multiSelect ? IMG_CHECK_DISABLED : IMG_RADIO_DISABLED);
      d.write("\" />");
    } else {    
      var sChecked="";      
      if(node.checked) sChecked = "checked=\"true\"";

      if (localTypeBrowser.multiSelect) {            	        
        d.write("<a href=\"javascript:parent.clickCheckbox('");
        d.write(node.nodeID);
        d.write("')\"><img src=\"");
        d.write(node.checked ? IMG_CHECK_ON : IMG_CHECK_OFF);
        d.write("\" border=\"0\" /></a>");
      } else {      	      	      	
        d.write("<a href=\"javascript:parent.clickRadio('");
        d.write(node.nodeID);
        d.write("')\"><img src=\"");
        d.write((node.nodeID == this.selectedNodeID) ? IMG_RADIO_ON : IMG_RADIO_OFF);
        d.write("\" border=\"0\" /></a>");
      }
    }
    
    //close cell
    d.write("</td>");
  }

  //begin cell
  
  d.write("<td><img src=\"");  
  //d.write(DIR_ICONS); //Not required for info central Comment added by ShashikantK [Geometric](on 29 Oct 2002)
  						//As the image is displayed using the servlet
  d.write(node.icon);   
  d.write("\" border=\"0\" width=\"16\" height=\"16\" />");
  
  //close link and the cell
  d.write("</td><td nowrap "); 
  
  //determine class 
  if (node.parent == null)
    d.write("class=\"root\" ");
  else if (node.name == LOAD_NAME)
    d.write("class=\"loading\" ");

  //determine class for the text link, this is rough
  d.write(">&nbsp;");
  
  //print the node name
  var nodename = node.name;
  d.write(nodename.substring(nodename.indexOf("|")+1, nodename.length));
  //d.write(node.name);

  //close up link and table
  d.writeln("</td></tr></table>");
  
  //fun part, draw your children!
  if (node.childNodes.length > 0 && node.expanded)
    for (var i=0; i < node.childNodes.length; i++)    	
      this.drawChild(d, node.childNodes[i]);
    
    
  //all done
}

//-----------------------------------------------------------------
// Function _jsTypeTree_drawMiscImages()
// This function draws extra images for the specified node.
//
// Parameters:
//  d (jsDocument) - the document object to write to.
//  node (jsTypeTreeNode) - the node to draw for.
// Returns:
//  nothing.
//-----------------------------------------------------------------
function _jsTypeTree_drawMiscImages(d, node) {
  var str="", tempstr="";
  var cur = node, par = node.parent;
  var i=0;
  
  //no indent needed if root or top level
  if (node.indent < 2)
    return;
    
  //add spacers
  while (i < node.indent - 1) {
  
    //begin cell
    tempstr = "<td class=\"node\"><img src=\"";
    
    if ((cur.isLast && par.isLast) || (!cur.isLast && par.isLast))
      tempstr += IMG_SPACER;
    else
      tempstr += IMG_LINE_VERT;
    tempstr += "\" width=\"19\" height=\"16\" border=\"0\" /></td>"
    
    cur = par;
    par = par.parent;
    i++;
    
    str = tempstr + str;
  }
  
  d.writeln(str);
}

//-----------------------------------------------------------------
// Function _jsTypeTree_drawPlusMinusImage
// This function draws a plus/minus image, or no image, depending on
// the state of the node.
//
// Parameters:
//  d (jsDocument) - the document object to write to.
//  node (jsTypeTreeNode) - node to draw image for.
// Returns:
//  nothing.
//-----------------------------------------------------------------
function _jsTypeTree_drawPlusMinusImage(d, node) {
  var par = node.parent;      //pointer to parent
  
  //begin cell
  d.write("<td>");
  
  //begin link
  if (node.childNodes.length > 0) {
    d.write("<a href=\"javascript:parent.clickPlusMinus('");
    d.write(node.nodeID);
    d.write("')\">");
  }
  
  //nasty part, figure out which graphic to use
  d.write("<img src=\"");
  
  //if this node is the last in the list
  if (node.isLast) {
    if (node.childNodes.length == 0)
      d.write(IMG_LINE_LAST);
    else {
      if (node.expanded)
        d.write(IMG_LINE_LAST_OPEN);
      else
        d.write(IMG_LINE_LAST_CLOSED);  
    }
  } else {
    if (node.childNodes.length == 0)
      d.write(IMG_LINE_NODE);
    else {
      if (node.expanded)
        d.write(IMG_LINE_NODE_OPEN);
      else
        d.write(IMG_LINE_NODE_CLOSED);
    }
  } 
  
   d.write("\" border=\"0\" width=\"19\" height=\"16\" name=\"node");
   d.write(node.nodeID);
   d.write("\">");
  
  if (node.childNodes.length > 0)
    d.write("</a>");
    
  //close up cell
  d.write("</td>");
}

//-----------------------------------------------------------------
// Function _jsTypeTree_getNode()
// This function returns a node with the given nodeID.
//
// Parameters:
//  nodeID - the nodeID of the node to get.
// Returns:
//  nothing.
//-----------------------------------------------------------------
function _jsTypeTree_getNode(nodeID) {

  //if there's no comma, it's not a category
  if (nodeID.indexOf('_') == -1) {
    if (nodeID == "-1")
      return localTree.root;
    else
      return this.root.childNodes[parseInt(nodeID)];
  } else {

    //split the ID into its parts
    var temp = nodeID.split("_");

    //assign pointer to library
    var cur = this.root;
    
    //now cycle through in order to find the node
    for (i=0; i < temp.length; i++) {
      cur = cur.childNodes[parseInt(temp[i])];
    }   
    
    //return the node
    return cur;
  }
}

//-----------------------------------------------------------------
// Function _jsTypeTree_refresh()
// This refreshes the view of the tree.
//
// Parameters:
//  none.
// Returns:
//  nothing.
//-----------------------------------------------------------------
function _jsTypeTree_refresh() {
  
  this.getScrollPosition();
  if(this.scrollY != 0)
	this.scrollY = this.scrollY+260;

  //create string holder
  var d = new jsDocument;

  //write the header
  d.writeHTMLHeader(CSS_FILE);
  d.writeBody("tree");
  
  //draw the root, which will recrusively draw the tree
  this.drawChild(d, this.root);

  //write the footer
  d.writeHTMLFooter();
  
  //draw to the frame
  with (frames[localTypeBrowser.treeFrame].document) {
    open();
    write(d);
    close();
  }
  
  //set the scroll position
  this.setScrollPosition();

}

//-----------------------------------------------------------------
// Method _jsTypeTree_toggleExpand()
// This function expand/collapse a node's children.
//
// Parameters:
//  nodeID (String) - the nodeID of the node to act on.
// Returns:
//  nothing.
//-----------------------------------------------------------------
function _jsTypeTree_toggleExpand(nodeID) {

  //get the node
  var node = this.getNode(nodeID);

  //this.root = node;
  //change the expansion
  node.expanded = !node.expanded;

  //refresh the tree  
  this.refresh(); 
	
  if (!node.loaded) {
    //load the data
    var frm = frames[0].document.forms[0];
    // frm.txtName.value = node.name;
    var nodename = node.name;
    frm.txtName.value = nodename.substring(0,nodename.indexOf("|"));
    frm.submit();
  }
}

//-----------------------------------------------------------------
// Method _jsTypeTreeNode_getScrollPosition()
// This function gets the scrolling position of the window and saves it
// into a local variable.
//
// Parameters:
//  none.
// Returns:
//  nothing.
//-----------------------------------------------------------------
function _jsTypeTree_getScrollPosition() {
    if (document.layers) {
        this.scrollX = frames[localTypeBrowser.treeFrame].pageXOffset;
        this.scrollY = frames[localTypeBrowser.treeFrame].pageYOffset;
    } else if (document.all) {
        this.scrollX = frames[localTypeBrowser.treeFrame].document.body.scrollLeft;
        this.scrollY = frames[localTypeBrowser.treeFrame].document.body.scrollTop;
    }
}

//-----------------------------------------------------------------
// Method _jsTypeTreeNode_setScrollPosition()
// This function sets the scrolling position of the window
//
// Parameters:
//  none.
// Returns:
//  nothing.
//-----------------------------------------------------------------
function _jsTypeTree_setScrollPosition() {
  frames[localTypeBrowser.treeFrame].scrollTo(this.scrollX, this.scrollY);
}

//-----------------------------------------------------------------
// Object jsTypeTreeNode
// This object represents one node on the tree.
//
// Parameters:
//  name (String) - the name of the type.
//  icon (String) - the filename for the type icon.
//  isAbstract (String) - is this type abstract?
//-----------------------------------------------------------------
function jsTypeTreeNode (name, icon, isAbstract, hasChildren) {
  
  //properties
  this.name = name;
  this.icon = icon;
  this.isAbstract = isAbstract || false;
  this.hasChildren = hasChildren || false;
  this.nodeID = "-1";
  this.checked = false;
  this.isLast = false;
  this.tree = null;
  
  this.childNodes = new Array;
  this.loaded = false;
  this.expanded = false;
  this.parent = null;
  this.indent = 0;
  
  //methods
  this.addChild = _jsTypeTreeNode_addChild;
}

//-----------------------------------------------------------------
// Method _jsTypeTreeNode_addChild()
// This function is the event handler for clicking the expand/collapse
// arrow in the discussion.
//
// Parameters:
//  name (String) - the name of the type.
//  icon (String) - the filename for the type icon.
// Returns:
//  nothing.
//-----------------------------------------------------------------
function _jsTypeTreeNode_addChild(name, icon, isAbstract, hasChildren) {

  //create the new node
  
  var node = new jsTypeTreeNode(name, icon || this.icon, isAbstract, hasChildren);

  //add the child to the array
  this.childNodes[this.childNodes.length] = node;
  
  //set the parent
  node.parent = this;
  
  //assign tree
  node.tree = this.tree;
  
  //change the last info
  node.isLast = true;

  if (this.childNodes.length > 1)
    this.childNodes[this.childNodes.length - 2].isLast = false;
  
  //set the indent
  node.indent = this.indent + 1;

  //assign ID
  node.nodeID = (this.nodeID == "-1" ? "" : this.nodeID + "_")  + String(this.childNodes.length - 1);

  //add to tree node map
  this.tree.nodeMap[node.name] = node;
  
  //check for children
  if (node.hasChildren)
    node.addChild(LOAD_NAME, LOAD_ICON);

}



//-----------------------------------------------------------------
// Function clickPlusMinus()
// This function is the event handler for clicking the expand/collapse
// arrow in the discussion.
//
// Parameters:
//  nodeID (String) - the ID of the node to act on.
// Returns:
//  nothing.
// Used as:
//  clickPlusMinus[String]);
//-----------------------------------------------------------------
function clickPlusMinus(nodeID) {

  //get the scroll position
  localTree.getScrollPosition();

  //expand the given node
  localTree.toggleExpand(nodeID);
}

//-----------------------------------------------------------------
// Function clickRadio()
// This function checks the radio button for a given node.
//
// Parameters:
//  nodeID (String) - the ID of the node to act on.
// Returns:
//  nothing.
//-----------------------------------------------------------------
function clickRadio(nodeID) {

  //get the scroll position
  localTree.getScrollPosition();

  //set the selected node
  localTree.selectedNodeID = nodeID;

  //refresh the screen
  localTree.refresh(); 
}

//-----------------------------------------------------------------
// Function clickCheckbox()
// This function checks/unchecks the checkbox for a given node.
//
// Parameters:
//  nodeID (String) - the ID of the node to act on.
// Returns:
//  nothing.
//-----------------------------------------------------------------
function clickCheckbox(nodeID) {
  //get the scroll position
  localTree.getScrollPosition();

  //get the selected node
  var node = localTree.getNode(nodeID);
  
  //toggle the checked state
  node.checked = !node.checked;

  //set the selected node
  if(node.checked)
  {
    localTree.selectedNodeID = nodeID;
  }
  else if (localTypeBrowser.getValue() == "")
  { 
    localTree.selectedNodeID = -1;
  }

  //refresh the screen
  localTree.refresh();
  localTree.setScrollPosition();
}
