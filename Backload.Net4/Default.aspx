﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Backload.Net4.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title></title>

  <%-- Bootstrap & jquery --%>
  <link href="Content/bootstrap.min.css" rel="stylesheet" />
  <script src="Scripts/jquery-3.1.0.min.js" type="text/javascript"></script>
  <script src="Scripts/bootstrap.min.js" type="text/javascript"></script>

  <%-- backload for blueimp javascript --%>
  <script src="Backload/Client/blueimp/blob/js/canvas-to-blob.min.js"></script>
  <script src="Backload/Client/blueimp/gallery/js/jquery.blueimp-gallery.min.js"></script>
  <script src="Backload/Client/blueimp/loadimage/js/load-image.all.min.js"></script>
  <script src="Backload/Client/blueimp/templates/js/tmpl.min.js"></script>

  <%-- backload for blueimp plugin javascript --%>
  <script src="Backload/Client/blueimp/fileupload/js/vendor/jquery.ui.widget.js"></script>
  <script src="Backload/Client/blueimp/fileupload/js/jquery.iframe-transport.js"></script>
  <script src="Backload/Client/blueimp/fileupload/js/jquery.fileupload.js"></script>
  <script src="Backload/Client/blueimp/fileupload/js/jquery.fileupload-process.js"></script>
  <script src="Backload/Client/blueimp/fileupload/js/jquery.fileupload-image.js"></script>
  <script src="Backload/Client/blueimp/fileupload/js/jquery.fileupload-audio.js"></script>
  <script src="Backload/Client/blueimp/fileupload/js/jquery.fileupload-video.js"></script>
  <script src="Backload/Client/blueimp/fileupload/js/jquery.fileupload-validate.js"></script>
  <script src="Backload/Client/blueimp/fileupload/js/jquery.fileupload-ui.js" charset="euc-kr"></script>
  <script src="Backload/Client/blueimp/fileupload/js/themes/jquery.fileupload-themes.js"></script>

  <%-- backload for blueimp styles --%>
  <link href="Backload/Client/blueimp/gallery/css/blueimp-gallery.min.css" rel="stylesheet" />
  <link href="Backload/Client/blueimp/fileupload/css/jquery.fileupload.css" rel="stylesheet" />
  <link href="Backload/Client/blueimp/fileupload/css/jquery.fileupload-ui.css" rel="stylesheet" />

  <%--my fileupload handler javascript--%>
  <script src="Scripts/fileuploadhandler.js"></script>

  <style type="text/css">
    body {
      padding: 12px;
    }

    .navbar {
      padding-top: 8px;
      padding-left: 10px;
    }

    .toggle {
      display: inline-block !important;
    }

    .dragndrop {
      text-align: center;
      line-height: 22em;
    }

    .name {
      width: 100% !important;
    }
  </style>

  <script type="text/javascript">
    var uploadedFiles = [{ name: null, type: null, size: 0 }];

    $(document).ready(function () {

      // get guid (see http://stackoverflow.com/a/2117523/1201067)
      var guid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
      });

      $("#uploadContext").val(guid);
    });

    // check same file and remove from ui
    function checkUploadedFile(file) {
      var result = false;

      if (file.name.length > 104) {
        return true;
      }

      $.each(uploadedFiles, function (idx, f) {
        if (f.name === file.name && f.type == file.type && f.size === file.size) {
          result = true;
          // break;
          return false;
        }
      });

      if (!result) {
        var item = { name: file.name, type: file.type, size: file.size };
        uploadedFiles.push(item);
      }

      return result;
    }

    // remove ui when cancel button click
    function removeUploadedFile(data) {
      // data is 'name|type|size' format
      var arr = data.split('|');
      var item = { name: arr[0], type: arr[1], size: parseInt(arr[2]) };
      var index = 0;

      // get delete uploadedFiles index
      $.each(uploadedFiles, function (idx, f) {
        if (f.name === item.name && f.type === item.type && f.size === item.size)
          index = idx;
      });

      // delete
      uploadedFiles.splice(index, 1);
    }

    // rename file from {guid}_filename to filename.
    function getFileName(file) {
      var len = file.length;
      var index = file.indexOf('_') + 1;
      return file.substring(index, len);
    }
  </script>
