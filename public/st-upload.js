  /*
  *   Sir Trevor Uploader
  *   Generic Upload implementation that can be extended for blocks
  */

  SirTrevor.fileUploader = function(block, file, success, error) {
    SirTrevor.DEFAULTS.uploadUrl = '//doxy.s3.amazonaws.com/';

    SirTrevor.EventBus.trigger("onUploadStart");
    console.log('file ',file);
    var uid  = [block.blockID, (new Date()).getTime(), 'raw'].join('-');
    var data = new FormData();

    data.append('attachment[name]', file.name);
    data.append('attachment[file]', file);
    data.append('attachment[uid]', uid);

    block.resetMessages();

    var imageUploadPath = SirTrevor.DEFAULTS.uploadUrl + uid + file.name;
    //var imageUploadPath = SirTrevor.DEFAULTS.uploadUrl + uid + file.name;

    var callbackSuccess = function(data){
      SirTrevor.log('Upload callback called');
      SirTrevor.EventBus.trigger("onUploadStop");

      if (!_.isUndefined(success) && _.isFunction(success)) {
        _.bind(success, block)({file: {url:imageUploadPath}});
      }
    };

    var callbackError = function(jqXHR, status, errorThrown){
      SirTrevor.log('Upload callback error called');
      SirTrevor.EventBus.trigger("onUploadStop");

      if (!_.isUndefined(error) && _.isFunction(error)) {
        _.bind(error, block)(status);
      }
    };

    console.log("someurl" + imageUploadPath);

    var xhr = $.ajax({
        type: "PUT",
        url: imageUploadPath,
        contentType: file.type,
        processData: false,
        data: file,
        cache: false
    });

    block.addQueuedItem(uid, xhr);

    xhr.done(callbackSuccess)
       .fail(callbackError)
       .always(_.bind(block.removeQueuedItem, block, uid));

    return xhr;
  };
