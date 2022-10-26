define('DS/ENOXDocumentControlUI/Models/OwnedDocumentModel', [
    'UWA/Class/Model',
    'UWA/Core',
    'UWA/Utils',
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
  function(
    UWAModel,
    UWACore,
    UWAUtils,
    SettingsManagement,
    Favorites,
    Constants,
    ENOXDocumentsView,
    ServiceConstants,
    xDocWebServices,
    Helper,
    ServiceHelper,
    xDocumentControlNLS
  )
  {
    'use strict';

    var OwnedDocumentModel = {
      getModel: function _getModel()
      {
        var cntMdl = UWAModel.extend(
        {
          idAttribute: 'id',
          defaults:
          {
            id: Constants.EMPTY_STRING,
            name: Constants.EMPTY_STRING,
            owner: Constants.EMPTY_STRING
          },
          setup: function(model, options)
          {
            var that = this;
            that.listenTo(that, 'onChange:current', function()
            {
              var that = this;
              // For changing only the model content, title, subtitle etc
              // and not refresh of view
              that.changeContent();
              // For refreshing the view to load data again
              // that.refreshView();
            });
            that.actions = OwnedDocumentModel.prepareActionCollections(
              model, options);
          },
          refreshView: function _refreshView()
          {
            var that = this;
            // Fetch collection and renders UI
            that.collection.fetch();
          },
          changeContent: function _changeContent()
          {
            var content = this.get('content');
            var contentArray = content.split('State: ');
            contentArray[1] = this.get('current');
            content = contentArray[0].concat('State: ');
            content = content.concat(contentArray[1]);
            this.set('content', content);
          },
          parse: function(data)
          {
            var that = this,
              _3DSpaceURL = SettingsManagement.getPlatformURLs().get3DSpaceURL();
            var modelData = data ||
            {};
            if (data && data.dataelements)
            {
              modelData = data.dataelements;
              modelData.type = data.type;
              modelData.id = data.id;
              modelData.current = modelData.state;

              modelData.icon = modelData.typeicon;
            }

            if (data && data.relateddata)
            {
              var relatedData = data.relateddata;
              var owner = relatedData.ownerInfo ? relatedData.ownerInfo[0] :
              {};
              if (!Helper.isObjectEmpty(owner) && owner.dataelements)
              {
                modelData.owner = owner.dataelements.name;
                modelData.firstname = owner.dataelements.firstname;
                modelData.lastname = owner.dataelements.lastname;
              }
              modelData.files = relatedData.files ? relatedData.files :
              {};

              var originator = relatedData.originatorInfo ? relatedData.originatorInfo[
                0] :
              {};
              if (!Helper.isObjectEmpty(originator) && originator.dataelements)
              {
                modelData.originator = originator.dataelements.name;
                modelData.orgFirstname = originator.dataelements.firstname;
                modelData.orgLastname = originator.dataelements.lastname;
              }
            }

            modelData.image = ServiceHelper.getDocImage(data, _3DSpaceURL);

            var innerFormatter = {
              "year": "numeric",
              "month": "long",
              "day": "numeric",
              "hour": "numeric",
              "minute": "numeric",
              "second": "numeric"
            };
            modelData.title = modelData.title || "";
            modelData.subtitle = modelData.current;
            modelData.content = "Owner: " + modelData.owner;
            modelData.owner = modelData.owner;
            modelData.policy = modelData.policy;
            modelData.myfavorites = data.myfavorites || false;
            modelData.description = modelData.description;
            modelData.changeOrder = modelData.changeorder;
            modelData.changeAction = modelData.changeaction;
            modelData.modified = Helper.getFormattedDate(modelData.modified,
              innerFormatter) || "NOT Getting Modified";
            modelData.propertiesList = [Helper.getTitle(modelData.title), Helper.getChange(
                modelData.changeOrder), Helper.getModified(modelData.modified),
              Helper.getOwner(modelData.owner), Helper.getDescription(modelData.description)
          ];

          
            return modelData;
          }
        });
        return cntMdl;
      },
      onFavoritesSelect: function _onFavoritesSelect(cellInfo, index, onComplete,
        onFailure)
      {
        var favoriteName = ServiceConstants.DOCUMENT_FAVORITE_LIST +
          SettingsManagement.getPlatformURLs().getTenantId(),
          favoritesData = [],
          favTitle = '';

        var NewStatusbarIcons = [];
        var NewStatusbarIconsTooltips = [];
        var cellView = cellInfo ? cellInfo.cellView : undefined;
        var contentView = cellView ? cellView.contentView : undefined;
        var nodeModel = cellInfo ? cellInfo.cellModel : undefined;
        favoritesData.push(nodeModel.options.model);

        for (var i = 0; i < contentView.statusbarIcons.length; i++)
        {
          NewStatusbarIcons.push(contentView.statusbarIcons[i]);
          NewStatusbarIconsTooltips.push(contentView.statusbarIconsTooltips[i]);
        }

        if (NewStatusbarIcons[index] === 'favorite-on')
        {
          NewStatusbarIcons[index] = 'favorite-off';
          NewStatusbarIconsTooltips[index] =
            'Add to Favorites';
          favTitle = 'Removed from Favorites';
        }
        else if (NewStatusbarIcons[index] === 'favorite-off')
        {
          NewStatusbarIcons[index] = 'favorite-on';
          NewStatusbarIconsTooltips[index] =
            'Remove from Favorites';
          favTitle = 'Added to Favorites';
        }
        var options = {
          name: favoriteName,
          favorites: favoritesData,
          protocol: '3DXContent',
          version: '1.0',
          source: 'ENODOCO_AP',
          onComplete: function(data)
          {
            //Update the model.
            nodeModel.getTreeDocument().prepareUpdate();
            nodeModel.options.statusbarIcons = NewStatusbarIcons;
            nodeModel.options.statusbarIconsTooltips =
              NewStatusbarIconsTooltips;
            nodeModel.getTreeDocument().pushUpdate();
            var result = {
              title: favTitle,
              subtitle: ''
            };
            console.log('Deleted from favorites');
            onComplete(result);
          },
          onFailure: function(err)
          {
            console.log('Failed to delete from favorites');
            onFailure(err);
          }
        };
        if (cellInfo.cellModel.options.model._attributes.myfavorites)
        {
          Favorites.deleteFavorites(options);
        }
        else
        {
          Favorites.addFavorites(options);
        }
      },
      prepareActionCollections: function _prepareActionCollections(model,
        options)
      {
        var modelActions = [];
        var favorites = {
          id: 'Favorites',
          title: 'Favorites',
          icon: 'favorite-off',
          events: [
          {
            onStatusbarIconPointerDown: function(cellInfo, index, onComplete, onFailure)
            {
              OwnedDocumentModel.onFavoritesSelect(cellInfo, index, onComplete,
                onFailure);
            }
          }]
        };
        model.myfavorites ? favorites.icon = 'favorite-on' : 'favorite-off';
        modelActions.push(favorites);

        var download = {
          id: 'download',
          title: 'Download',
          icon: 'download',
          events: [
          {
            onStatusbarIconPointerDown: function(cellInfo, index, onComplete, onFailure)
            {
              var options = {
                onComplete: function(data)
                {
                  var result = {
                    title: xDocumentControlNLS.DOWNLOAD_FILES_INITIATED,
                    subtitle: xDocumentControlNLS.DOWNLOAD_FILES_SAVE_TO_DISK
                  };

                  onComplete(result);
                },
                onFailure: function(error)
                {
                  onFailure(error.data[0].updateMessage);
                }
              };
              xDocWebServices.downloadDocuments(cellInfo.cellModel.options.model._attributes
                .id, true, options);
            }
          }]
        };
        model.relateddata && model.relateddata.files && model.relateddata.files.length > 0 &&
          model.dataelements && model.dataelements.hasDownloadAccess &&
          model.dataelements.hasDownloadAccess.toLowerCase() === 'true' ?
          modelActions.push(download) : Constants.EMPTY_STRING;


        var openIn3DSpace = {
          id: '3DSpaceView',
          title: 'Open in 3DSpace',
          icon: 'open-in-a-new-window',
          events: [
          {
            onStatusbarIconPointerDown: function(data)
            {
              var options = {
                ModelData:
                {
                  id: data.cellModel.options.data.id
                }
              };
              new ENOXDocumentsView().openIn3DSpace(options);

            }
          }]
        };
        modelActions.push(openIn3DSpace);
        return modelActions;
      },
      idAttribute: 'id'
    };

    return OwnedDocumentModel;
  });