</head>
<body>
  <!-- The file upload form used as target for the file upload widget -->
  <form id="fileupload" action="FileUploadHandler.ashx?objectContext=Uploads" method="POST" enctype="multipart/form-data">
    <div class="navbar navbar-default navbar-fixed-top" style="margin-bottom: 5px;">
      <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->
      <div class="fileupload-buttonbar">
        <!-- The fileinput-button span is used to style the file input field as button -->
        <span class="btn btn-success fileinput-button">
          <i class="glyphicon glyphicon-plus"></i>
          <span>Add files...</span>
          <input type="file" name="files[]" multiple>
        </span>
        <button type="submit" class="btn btn-primary start">
          <i class="glyphicon glyphicon-upload"></i>
          <span>Start upload</span>
        </button>
        <button type="reset" class="btn btn-warning cancel">
          <i class="glyphicon glyphicon-ban-circle"></i>
          <span>Cancel upload</span>
        </button>
        <button type="button" class="btn btn-danger delete">
          <i class="glyphicon glyphicon-trash"></i>
          <span>Delete</span>
        </button>
        <input type="checkbox" class="toggle">
        <!-- The global file processing state -->
        <span class="fileupload-process"></span>

        <p id="filecountgroup">
          <%--Files count & size--%>
          Now:&nbsp;
          <span id="file-count">0</span>
          EA&nbsp;/
          <span id="file-size">0 KB</span>

          <%--Max files count & size--%>
          &nbsp;&nbsp;&nbsp;
          MAX:&nbsp;
          <span id="file-max-count">10</span>
          EA&nbsp;/
          <span id="file-max-size">10</span>
          MB
        </p>
      </div>
    </div>

    <%--dropzone--%>
    <div id="dropzone" class="panel panel-default dragndrop" style="height: 400px; margin-top: 80px;">
      <div class="panel-body">
        <span>Drag & Drop files here!</span>
      </div>
    </div>

    <div class="container-fluid">
      <div class="row">
        <!-- The global progress state -->
        <div class="fileupload-progress fade">
          <!-- The global progress bar -->
          <div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100">
            <div class="progress-bar progress-bar-success" style="width: 0%;"></div>
          </div>
          <!-- The extended global progress state -->
          <div class="progress-extended">&nbsp;</div>
        </div>
      </div>

      <div class="row">
        <!-- The table listing the files available for upload/download -->
        <table role="presentation" class="table table-striped">
          <tbody class="files"></tbody>
        </table>
      </div>
    </div>

    <%--object context & upload context--%>
    <input id="uploadContext" type="hidden" name="uploadContext" value="" />
  </form>

  <!-- The blueimp Gallery widget -->
  <div id="blueimp-gallery" class="blueimp-gallery blueimp-gallery-controls" data-filter=":even">
    <div class="slides"></div>
    <h3 class="title"></h3>
    <a class="prev">‹</a>
    <a class="next">›</a>
    <a class="close">×</a>
    <a class="play-pause"></a>
    <ol class="indicator"></ol>
  </div>

  <!-- The template to display files available for upload -->
  <script id="template-upload" type="text/x-tmpl">
            {% for (var i=0, file; file=o.files[i]; i++) { %}
            {% if (checkUploadedFile(file)) continue; %}
            <tr class="template-upload fade">
                <td>
                    <p class="name">{%=file.name%}</p>
                    <strong class="error text-danger"></strong>
                </td>
                <td>
                    <p class="size">Processing...</p>
                    <div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0"><div class="progress-bar progress-bar-success" style="width:0%;"></div></div>
                </td>
                <td>
                    {% if (!i && !o.options.autoUpload) { %}
                    <button class="btn btn-primary start" disabled>
                        <i class="glyphicon glyphicon-upload"></i>
                        <span>Start</span>
                    </button>
                    {% } %}
                    {% if (!i) { %}
                    <button class="btn btn-warning cancel" value="{%= file.name + '|' + file.type + '|' + file.size %}" onclick="removeUploadedFile($(this).val());">
                        <i class="glyphicon glyphicon-ban-circle"></i>
                        <span>Cancel</span>
                    </button>
                    {% } %}
                </td>
            </tr>
            {% } %}
  </script>

  <!-- The template to display files available for download -->
  <script id="template-download" type="text/x-tmpl">
            {% for (var i=0, file; file=o.files[i]; i++) { %}
            <tr class="template-download fade">
                <td>
                    <p class="name">
                        <span>
                              {%=file.extra.message%}
                              {%=getFileName(file.name)%}
                        </span>
                    </p>
                    {% if (file.error) { %}
                    <div><span class="label label-danger">Error</span> {%=file.error%}</div>
                    {% } %}
                </td>
                <td>
                    <span class="size">{%=o.formatFileSize(file.size)%}</span>
                </td>
                <td>
                    {% if (file.deleteUrl) { %}
                    <button class="btn btn-danger delete" data-type="{%=file.deleteType%}" data-url="{%=file.deleteUrl%}" {% if (file.deletewithcredentials) { %} data-xhr-fields='{"withCredentials":true}' {% } %}>
                        <i class="glyphicon glyphicon-trash"></i>
                        <span>Delete</span>
                    </button>
                    <input type="checkbox" name="delete" value="1" class="toggle">
                    {% } else { %}
                    <button class="btn btn-warning cancel">
                        <i class="glyphicon glyphicon-ban-circle"></i>
                        <span>Cancel</span>
                    </button>
                    {% } %}
                </td>
            </tr>
            {% } %}
  </script>
</body>
</html>
