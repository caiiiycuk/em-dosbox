Dosbox.Xhr
==========

Wrapper on XMLHttpRequest or ActiveXObject to make Ajax calls.

Usage:
```javascript
new Dosbox.Xhr(url, {
  success: callback(responseText) { ... },
  progress: callback(current, total) { ... }
})
```

    class Dosbox.Xhr

      constructor: (url, options) ->
        @success = options.success
        @progress = options.progress

        if window.ActiveXObject
          try
            @xhr = new ActiveXObject 'Microsoft.XMLHTTP'
          catch e
            @xhr = null
        else
          @xhr = new XMLHttpRequest()

        @xhr.open 'GET', url, true
        @xhr.overrideMimeType 'text/plain; charset=x-user-defined'
        @xhr.addEventListener 'progress', (evt) =>
          if @progress
            @progress evt.total, evt.loaded
        @xhr.onreadystatechange = () => @_onReadyStateChange()
        
        @xhr.send()

      _onReadyStateChange: ->
        if @xhr.readyState == 4 and @success
          @success @xhr.responseText
