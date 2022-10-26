//=================================================================
// JavaScript Tab Structure
// Netscape 4.x Version
// by Nicholas C. Zakas
//=================================================================

//=================================================================
// Part 1: Tab Control Object Methods
//=================================================================
// This section defines the methods that control the tab control
// and should not be modified in any way.  Doing so could cause
// the tab control to malfunction.
//=================================================================

//-----------------------------------------------------------------
// Function _jsTabControl_draw()
// This function draws the tree.
//
// Parameters:
//	d (jsDocument) - the document object to write to.
//	tab (jstab) - the tab to draw for.
// Returns:
//	nothing.
//-----------------------------------------------------------------
function _jsTabControl_draw() {

	//create string holder
	var d = new jsDocument;
	
	//calculate tabs per strip
	this.tabsPerStrip = parseInt((window.innerWidth - IMG_BTN_MORE.width - IMG_BTN_LESS.width) / this.tabWidth);
	
	//calculate number of strips needed
	var numStrips = Math.ceil(this.tabs.length / this.tabsPerStrip);
	
	//need to create arrays for Netscape 4.x
	this._strips = new Array;
	this._tabs = new Array;

	//draw each strip
	for (i=0; i < numStrips; i++)
		this.createStrip(0 + (this.tabsPerStrip * i), this.tabsPerStrip + (this.tabsPerStrip * i));
}

//-----------------------------------------------------------------
// Method jsTabControl.init()
// This function initializes the tab control to have the given tab
// selected.
//
// Parameters:
//	tabID (String|int) - the tab key for the tab to make selected.
// Returns:
//	nothing.
//-----------------------------------------------------------------
function _jsTabControl_init(tabID) {

	//draw it
	this.draw();

	//get the unique tabID
	var iTabID = this.tabs[tabID].id;
	
	//set all tabs to be off
	for (i=0; i < this.tabs.length; i++)
		if (i == iTabID) {
			this.turnTabOn(i);
			clickTab(i);
			var q = this.getTabStrip(iTabID);
			this.switchTo(q, 0);
		} else
			this.turnTabOff(i);
}


//-----------------------------------------------------------------
// Method _jsTabControl_getTabStrip()
// This function finds which trip a given tab is on.
//
// Parameters:
//	tabID (int) - the ID of the tab to find.
// Returns:
//	The string ID of the tab to find.
//-----------------------------------------------------------------
function _jsTabControl_getTabStrip(tabID) {

	return (Math.floor(tabID / this.tabsPerStrip) ); 

}

//-----------------------------------------------------------------
// Method _jsTabControl_createStrip()
// This function draws a set number of tabs onto a jsDocument.
//
// Parameters:
//	start (int) - the index of the tab to start with.
//	stop (int) - the index of the tab to stop on.
// Returns:
//	nothing.
//-----------------------------------------------------------------
function _jsTabControl_createStrip(start, stop) {
 
	//figure out the strip name and info
	var isFirst = (start == 0);
	var isPrev = (start > 0);
	var isNext = (stop < this.tabs.length);
	var curLeft = 0;
	
	//variables used in DOM-compliant browsers only
	var bodyNode, divStrip;

	//create a new layer
	divStrip = new Layer(this.tabsPerStrip * this.tabWidth);
	
	//move into position
	divStrip.moveTo(this.left, this.top);
	divStrip.resizeTo(((this.tabsPerStrip < this.tabs.length) ? this.tabsPerStrip * this.tabWidth : this.tabs.length * this.tabWidth) + IMG_BTN_MORE.width + IMG_BTN_LESS.width, this.tabHeight);
	divStrip.visibility = (isFirst ? "show" : "hide");

	//add to strips array
	this._strips[this._strips.length] = divStrip;
	
	//check for "less" button
	if (isPrev) {
	
		var dp = new jsDocument;
		
		var divPrev = new Layer(IMG_BTN_LESS.width, divStrip);
		divPrev.moveTo(0,0);
		divPrev.resizeTo(IMG_BTN_LESS.width, IMG_BTN_LESS.height);
		divPrev.visibility = "show";
		
		//write arrow HTML
		dp.write("<a href=\"javascript:localTC.switchTo(");
		dp.write(this._strips.length - 2);
		dp.write(", ");
		dp.write(this._strips.length - 1);
		dp.write(")\"><img src=\"");
		dp.write(IMG_BTN_LESS.filename);
		dp.write("\" border=\"0\"></a>");
		
		//now write to layer
		with (divPrev.document) {
			open();
			write(dp);
			close();
		}
	
		curLeft += IMG_BTN_LESS.width;
	}
	
	//Create all the tab layers
	for (var i=start; i < this.tabs.length && i < stop; i++) {
		var divTab = new Layer(this.tabWidth, divStrip);
		divTab.moveTo(curLeft, 0);
		divTab.resizeTo(this.tabWidth, this.tabHeight);
		divTab.visibility = (isFirst ? "show" : "hide");
		this._tabs[this._tabs.length] = divTab;
		curLeft += this.tabWidth;
	} 

	//check for "more" button
	if (isNext) {
	
		//new string buffer
		var dn = new jsDocument;
		var divNext = new Layer(IMG_BTN_MORE.width, divStrip);
		divNext.moveTo(curLeft, 0);
		divNext.resizeTo(IMG_BTN_MORE.width, IMG_BTN_MORE.height);
		divNext.visibility = "show";

		//write arrow HTML
		dn.write("<a href=\"javascript:localTC.switchTo(");
		dn.write(this._strips.length);
		dn.write(", ");
		dn.write(this._strips.length - 1);
		dn.write(")\"><img src=\"");
		dn.write(IMG_BTN_MORE.filename);
		dn.write("\" border=\"0\"></a>");
		
		//now write to layer
		with (divNext.document) {
			open();
			write(dn);
			close();
		}
		
		curLeft += IMG_BTN_MORE.width;
	}
}

