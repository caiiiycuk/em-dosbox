Dosbox.UI
=========

CSS+JS that implements js-dos look and feel

Usage:
```javascript
new Dosbox.UI({id: 'divId'});
```

Constructor arguments:
* id - id of dom element where dosbox will be created


    class Dosbox.UI

      constructor: (options) ->
        @appendCss()
        @div = $('#' + (options.id || 'dosbox'))

        @wrapper = $('<div class="dosbox-container">')
        @canvas = $('<canvas class="dosbox-canvas" oncontextmenu="event.preventDefault()">')
        @overlay = $('<div class="dosbox-overlay">')
        @loaderMessage = $('<div class="dosbox-loader-message">')

        @loader =
          $('<div class="dosbox-loader">')
            .append($('<div class="st-loader">').append($('<span class="equal">')))
            .append(@loaderMessage)

        @start = $('<div class="dosbox-start">Click to start')

        @div.append(@wrapper)
        
        @wrapper.append(@canvas)
        @wrapper.append(@loader)
        @wrapper.append(@overlay)

        @overlay
          .append($('<div class="dosbox-powered">Powered by &nbsp;')
          .append($('<a href="http://js-dos.com">js-dos.com')))
        @overlay.append(@start)

      onStart: (fun) ->
        @start.click () =>
          fun()
          @overlay.hide()

      appendCss: ->
        head = document.head || document.getElementsByTagName('head')[0]
        style = document.createElement('style')

        style.type = 'text/css'

        if style.styleSheet
          style.styleSheet.cssText = @css
        else
          style.appendChild document.createTextNode(@css)
        
        head.appendChild style

      showLoader: ->
        @loader.show()
        @loaderMessage.html ''

      updateMessage: (message) ->
        @loaderMessage.html message

      hideLoader: ->
        @loader.hide()

      css: '
    .dosbox-container {
      position: relative;
      min-width: 320px;
      min-height: 200px;
    }

    .dosbox-canvas {
    }

    .dosbox-overlay, .dosbox-loader {
      position: absolute;
      left: 0;
      right: 0;
      top: 0;
      bottom: 0;
      background-color: #333;
    }

    .dosbox-start {
      text-align: center;
      position: absolute;
      left: 0;
      right: 0;
      bottom: 50%;
      color: #f80;
      font-size: 1.5em;
      text-decoration: underline;
      cursor: pointer;
    }

    .dosbox-overlay a {
      color: #f80;
    }

    .dosbox-loader {
      display: none;
    }

    .dosbox-powered {
      position: absolute;
      right: 1em;
      bottom: 1em;
      font-size: 0.8em;
      color: #9C9C9C;
    }

    .dosbox-loader-message {
      text-align: center;
      position: absolute;
      left: 0;
      right: 0;
      bottom: 50%;
      margin: 0 0 -3em 0;
      box-sizing: border-box;
      color: #f80;
      font-size: 1.5em;
    }

    @-moz-keyframes loading {
      0% {
        left: 0;
      }
      50% {
        left: 8.33333em;
      }
      100% {
        left: 0;
      }
    }
    @-webkit-keyframes loading {
      0% {
        left: 0;
      }
      50% {
        left: 8.33333em;
      }
      100% {
        left: 0;
      }
    }
    @keyframes loading {
      0% {
        left: 0;
      }
      50% {
        left: 8.33333em;
      }
      100% {
        left: 0;
      }
    }
    .st-loader {
      width: 10em;
      height: 2.5em;
      position: absolute;
      top: 50%;
      left: 50%;
      margin: -1.25em 0 0 -5em;
      box-sizing: border-box;
    }

    .st-loader:before,
    .st-loader:after {
      content: "";
      display: block;
      position: absolute;
      top: 0;
      bottom: 0;
      width: 1.25em;
      box-sizing: border-box;
      border: 0.25em solid #f80;
    }

    .st-loader:before {
      left: -0.76923em;
      border-right: 0;
    }

    .st-loader:after {
      right: -0.76923em;
      border-left: 0;
    }

    .st-loader .equal {
      display: block;
      position: absolute;
      top: 50%;
      margin-top: -0.5em;
      left: 4.16667em;
      height: 1em;
      width: 1.66667em;
      border: 0.25em solid #f80;
      box-sizing: border-box;
      border-width: 0.25em 0;
      -moz-animation: loading 1.5s infinite ease-in-out;
      -webkit-animation: loading 1.5s infinite ease-in-out;
      animation: loading 1.5s infinite ease-in-out;
    }
    '