var parentObjectId="";
var drCascadeActivityName="";
var drRunCascadeforFileExtensions="";
var drRunCascade = true;
var drCascadeTargetLocation="";


function drFileDragHover(e, id) {
	e.stopPropagation();
	e.preventDefault();
	var div = document.getElementById(id);
	if(e.type == "dragover") 	{ div.className = "dropTarget";		}
	else if(e.type == "drop")	{ div.className = "dropProgress";	}
	else 						{ div.className = "dropArea";		}
}

function drFileSelectHandlerHeader(cascadeActivityName,runCascadeforFileExtensions,cascadeTargetLocation,e, idTarget, idForm, idDiv, refresh, relationships) {
	parentObjectId = idTarget;
	drFileDragHover(e, idDiv);
	drCascadeActivityName = cascadeActivityName;
	drRunCascadeforFileExtensions = runCascadeforFileExtensions;
	drCascadeTargetLocation = cascadeTargetLocation;
	drFileSelectHandler(e, idTarget, idForm, idDiv, refresh, "", "", "", "", relationships, "", "", "", "", "dropArea");
}

function drFileSelectHandler(e, idTarget, idForm, idDiv, refresh, levelTarget, parentDrop, typeDrop, types, relationships, attributes,
		directions,typesStructure,validator, dropZoneClass) {

	e.preventDefault();
	e.stopPropagation();

	var webApp = "webApplication";
	var OS = "OperatingSystem";

	var files = e.target.files || e.dataTransfer.files;
	var dragFrom = (files.length == 0) ? webApp : OS;
	if(dragFrom == webApp) {
		var data		= e.dataTransfer.getData("Text");
		var params 		= data.split("_param=");
		var idDiv 		= params[1];
		var idDrag 		= params[2];
		var relDrag		= params[3];
		var levelDrag	= params[4];
		var parentDrag	= params[5];
		var typeDrag	= params[6];
		var kindDrag	= params[7];
		var refSave		= refresh;

		var inputs = {
				targetObjectId: idTarget,
				targetObjectLevel: levelTarget,
				targetObjectType: typeDrop,

				draggedObjectId: idDrag,
				draggedObjectLevel: levelDrag,
				draggedObjectType: typeDrag
		};

		var isValidated = validate(validator, inputs);
		if(isValidated.status === "error"){
			var level = refresh.substring(10);

			if((refresh.indexOf(".refreshRow") != -1)) {
				level = level.replace(".refreshRow", "");
				emxEditableTable.refreshRowByRowId(level);
			} else {
				level = level.replace(".expandRow", "");
				emxEditableTable.refreshRowByRowId(level);
			}
			return;
		}else if(isValidated.status === "success"){
		if(idDiv != idDrag) {

			var frameElement;
			var ctrlKey = "false";
			if(e.ctrlKey) { ctrlKey = "true"; }

			if(refresh.indexOf("id[level]=") == -1) {
				refresh = "header";
				frameElement = top.document.getElementById("hiddenFrame");
			} else {
				frameElement = document.getElementById("listHidden");
			}

			var url = "../common/emxColumnDropProcess.jsp?idDrag=" + idDrag +
				"&idTarget=" + idTarget +
				"&relDrag=" + relDrag +
				"&levelDrag=" + levelDrag +
				"&levelTarget=" + levelTarget +
				"&parentDrag=" + parentDrag +
				"&parentDrop=" + parentDrop +
				"&typeDrag=" + typeDrag +
				"&kindDrag=" + kindDrag +
				"&typeDrop=" + typeDrop +
				"&relType=" +
				"&types=" + types +
				"&relationships=" + relationships +
				"&attributes=" + attributes +
				"&directions=" + directions +
				"&refresh=" + refresh +
				"&ctrlKey=" + ctrlKey +
				"&typesStructure=" + typesStructure;
			frameElement.src = url;	;

			if(refresh.indexOf("id[level]=") == -1) {
				refreshPageHeader(refSave);
			}
		}

		var div = document.getElementById(idDiv);
		div.className = "dropAreaColumn";
		}

	} else {
		var restrictedFileFormats = emxUIConstants.RESTRICTED_FILE_FORMATS;
		var supportedFileFormats = emxUIConstants.SUPPORTED_FILE_FORMATS;
		restrictedFileFormats = restrictedFileFormats.toLowerCase();
		supportedFileFormats = supportedFileFormats.toLowerCase();

		var restrictedFileFormatArr = restrictedFileFormats.split(",");
	    var supportedFileFormatArr;

	    if(supportedFileFormats != ""){
	    	supportedFileFormatArr = supportedFileFormats.split(",");
	    }
		
	    for (var i = 0, ff; ff = files[i]; i++) {
	    	 var fileName = ff.name;
	    	 var badchar=emxUIConstants.FILENAME_BAD_CHARACTERS;
	    	 badchar = badchar.split(" ");
	    	 var badCharName = checkStringForChars(fileName,badchar,false);
	    	    if (badCharName.length != 0)
	    	    {
	    	        alert(emxUIConstants.INVALID_FILENAME_INPUTCHAR + badCharName + emxUIConstants.FILENAME_CHAR_NOTALLOWED + emxUIConstants.FILENAME_BAD_CHARACTERS + emxUIConstants.FILENAME_INVALIDCHAR_ALERT);
	    	        document.getElementById(idDiv).className = dropZoneClass;
	    	        return;
	    	    }
	    	 var fileExt = fileName.substring(fileName.lastIndexOf(".")+1, fileName.length);

	    	 if(jQuery.inArray(fileExt.toLowerCase(), restrictedFileFormatArr) >= 0){
	    		 alert(emxUIConstants.RESTRICTED_FORMATS_ALERT + restrictedFileFormats);
	    		 document.getElementById(idDiv).className = dropZoneClass;
	    		 return;
	    	 }
			 
			 
			 

	    	 if( supportedFileFormatArr && jQuery.inArray(fileExt.toLowerCase(), supportedFileFormatArr) < 0){
	    		 alert(emxUIConstants.SUPPORTED_FORMATS_ALERT + supportedFileFormats);
	    		 document.getElementById(idDiv).className = dropZoneClass;
		    	 return;
	    	 }
			 
			
		}

		var divHeight		= 60;
		var div 			= document.getElementById(idDiv);
		div.style.padding 	= "0px";
		var filesSize 		= 0;
		var filesSizeDone	= 0;

		if(div.className == "dropProgressColumn") { divHeight = "20"; }
		div.innerHTML = "<div style='width:100%;background:transparent;height:0px'></div><div class='dropStatusCurrent' style='width:100%;height:" + divHeight + "px'></div>";
		
		
		
			setTimeout(function(){
				drUploadFile(files, idForm, refresh, div);
				if(top.frames[0]!=null && top.frames[0]!=undefined && top.frames[0].frames[0]!=null && top.frames[0].frames[0]!=undefined)
				{
					top.frames[0].frames[0].location.reload();
				}
				if(refresh.indexOf("id[level]=") == 0) {
					var level = refresh.substring(10);
						// identify drop events in column with row refresh only
						//For both refreshrow and expandRow actions, the level has to be corrected.
					if((refresh.indexOf(".refreshRow") != -1)) {
						level = level.replace(".refreshRow", "");
						emxEditableTable.refreshRowByRowId(level);
					} else {
						level = level.replace(".expandRow", "");
						emxEditableTable.refreshRowByRowId(level);
						emxEditableTable.expand([level], "1");
					}
				}
			}, 0);
		
		
	}
}

