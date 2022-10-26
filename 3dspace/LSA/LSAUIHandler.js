/**
     * Function for validating form fields for LRASubmissionProperties
     */
	function setFieldEditAccess(fieldArray, disable){
		var form = document.editDataForm;
		for(var i = 0; i < fieldArray.length; i++){
			form[fieldArray[i]].disabled=disable;
		}
	}
	
	/**
     * Function for fetching values for a key in the document URL
     */
	function querystring(key) {
		var re=new RegExp('(?:\\?|&)'+key+'=(.*?)(?=&|$)','gi');
		var r=[], m;
		while ((m=re.exec(document.location.search)) != null) r.push(m[1]);
		return r;
	}
