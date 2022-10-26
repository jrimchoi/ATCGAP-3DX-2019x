define('DS/ENOXDocumentControlUI/Collections/OwnedDocumentsCollection', [
    'UWA/Class/Model',
    'UWA/Promise',
    'UWA/Class/Collection',
    'DS/ENOXEnhancers/Services/SettingsManagement',
    'DS/ENOXDocumentControlUI/Models/OwnedDocumentModel',
    'DS/ENOXEnhancers/Utils/ENOXTagContent',
    'DS/ENOXEnhancers/Utils/Helper',
    'DS/ENOXEnhancers/Constants/Constants',
    'DS/ENOXEnhancers/Services/Favorites',
    'DS/ENOXDocumentControlClientServices/Services/WebServices',
    'DS/ENOXDocumentControlClientServices/Constants/Constants'
  ],
  function (
    Model,
    UWAPromise,
    Collection,
    SettingsManagement,
    OwnedDocumentModel,
    TagContent,
    XEnhancersHelper,
    XEnhancersConstants,
    Favorites,
    XDocumentService,
    ServiceConstants
  ) {
    'use strict';

    function getFavoritesName() {
      return ServiceConstants.DOCUMENT_FAVORITE_LIST +
        SettingsManagement.getPlatformURLs().getTenantId();
    }
    var DocumentsCollection = {
      createCollection: function _createCollection() {
        return Collection.extend({
          model: OwnedDocumentModel.getModel(),
          sync: function (method, collection, options) {
            var that = this,
              options = options || {},
              info = collection.options.info || false;
            options.content = collection.options.content || XEnhancersConstants.EMPTY_STRING;
            options.options = that.options;
            var onComplete = options.onComplete,
              onFailure = options.onFailure,
              favoritesName = XEnhancersConstants.EMPTY_STRING;
            favoritesName = options.name = getFavoritesName();
            //For sorting
            if (options.options.sort) {
              var sortObj = options.options.sort;
              var sortString = sortObj.sortAttribute + '_sort_' + sortObj.sortOrder.toLowerCase() +
                ',' + sortObj.sortAttribute;
              options.options.sortString = sortString;
            }
            //Sorting Ends

            var promiseUserPref = new UWAPromise(function (resolve, reject) {
              options.onComplete = resolve;
              options.onFailure = reject;
              Favorites.getFavorites(options);
            });

            var promiseMyCtrlDocs = new UWAPromise(function (resolve, reject) {
              options.onComplete = resolve;
              options.onFailure = reject;
              info ? XDocumentService.getDocumentsInfo(options) :
                XDocumentService.getMyControlDocumentsWithoutFieldData(options);
            });

            Promise.all([that, promiseUserPref, promiseMyCtrlDocs]).then(function (
              result) {
              onComplete(result);
            }, function (error) {
              onFailure(error);
            });
          },
          setup: function (model, options) {
            this.options = options;
          },
          parse: function (result) {
            if (!SettingsManagement.getSetting(XEnhancersConstants.PAD_CSRF_TOKEN))
              SettingsManagement.addSetting(XEnhancersConstants.PAD_CSRF_TOKEN,
                result[2].data.csrf);
            var favorites = !XEnhancersHelper.isObjectEmpty(result[1].value) ?
              result[1].value.data.data[getFavoritesName()] : [];
            var contents = !XEnhancersHelper.isObjectEmpty(result[2].data) ?
              result[2].data : [];
            if (XEnhancersHelper.isObjectEmpty(contents)) {
              return contents;
            }
            favorites.forEach(function (item) {
              for (var i = 0; i < contents.length; i++) {
                if (contents[i].id === item.id) {
                  contents[i].myfavorites = true;
                }
              }
            });
            return contents;
          }
        });
      }
    };

    return DocumentsCollection;

  });
