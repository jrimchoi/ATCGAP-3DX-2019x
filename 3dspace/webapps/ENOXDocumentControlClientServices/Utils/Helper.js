define('DS/ENOXDocumentControlClientServices/Utils/Helper', [
  'DS/ENOXEnhancers/Constants/Constants',
  'DS/ENOXEnhancers/Utils/Helper',
  'DS/ENOXDocumentControlClientServices/Services/Resources'
], function(
  Constants,
  EnhancersHelper,
  ServiceResources
)
{
  'use strict';

  var Helper = {
    getDocImage: function _getDocImage(data, url)
    {
      if (EnhancersHelper.isArrayEmpty(data.relateddata) ||
        EnhancersHelper.isArrayEmpty(data.relateddata.files))
      {
        return url + ServiceResources.DOCUMENT_TYPE_ICONS +
          'I_DefaultDoc_ThumbM200x150.png';
      }
      else if (data.relateddata.files.length > 1)
      {
        return url + ServiceResources.DOCUMENT_TYPE_ICONS +
          'I_MultipleDocuments200x150.png';
      }
      var image = Constants.EMPTY_STRING;
      var title = data.relateddata.files[0].dataelements.title;
      if (title.toLowerCase().endsWith('.pdf'))
      {
        image = url + ServiceResources.DOCUMENT_TYPE_ICONS + 'I_PDFdoc200x150.png';
      }
      else if (title.toLowerCase().endsWith('.doc') || title.toLowerCase().endsWith('.docx'))
      {
        image = url + ServiceResources.DOCUMENT_TYPE_ICONS + 'I_RichTextDoc200x150.png';
      }
      else if (title.toLowerCase().endsWith('.xls') || title.toLowerCase().endsWith('.xlsx'))
      {
        image = url + ServiceResources.DOCUMENT_TYPE_ICONS + 'I_TableDoc200x150.png';
      }
      else
      {
        image = url + ServiceResources.DOCUMENT_TYPE_ICONS +
          'I_DefaultDoc_ThumbM200x150.png';
      }
      return image;
    }
  };

  return Helper;
});
