define('DS/ENOXDocumentControlClientServices/Services/Resources', [
    'UWA/Core',
    'UWA/Controls/Abstract'
  ],
  function (
    Core,
    Abstract
  ) {
    'use strict';
    var Resources = {
      MY_CTRL_DOCUMENTS: '/resources/v1/modeler/controldocuments/myctrldocs',
      MY_CTRL_DOCUMENTS_WITHASSIGNED: '/resources/v1/modeler/controldocuments/myctrldocs/withassigned',
      MY_CTRL_DOCUMENTS_WITHASSIGNED_NO_FIELD_DATA: '/resources/v1/modeler/controldocuments/myctrldocs/withassigned?$include=none&$fields=none',
      DOCUMENT_TYPE_ICONS: '/webapps/ENOXDocumentControlUI/assets/icons/',
      FEDERATED_SEARCH: '/federated/search',
      MY_CTRL_DOCUMENTS_HISTORY: '/resources/v1/modeler/controldocuments/myctrldocs/$id/history'
    };

    return Resources;
  });
