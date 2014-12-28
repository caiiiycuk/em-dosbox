Dosbox interface
================

Dosbox bootstrapping interface. Interface provides single class called `Dosbox`, this
class is used to bootsrap and control dosbox.

    class @Dosbox

Bootstrapping
-------------

To bootsrap dosbox use this javascript code:
```javascript
  <script type="text/javascript" src="js-dos-api.js"></script>
  <script type="text/javascript">
    new Dosbox({
      id: "dosbox",
      onload: function (dosbox) {
        dosbox.run("digger.zip", "./DIGGER.COM");
      },
      onrun: function (dosbox, app) {
        console.log("App '" + app + "' is runned");
      }
    });
  </script>
```

Where:
* id - element id where dosbox will create dosbox canvas
* onload - callback was called when dosbox is initialized
* onrun - callback was called when dos application was runned

      constructor: (options) ->
        @onload = options.onload
        @onrun = options.onrun
        @ui = new Dosbox.UI(options)
        @module = new Dosbox.Module canvas: @ui.canvas

        @ui.onStart () =>
          @ui.showLoader()
          @downloadScript()

dosbox.run
----------

This method is used to mount zip archives to virtual filesystem and 
then to run dos program. First argument is url where zip archive is located, 
second is a executable name.

Archive will be downloaded, extracted and then program will be runned.

      run: (archiveUrl, executable) ->
        new Dosbox.Mount @module, archiveUrl,
          success: () =>
            @ui.updateMessage "Launching #{executable}"
            hide = () => @ui.hideLoader()
            func = () => @_dosbox_main @, executable
            setTimeout(func, 1000)
            setTimeout(hide, 3000)
          progress: (total, current) =>
            @ui.updateMessage "Mount #{executable} (#{current * 100 / total | 0}%)"

Fullscreen
----------

You can change fullscreen mode by calling `dosbox.requestFullScreen()`

      requestFullScreen: ->
        if @module.requestFullScreen
          @module.requestFullScreen(true, false)

Styling dosbox canvas
----------------------

You can change dosbox canvas size with css, like this:
```css
  <style type="text/css">
    .dosbox-container { width: 640px; height: 400px; }
  </style>  
```

Digger example
--------------

```html
<!doctype html>
<html lang="en-us">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>js-dos api</title>
    <style type="text/css">
      .dosbox-container { width: 640px; height: 400px; }
    </style>
  </head>
  <body>
    <div id="dosbox"></div>
    <br/>
    <button onclick="dosbox.requestFullScreen();">Make fullscreen</button>
    <script type="text/javascript" src="js-dos-api.js"></script>
    <script type="text/javascript">
      var dosbox = new Dosbox({
        id: "dosbox",
        onload: function (dosbox) {
          dosbox.run("digger.zip", "./DIGGER.COM");
        },
        onrun: function (dosbox, app) {
          console.log("App '" + app + "' is runned");
        }
      });
    </script>
  </body>
</html>
```

      downloadScript: ->
        @module.setStatus 'Downloading js-dos'
        @ui.updateMessage 'Downloading js-dos'

        new Dosbox.Xhr 'js-dos.js',
          success: (script) =>
            @ui.updateMessage 'Initializing dosbox'
            func = () => @_jsdos_init @module, script, @onload
            setTimeout(func, 1000)

          progress: (total, current) =>
            @ui.updateMessage "Downloading js-dos (#{current * 100 / total | 0}%)"

      _jsdos_init: (module, script, onload) ->
        Module = module
        eval script
        onload @ if onload

      _dosbox_main: (dosbox, executable) ->
        try
          if dosbox.onrun
            func = () -> dosbox.onrun(dosbox, executable)
            setTimeout(func, 1000)

          dosbox.module.ccall 'dosbox_main', 'int', ['string'], [executable]
        catch exception
          if exception == 'SimulateInfiniteLoop'
            # do nothing this is normal behaviour
          else
            console?.error? exception

