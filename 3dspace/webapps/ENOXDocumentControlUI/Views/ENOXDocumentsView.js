define('DS/ENOXDocumentControlUI/Views/ENOXDocumentsView', [
    'UWA/Promise',
    'DS/Core/ModelEvents',
    'DS/ENOXEnhancers/Services/SettingsManagement',
    'DS/ENOXEnhancersUI/Views/ENOX3DPlayViewer',
    'DS/ENOXEnhancersUI/Views/ENOXExtendedWelcomePanelView',
    'DS/ENOXEnhancersUI/Views/ENOXTabsView',
    'DS/ENOXEnhancersUI/Views/ENOXPropertyView',
    'DS/ENOXEnhancersUI/Views/ENOXHistoryView',
    'DS/UIKIT/Input/Button',
    'DS/ENOXEnhancers/Utils/Helper',
    'DS/ENOXDocumentControlClientServices/Services/WebServices',
    'DS/ENOXEnhancersUI/Views/ENOXExtendedIDCard',
    'i18n!DS/ENOXDocumentControlUI/assets/nls/ENOXDocumentControlUI',
    'text!DS/ENOXDocumentControlUI/assets/configurations/TabConfiguration.json',
    'text!DS/ENOXDocumentControlUI/assets/configurations/DetailsViewConfiguration.json'
  ],
  function (
    UWAPromise,
    ModelEvents,
    SettingsManagement,
    ENOX3DPlayViewer,
    ExtendedWelcomePanelView,
    ENOXTabsView,
    ENOXPropertyView,
    ENOXHistoryView,
    UIKITButton,
    XEnhancersHelper,
    xDocWebServices,
    ENOXExtendedIDCard,
    xDocumentControlNLS,
    Configuration,
    DetailsConfiguration
  ) {
    'use strict';

    var ENOXDocumentsView = function () {
      this._name = 'ENOXDocumentsView';
    };

    function prepareIdCard(documentData, renderTo) {
      var idCardPromise = new UWAPromise(function (resolve, reject) {
        documentData.resolve = resolve;
        var idcard = new ENOXExtendedIDCard(documentData);
      });
      idCardPromise.then(function (result) {
        result.render();
        result.inject(renderTo);
        return result;
      });
    }

    ENOXDocumentsView.prototype.playerView = function (options) {
      var documentData = options.data;
      var tabDataContainer = options.renderTo;
      if (tabDataContainer === undefined) return;
      var playerContainer = UWA.createElement('div', {
        class: 'player-container',
        styles: {
          width: '100%',
          height: '100%'
        }
      });
      playerContainer.inject(tabDataContainer);

      var promise = new UWAPromise(function (resolve, reject) {
        var player = new ENOX3DPlayViewer();
        player.init({
          documentData: documentData
        });
        player.render(playerContainer)
        resolve(player);
      });

      promise.then(function (result) {
        console.log('success');
      });
    }

    ENOXDocumentsView.prototype.propertyView = function (options) {
      options.details = DetailsConfiguration;
      var documentData = options.data;
      var tabDataContainer = options.renderTo;
      tabDataContainer.style.height = widget.body.clientHeight + "px";

      var propertyView = new ENOXPropertyView();
      var itemID = documentData.id;
      propertyView.buildSlideIn(itemID, options);
    }

    ENOXDocumentsView.prototype.mainDocView = function (data) {
      var triptychView = data.renderTo;

      var tabsView = new ENOXTabsView();
      tabsView.init(Configuration);
      var container = tabsView.render(data.event.data.nodeModel.options);
      var mainDocDiv = UWA.createElement('div'),
        documentData = data.event.data.nodeModel.options.data;
      var idCard = data.event.data.nodeModel.options.idCard;
      var idCardDiv = UWA.createElement('div', {
        class: 'idCard-div-container'
      }).inject(mainDocDiv);
      prepareIdCard({
        'documentData': documentData,
        'idCard': idCard,
        'enoxtriptychview': triptychView.enoxTriptych
      }, idCardDiv);
      container.inject(mainDocDiv);
      var tabContent = {
        side: 'middle',
        content: mainDocDiv
      };

      triptychView.renderContent(tabContent);
      triptychView.showMainView();

      var rightSideRefreshEvent = {
        side: 'right',
        size: triptychView.jsonConfig.right[0].config[0].originalSize
      };
      triptychView.resize(rightSideRefreshEvent);
      var leftSideRefreshEvent = {
        side: 'left',
        size: triptychView.jsonConfig.left[0].config[0].originalSize /
          3
      };

      ExtendedWelcomePanelView.prototype.toggleCollapseButton({
        id: 'WelcomePanelToggleButton'
      }, true);
      triptychView.resize(leftSideRefreshEvent);

    }

    ENOXDocumentsView.prototype.historyView = function (data) {
      var historyDiv = UWA.createElement('div', {
        class: 'container',
        styles: {
          height: '100%',
          display: 'contents'
        }
      });
      var options = {};

      var historyPromise = new UWAPromise(function (resolve, reject) {

        options.onComplete = resolve;
        options.onFailure = reject;
        xDocWebServices.getDocumentHistory(data.data.id, options);
      }).
      then(function (result) {
        var resultData = JSON.parse(result);
        var historyData =
          historyDiv.inject(data.renderTo);
        var historyView = new ENOXHistoryView();
        historyView.init(
          XEnhancersHelper.getFormattedHistoryJSON(resultData.data[0].relateddata.history), historyDiv);

        historyView.render();
      });

    }

    // It will call if user clicks on Download Icon in Row View
    ENOXDocumentsView.prototype.onIconSelectionFromRowViewDownload = function (options) {
      var ModelData = options.ModelData;
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
      xDocWebServices.downloadDocuments(ModelData.id, true, options);
    }

    ENOXDocumentsView.prototype.openIn3DSpace = function (options) {
      var url = SettingsManagement.getPlatformURLs().get3DSpaceURL() +
        '/common/emxNavigator.jsp?objectId=' + options.ModelData.id + '&collabSpace=Default';
      window.open(url, '_blank');
    }

    return ENOXDocumentsView;
  });
