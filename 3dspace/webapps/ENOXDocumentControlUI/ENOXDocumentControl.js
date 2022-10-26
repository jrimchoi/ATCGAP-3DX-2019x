define('DS/ENOXDocumentControlUI/ENOXDocumentControl', [
    'UWA/Core',
    'UWA/Promise',
    'DS/ENOXEnhancers/Services/PlatformServices',
    'DS/ENOXEnhancers/Services/SettingsManagement',
    'DS/ENOXEnhancers/Services/Resources',
    'DS/ENOXEnhancers/Constants/Constants',
    'DS/ENOXEnhancers/Services/WebServices',
    'DS/ENOXEnhancers/Utils/ENOXTagContent',
    'DS/ENOXEnhancers/Utils/Helper',
    'DS/ENOXEnhancersUI/Views/ENOXConfiguredTriptychView',
    'DS/ENOXEnhancersUI/Constants/Constants',
    'text!DS/ENOXDocumentControlUI/assets/configurations/TriptychConfiguration.json',
    'i18n!DS/ENOXDocumentControlUI/assets/nls/ENOXDocumentControlUI',
    'css!DS/ENOXDocumentControlUI/css/ENOXDocumentControlUI.css'
  ],
  function(
    UWA,
    UWAPromise,
    PlatformServices,
    SettingsManagement,
    XEnhancersResources,
    XEnhancersConstants,
    XEnhancersServices,
    XEnhancersTagContent,
    XEnhancersHelper,
    ConfiguredTriptych,
    XEnhancersUIConstants,
    Configuration,
    DocumentsNLS
  )
  {
    'use strict';

    var ENOXDocuments = function() {};

    function addPreferences(options)
    {
      var jsonConfig = JSON.parse(Configuration),
        onComplete = options.resolve,
        onFailure = options.reject,
        options = UWA.merge(options, jsonConfig.left[0].collection.options);
      require([jsonConfig.left[0].collection.url],
        function(welcomePanelCollection)
        {
          var collectionClass = welcomePanelCollection.createCollection();
          var collection = new collectionClass([], options);
          collection.fetch(
          {
            onComplete: function(data)
            {
              var welcomeList = data._models[0]._attributes.WelcomePanelActivities.activities,
                data = [];
              welcomeList.forEach(function(item)
              {
                var json = {
                  label: item.actions[0].text,
                  value: item.actions[0].id
                };
                var tagObj = new XEnhancersTagContent();
                SettingsManagement.addSetting(item.id + XEnhancersUIConstants.TAG_OBJ,
                  tagObj);
                data.push(json);
              });
              var prefValue = widget.getValue('welcome');
              widget.addPreference(
              {
                name: 'welcome',
                type: XEnhancersUIConstants.LIST,
                label: DocumentsNLS['Welcome'],
                defaultValue: prefValue || welcomeList[0].actions[0].id,
                options: data
              });

              if (XEnhancersHelper.isStringEmpty(prefValue))
              {
                widget.toggleEdit();
              }

              onComplete(data);
            },
            onFailure: function(err)
            {
              console.log(err);
              if (UWA.is(onFailure, 'function'))
              {
                onFailure(err);
              }
            }
          });
        });
    }

    ENOXDocuments.prototype.onLoad = function()
    {
      var widgetcontainer = widget.body;
      widgetcontainer.empty();

      var promise = new UWAPromise(function(resolve, reject)
      {
        ENOXDocuments.prototype.init(resolve);
      });

      promise.then(function(result)
      {
        result.renderTo = widgetcontainer;
        result.render();
      });
    }

    ENOXDocuments.prototype.init = function _init(callback)
    {
      var that = this;
      that._name = 'ENOXDocuments';

      var promisePlatformInit = function()
      {
        return new UWAPromise(function(resolve, reject)
        {
          var options = {
            onComplete: resolve,
            onFailure: reject
          };
          PlatformServices.prototype.initializePlatform(options);
        });
      }

      var promiseSC = function(platformServices)
      {
        return new UWAPromise(function(resolve, reject)
        {
          var services = SettingsManagement.getPlatformURLs();
          var options = {
            url: services.get3DSpaceURL() + XEnhancersResources.SECURITY_CONTEXT +
              services.getTenantId(),
            onComplete: function(result)
            {
              var sc = JSON.parse(result);
              if (!widget.getValue(XEnhancersConstants.PAD_CURRENT_SECURITY_CONTEXT))
              {
                SettingsManagement.addSetting(XEnhancersConstants.PAD_CURRENT_SECURITY_CONTEXT,
                  sc.SecurityContext);
              }
              resolve(result);
            },
            onFailure: reject
          };

          XEnhancersServices.callCustomService(options);
        });
      }

      var promisePreferences = function(padSettings)
      {
        return new UWAPromise(function(resolve, reject)
        {
          var options = {
            resolve: resolve,
            reject: reject
          };
          addPreferences(options)
        });
      }

      promisePlatformInit().then(promiseSC).then(promisePreferences).then(function(result)
      {
        callback(that);
      }, function(error)
      {
        console.log(error);
      });
    }

    ENOXDocuments.prototype.render = function _render()
    {
      var that = this,
        options = {};
      var documentContainer = new UWA.Element('div',
      {
        class: 'documents-container',
        styles:
        {
          width: '100%',
          height: '100%'
        }
      });

      if (that.renderTo)
      {
        documentContainer.inject(that.renderTo);
      }

      options.renderTo = documentContainer;
      options.configurations =
        'DS/ENOXDocumentControlUI/assets/configurations/TriptychConfiguration.json';

      var configTriptychView = new ConfiguredTriptych();
      configTriptychView.init(options);
      configTriptychView.buildview();
      ENOXDocuments.configTriptychView = configTriptychView;
      return documentContainer;
    }

    //TODO the below method to be worked once Triptych is handled
    ENOXDocuments.prototype.onResize = function()
    {
      ENOXDocuments.configTriptychView.onResize();
    }

    return ENOXDocuments;

  });
