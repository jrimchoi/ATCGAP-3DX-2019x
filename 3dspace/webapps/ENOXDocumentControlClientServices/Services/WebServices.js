define('DS/ENOXDocumentControlClientServices/Services/WebServices', [
  'UWA/Core',
  'DS/ENOXEnhancers/Services/SettingsManagement',
  'DS/DocumentManagement/DocumentManagement',
  'DS/ENOXEnhancers/Constants/Constants',
  'DS/ENOXEnhancers/Services/WebServices',
  'DS/ENOXDocumentControlClientServices/Constants/Constants',
  'DS/ENOXDocumentControlClientServices/Services/Resources'
], function (
  UWA,
  SettingsManagement,
  DocumentManagement,
  XEnhancersConstants,
  XEnhancersWebServices,
  Constants,
  Resources
) {
  'use strict';

  String.prototype.replaceAll = function (search, replacement) {
    var target = this;
    return target.replace(new RegExp(search, 'g'), replacement);
  };

  var WebServices = {
    getDocumentsInfo: function _getDocumentsInfo(options) {
      options.url = SettingsManagement.getPlatformURLs().get3DSpaceURL() +
        Resources.MY_CTRL_DOCUMENTS;
      if (!options.onComplete) {
        console.log('getMyControlDocuments: onComplete not defined');
      } else if (!UWA.is(options.onComplete, 'function')) {
        console.log('getMyControlDocuments: onComplete is not a function');
      }

      var onComplete = options.onComplete || XEnhancersConstants.EMPTY_JSON_OBJECT;
      options.onComplete = function (data) {
        onComplete(JSON.parse(data));
      }
      options.headers = options.headers || {
        Accept: XEnhancersConstants.ACCEPT_APPLICATION_JSON,
        'Content-Type': XEnhancersConstants.APPLICATION_URL_ENCODED
      };
      options.method = XEnhancersConstants.POST;
      var ids = JSON.stringify(options.content);
      ids = ids.slice(1, ids.length - 1);
      ids = ids.replaceAll('"', '');
      options.data = {
        '$ids': ids
      };
      if (options.options.sortString) {
        options.data['$fields'] = options.options.sortString;
      }

      XEnhancersWebServices.callCustomService(options);
    },
    getMyControlDocumentsWithoutFieldData: function _getMyControlDocumentsWithoutFieldData(
      options) {
      options.url = SettingsManagement.getPlatformURLs().get3DSpaceURL() +
        Resources.MY_CTRL_DOCUMENTS_WITHASSIGNED_NO_FIELD_DATA;
      if (options.options.sortString) {
        options.url += ',' + options.options.sortString;
      }

      if (!options.onComplete) {
        console.log('getMyControlDocumentsWithoutFieldData: onComplete not defined');
      } else if (!UWA.is(options.onComplete, 'function')) {
        console.log('getMyControlDocumentsWithoutFieldData: onComplete is not a function');
      }

      var onComplete = options.onComplete || XEnhancersConstants.EMPTY_JSON_OBJECT;
      options.onComplete = function (data) {
        onComplete(JSON.parse(data));
      }
      XEnhancersWebServices.callCustomService(options);
    },
    getSearchResult: function _getSearchResult(options) {
      var baseURL = SettingsManagement.getPlatformURLs().get3DSpaceURL();
      baseURL = baseURL.substring(0, baseURL.lastIndexOf('/'));
      options.url = baseURL + Resources.FEDERATED_SEARCH;
      var onComplete = options.onComplete || XEnhancersConstants.EMPTY_JSON_OBJECT;
      options.onComplete = function (data) {
        onComplete(JSON.parse(data));
      }
      options.headers = {
        Accept: XEnhancersConstants.ACCEPT_APPLICATION_JSON,
        'Content-Type': XEnhancersConstants.ACCEPT_APPLICATION_JSON
      };
      options.method = XEnhancersConstants.POST;

      options.data = JSON.stringify({
        "query": options.query,
        "specific_source_parameter": {
          "3dspace": {
            "additional_query": " AND (flattenedtaxonomies:\"types/Controlled Documents\")"
          }
        }
      });
      XEnhancersWebServices.callCustomService(options);
    },
    downloadDocuments: function _downloadDocuments(id, autoCheckout, options) {
      var onComplete = options.onComplete,
        onFailure = options.onFailure;
      options.method = options.method || XEnhancersConstants.PUT;
      options.asZip = true;
      options.autoDownload = autoCheckout;
      options.headers = {
        Accept: XEnhancersConstants.ACCEPT_APPLICATION_JSON,
        'Content-Type': XEnhancersConstants.ACCEPT_APPLICATION_JSON
      };

      DocumentManagement.downloadDocument(id, null, false, options);
    },

    getDocumentHistory: function _getDocumentHistory(id, options) {
      var onComplete = options.onComplete,
        onFailure = options.onFailure,
        url = SettingsManagement.getPlatformURLs().get3DSpaceURL() + Resources.MY_CTRL_DOCUMENTS_HISTORY;
      options.url = url.replace('$id', id);
      options.method = XEnhancersConstants.GET;
      XEnhancersWebServices.callCustomService(options);
    }
  };

  return WebServices;

});
