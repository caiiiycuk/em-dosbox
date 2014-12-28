Dosbox.Mount
============

This module is used to mount zip archives in virtual file system.

Usage:
```javascript
new Dosbox.Mount(module, url, {
  success: callback() { ... },
  progress: callback(current, total) { ... }
})
```

Constructor arguments:
* module - emscripten module
* url - where to get ZIP archive
* callbacks*


    class Dosbox.Mount
      constructor: (module, url, options) ->
        @module = module

        new Dosbox.Xhr url,
          success: (data) =>
            bytes = @_toArray data
            if @_mountZip(bytes)
              options.success()
            else
              console?.error? 'Unable to mount', url
          progress: options.progress

      _mountZip: (bytes) ->
        buffer = @module._malloc bytes.length
        @module.HEAPU8.set bytes, buffer
        extracted = @module.ccall 'extract_zip', 'int', ['number', 'number'], [buffer, bytes.length]
        @module._free buffer
        extracted == 0

      _toArray: (data) ->
        if typeof data is 'string'
          arr = new Array(data.length)
          i = 0
          len = data.length

          while i < len
            arr[i] = data.charCodeAt(i)
            ++i

          return arr

        data