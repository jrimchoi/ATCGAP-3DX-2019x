define('DS/ENOXDocumentControlUI/Collections/FavoriteDocumentsCollection', [
    'UWA/Class/Model',
    'UWA/Promise',
    'DS/ENOXEnhancers/Services/SettingsManagement',
    'UWA/Class/Collection',
    'DS/ENOXDocumentControlUI/Models/FavoriteDocumentModel',
    'DS/ENOXEnhancers/Services/Favorites',
    'DS/ENOXDocumentControlClientServices/Services/WebServices',
    'DS/ENOXEnhancers/Constants/Constants',
    'DS/ENOXDocumentControlClientServices/Constants/Constants',
    'DS/ENOXEnhancers/Utils/ENOXContentSearch'
  ],
  function (
    Model,
    UWAPromise,
    SettingsManagement,
    Collection,
    FavoriteDocumentModel,
    Favorites,
    DocWebServices,
    Constants,
    ServiceConstants,
    ContentSearch
  ) {
    'use strict';

    var DocumentsCollection = {
      createCollection: function _createCollection() {
        return Collection.extend({
          model: FavoriteDocumentModel.getModel(),
          sync: function (method, collection, options) {
            var that = this,
              info = collection.options.info || false;
            options = options || {};
            options.options = that.options;
            options.content = collection.options.content || Constants.EMPTY_STRING;
            var onComplete = options.onComplete,
              onFailure = options.onFailure;
            //For sorting
            if (options.options.sort || collection.options.sort) {
              var sortObj = options.options.sort || collection.options.sort;
              var sortExpression = sortObj.sortAttribute === 'maturity' ? 'state' :
                sortObj.sortAttribute;

              var sortString = sortObj.sortAttribute + '_sort_' + sortObj.sortOrder.toLowerCase() +
                ',' + sortExpression;

              options.options.sortString = sortString;
            }
            //Sorting Ends
            if (info) {
              DocWebServices.getDocumentsInfo(options);
            } else {
              var favoritesName = Constants.EMPTY_STRING;
              favoritesName = options.name = ServiceConstants.DOCUMENT_FAVORITE_LIST +
                SettingsManagement.getPlatformURLs().getTenantId();
              options.onComplete = function (result) {
                var options = result.options,
                  jsonData = result.value,
                  dataArray = [],
                  busId = [];
                if (jsonData) {
                  dataArray = jsonData.data.data[favoritesName];
                }

                dataArray.forEach(function (item) {
                  busId.push(item.id);
                });
                if (busId.length > 0) {
                  options.content = busId;
                  options.onComplete = onComplete;

                  DocWebServices.getDocumentsInfo(options);
                } else {
                  var data = {
                    data: []
                  }
                  onComplete(data);
                }
              };

              Favorites.getFavorites(options);
            }

          },
          setup: function (model, options) {
            this.options = options;
          },
          parse: function (data) {
            if (data && data.data) {
              return data.data;
            } else {
              data;
            }
          }
        });
      }
    };

    return DocumentsCollection;

  });