function drShowCascade(files){
	var drRunCascadeforFileExtensionsArr;
	var showCascadeAcitivity = true;
	if(drRunCascadeforFileExtensions != "" && drRunCascadeforFileExtensions != "null"){
		drRunCascadeforFileExtensions = drRunCascadeforFileExtensions.toLowerCase();
		drRunCascadeforFileExtensionsArr = drRunCascadeforFileExtensions.split(",");
	}
	
	jQuery.each(files, function(k, file) {
			 var fName = file.name;
			 var fileExt = fName.substring(fName.lastIndexOf(".")+1, fName.length);
			 
			 if( drRunCascadeforFileExtensionsArr && jQuery.inArray(fileExt.toLowerCase(), drRunCascadeforFileExtensionsArr) < 0){
	    		showCascadeAcitivity = false;
				return false;
				
	    	 }
		});		
		return showCascadeAcitivity;
		
}

function drUploadFile(files, id, idRefresh, dropAreaDiv, idImage) {
	var xhr = new XMLHttpRequest();
	var url = document.getElementById(id).action;

	drRunCascade = drShowCascade(files);
	if(drRunCascade == true){
		url+="&drtoolsKey="+drCascadeActivityName+"&runCascadeforFileExtensions="+drRunCascadeforFileExtensions+"&cascadeTargetLocation="+drCascadeTargetLocation+"&showCascadeForCheckin=true";
	}else{
		url+="&drtoolsKey="+drCascadeActivityName+"&runCascadeforFileExtensions="+drRunCascadeforFileExtensions+"&cascadeTargetLocation="+drCascadeTargetLocation+"&showCascadeForCheckin=false";
	}

	

	
	
	if(idRefresh != undefined) {
		if(idRefresh.indexOf(".refreshRow") == -1 && idRefresh.indexOf(".expandRow") == -1) {
			url += "&refresh=true";
		}
	}
	if (xhr.upload ) {
		
		var formData = new FormData();
		jQuery.each(files, function(k, file) {
			formData.append('file_'+k, file);			 
		});
							
		
		xhr.open("POST", url, false);
		xhr.send(formData);

		var result = xhr.responseText;
		result = result.trim();
		if(drRunCascade == true){
			var resultValues = result.split('@@');
			var fileNamesValue = resultValues[1];
			fileNamesValue = fileNamesValue.replace('</div>', '');
			fileNamesValue = '@@' + fileNamesValue; 

			var drCascadeUrl ='../drV6Tools/drCascade.action?drtoolsKey='+drCascadeActivityName+'&action=init&mode=Add&objectId='+parentObjectId+'';	
			if(drCascadeTargetLocation == "slidein")
			{
				drCascadeUrl = drCascadeUrl+ '&uploadResponse='+fileNamesValue+'&targetLocation=slidein&refreshTable=true';
				drCascadeUrl = encodeURIComponent(drCascadeUrl);
				showSlideInDialog("../common/emxAEFSubmitSlideInAction.jsp?portalMode=false&frameName=detailsDisplay&url="+drCascadeUrl,true);
			}
			if(drCascadeTargetLocation == "popup"){
				drCascadeUrl = drCascadeUrl+ '&uploadResponse='+encodeURIComponent(fileNamesValue);
				showDialog(drCascadeUrl);
			}
		
		}
		if(result.trim().substring(0,5) == 'ERROR'){
			var classNameBeforeUpload = dropAreaDiv.className;
			if(classNameBeforeUpload == "dropProgressWithImage"){
				dropAreaDiv.className = "dropAreaWithImage";
				jQuery('#'+idImage).css('opacity','1.0');
			}else if(classNameBeforeUpload == "dropProgressColumn"){
				dropAreaDiv.className = "dropAreaColumn";
			}else {
				dropAreaDiv.className = "dropArea";
			}
			return;
		}
		if(idRefresh != undefined) {
			if(idRefresh.indexOf(".refreshRow") == -1 && idRefresh.indexOf(".expandRow") == -1) {
				var result = xhr.responseText;
				document.getElementById(idRefresh).innerHTML = result.trim();
			}
		}
		
			

	}
}