//-----------------------------------------------------------------
// Method _jsTabControl_drawTab()
// This function draws an individual tab onto a jsDocument.
//
// Parameters:
//	d (jsDocument) - the document object to write to.
//	tab (jstab) - tab to draw image for.
//	on (boolean) - is this tab in the on state?
// Returns:
//	nothing.
//-----------------------------------------------------------------
function _jsTabControl_drawTab(d, tab, on) {
	d.write("<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tr><td><img src=\"");
	d.write(on ? IMG_TAB_ON[0].filename : IMG_TAB_OFF[0].filename);
	d.write("\" border=\"0\" height=\"");
	d.write(IMG_TAB_OFF[0].height);
	d.write("\" width=\"");
	d.write(IMG_TAB_OFF[0].width);
	d.write("\" /></td><td class=\"tabText\" width=\"");
	d.write(this.tabWidth - IMG_TAB_OFF[2].width - IMG_TAB_OFF[0].width);
	d.write("\" background=\"");
	d.write(on ? IMG_TAB_ON[1].filename : IMG_TAB_OFF[1].filename);
	d.write("\"><a class=\"tabLink\" href=\"javascript:clickTab(");
	d.write(tab.id);
	d.write(")\">");
	d.write(tab.text);
	d.write("</a></td><td><img src=\"");
	d.write(on ? IMG_TAB_ON[2].filename : IMG_TAB_OFF[2].filename);
	d.write("\" border=\"0\" height=\"");
	d.write(IMG_TAB_OFF[2].height);
	d.write("\" width=\"");
	d.write(IMG_TAB_OFF[2].width);
	d.write("\" /></td></tr></table>");
}


//-----------------------------------------------------------------
// Method jsTabControl.turnTabOn()
// This function switches a tab into the on state given the tabID.
//
// Parameters:
//	tabID (String) - the ID of the tab to act on.
// Returns:
//	nothing.
//-----------------------------------------------------------------	
function _jsTabControl_turnTabOn(tabID) {
		
	//create holder document
	var d = new jsDocument;

	//write the tab to the document
	this.drawTab(d, this.tabs[tabID], true);
		
	//go for it!
	with (this._tabs[tabID].document) {
		open();
		write(d);
		close();
	}
}

//-----------------------------------------------------------------
// Method jsTabControl.turnTabOff()
// This function switches a tab into the off state given the tabID.
//
// Parameters:
//	tabID (String) - the ID of the tab to act on.
// Returns:
//	nothing.
//-----------------------------------------------------------------	
function _jsTabControl_turnTabOff(tabID) {
		
	//create holder document
	var d = new jsDocument;
	
	//write the tab to the document
	this.drawTab(d, this.tabs[tabID], false);

	//go for it!
	with (this._tabs[tabID].document) {
		open();
		write(d);
		close();
	}
}

//-----------------------------------------------------------------
// Method jsTabControl.switchTo()
// This function toggles between the two tab layers.
//
// Parameters:
//	idTo (String) - the ID of the layer to show.
//	idFrom (String) - the ID of the layer to hide.
// Returns:
//	nothing.
//-----------------------------------------------------------------

function _jsTabControl_switchTo(idTo, idFrom) {	
	document.layers[idFrom].visibility = "hide";
	for (var i=0; i < document.layers[idFrom].document.layers.length; i++)
		document.layers[idFrom].document.layers[i].visibility = "hide";
		
	for (var i=0; i < document.layers[idTo].document.layers.length; i++)
		document.layers[idTo].document.layers[i].visibility = "show";
	document.layers[idTo].visibility = "show";		
}

//-----------------------------------------------------------------
// Method jsTabControl.addTab()
// This function adds a tab to the collection.
//
// Parameters:
//	text (String) - the text to be displayed in the tab.
//	url (String) - the url to link to.
// Returns:
//	nothing.
//-----------------------------------------------------------------
function _jsTabControl_addTab(text, url) {
	//add the tab in a numeric slot
	this.tabs[this.tabs.length] = new jsTab(text, url);
	
	//add the tab in a key-based slot
	this.tabs[text] = this.tabs[this.tabs.length-1];
	
	//set the id
	this.tabs[this.tabs.length - 1].id = this.tabs.length - 1;
}	
