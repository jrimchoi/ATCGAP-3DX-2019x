define('DS/ENOXDocumentControlUI/Models/FavoriteDocumentModel', [
    'UWA/Class/Model',
    'UWA/Core',
    'DS/CoreEvents/ModelEvents',
    'DS/ENOXEnhancers/Services/SettingsManagement',
    'DS/ENOXEnhancers/Services/Favorites',
    'DS/ENOXEnhancers/Constants/Constants',
    'DS/ENOXDocumentControlUI/Views/ENOXDocumentsView',
    'DS/ENOXDocumentControlClientServices/Constants/Constants',
    'DS/ENOXDocumentControlClientServices/Services/WebServices',
    'DS/ENOXEnhancers/Utils/Helper',
    'DS/ENOXDocumentControlClientServices/Utils/Helper',
    'i18n!DS/ENOXDocumentControlUI/assets/nls/ENOXDocumentControlUI'
  ],
  function (
    UWAModel,
    UWACore,
    ModelEvents,
    SettingsManagement,
    Favorites,
    Constants,
    ENOXDocumentsView,
    ServiceConstants,
    xDocWebServices,
    Helper,
    ServiceHelper,
    xDocumentControlNLS
  ) {
    'use strict';

    var FavoriteDocumentModel = {
      getModel: function _getModel() {
        var cntMdl = UWAModel.extend({
          idAttribute: 'id',
          defaults: {
            id: Constants.EMPTY_STRING,
            name: Constants.EMPTY_STRING,
            owner: Constants.EMPTY_STRING,
          },
          setup: function (model, options) {
            var that = this;
            that.actions = FavoriteDocumentModel.prepareActionCollections(
              model, options);
          },
          refreshView: function _refreshView() {
            var that = this;
            // Fetch collection and renders UI
            that.collection.fetch();
          },
          changeContent: function _changeContent() {
            var content = this.get('content');
            var contentArray = content.split('State: ');
            contentArray[1] = this.get('current');
            content = contentArray[0].concat('State: ');
            content = content.concat(contentArray[1]);
            this.set('content', content);
          },
          parse: function (data) {
            var that = this,
              _3DSpaceURL = SettingsManagement.getPlatformURLs().get3DSpaceURL(),
              formatter = {
                year: 'numeric',
                month: 'long',
                day: 'numeric',
                hour: 'numeric',
                minute: 'numeric',
                second: 'numeric',
              };
            var modelData = data || {};
            if (Helper.isArrayEmpty(data)) {
              return data;
            } else if (!Helper.isArrayEmpty(data.dataelements)) {
              modelData = data.dataelements;
              modelData.type = data.type;
              modelData.id = data.id;
              modelData.current = modelData.state;
              var owner = data.relateddata.ownerInfo[0];
              if (!Helper.isObjectEmpty(owner) && owner.dataelements) {
                modelData.owner = owner.dataelements.name;
                modelData.firstname = owner.dataelements.firstname;
                modelData.lastname = owner.dataelements.lastname;
              }
              modelData.files = data.relateddata.files ? data.relateddata.files : {};

              var originator = data.relateddata.originatorInfo[0];
              if (!Helper.isObjectEmpty(originator) && originator.dataelements) {
                modelData.originator = originator.dataelements.name;
                modelData.orgFirstname = originator.dataelements.firstname;
                modelData.orgLastname = originator.dataelements.lastname;
              }
              modelData.originated = Helper.getFormattedDate(modelData.originated,
                formatter);
              modelData.modified = Helper.getFormattedDate(modelData.modified,
                formatter);
              modelData.icon = modelData.typeicon;
              modelData.image = ServiceHelper.getDocImage(data, _3DSpaceURL);
            }
            modelData.title = modelData.title || modelData.name;
            modelData.subtitle = "Maturity: " + modelData.current;
            modelData.content = "Owner: " + modelData.owner;
            modelData.owner = modelData.owner;
            modelData.policy = modelData.policy;
            modelData.propertiesList = [Helper.getTitle(modelData.title), Helper.getChange(
                modelData.changeOrder), Helper.getModified(modelData.modified),
              Helper.getOwner(modelData.owner), Helper.getDescription(modelData.description)
            ];

            return modelData;
          }
        });
        return cntMdl;
      },
      prepareActionCollections: function _prepareActionCollections(model,
        options) {
        var that = this;
        var modelActions = [{
            id: 'Favorites',
            title: 'Favorites',
            icon: 'favorite-on',
            events: [{
              onStatusbarIconPointerDown: function (cellInfo, index, resolve, reject) {
                var favoriteName = ServiceConstants.DOCUMENT_FAVORITE_LIST +
                  SettingsManagement.getPlatformURLs().getTenantId(),
                  favoritesData = [];
                var cellView = cellInfo ? cellInfo.cellView : undefined;
                var contentView = cellView ? cellView.contentView : undefined;
                var nodeModel = cellInfo ? cellInfo.cellModel : undefined;
                favoritesData.push(cellInfo.nodeModel.options.model);
                Favorites.deleteFavorites({
                  name: favoriteName,
                  favorites: favoritesData,
                  protocol: '3DXContent',
                  version: '1.0',
                  source: 'ENODOCO_AP',
                  onComplete: function (data) {
                    var tree = nodeModel.getTreeDocument();
                    tree.prepareUpdate();
                    tree.removeRoot(nodeModel);
                    tree.pushUpdate();
                    //For updating tags
                    var ids = [];
                    ids.push(nodeModel._options.data.id);
                    var result = {
                      title: 'Removed from Favorites',
                      ids: ids
                    };
                    var currentTags = SettingsManagement.getSetting(Constants.CURRENT_TAG);
                    currentTags.removeAParticuliarIdFromTag(ids);
                    //Tag update ends
                    resolve(result);
                  },
                  onFailure: function (err) {
                    reject(err);
                  }
                });
              }
            }]
          },
          {
            id: 'download',
            title: 'Download',
            icon: 'download',
            events: [{
              onStatusbarIconPointerDown: function (cellInfo, index, onComplete,
                onFailure) {
                var options = {
                  onComplete: function (data) {
                    var result = {
                      title: xDocumentControlNLS.DOWNLOAD_FILES_INITIATED,
                      subtitle: xDocumentControlNLS.DOWNLOAD_FILES_SAVE_TO_DISK
                    };

                    onComplete(result);
                  },
                  onFailure: function (error) {
                    onFailure(error.data[0].updateMessage);
                  }
                };
                xDocWebServices.downloadDocuments(cellInfo.cellModel.options.model._attributes
                  .id, true, options);
              }
            }]
          },
          {
            id: '3DSpaceView',
            title: 'Open in 3DSpace',
            icon: 'open-in-a-new-window',
            events: [{
              onStatusbarIconPointerDown: function (data) {
                var options = {
                  ModelData: {
                    id: data.cellModel.options.data.id
                  }
                };
                new ENOXDocumentsView().openIn3DSpace(options);

              }
            }]
          }
        ];
        var actionCollections = [];
        modelActions.forEach(function (action) {
          var actionName = action.id;
          var actionAccess = action.access;
          if (actionAccess) {
            var key = actionAccess.key;
            var value = actionAccess.value;
            if (model != undefined && model[key] == value) {
              actionCollections.push(action);
            }
          } else {
            actionCollections.push(action);
          }
        });
        return actionCollections;
      },
      idAttribute: 'id'
    };

    return FavoriteDocumentModel;
  });
