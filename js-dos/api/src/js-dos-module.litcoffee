Dosbox.Module
=============

Wrapper for emscripten module that also holds canvas element

Usage:
```javascript
new Dosbox.Module({canvas: canvas});
```

Constructor arguments:
* canvas - dom element it is used to render dosbox screen

    class Dosbox.Module

      constructor: (options) ->
        @elCanvas = options.canvas
        @canvas = @elCanvas[0]

      preRun: []

      postRun: []

      totalDependencies: 0

      # SDL_numSimultaneouslyQueuedBuffers: 1

      print: (text) ->
        text = Array::slice.call(arguments).join(' ')
        console?.log? text

      printErr: (text) ->
        text = Array::slice.call(arguments).join(' ')
        console?.error? text

      setStatus: (text) ->
        console?.log? text

      monitorRunDependencies: (left) ->
        @totalDependencies = Math.max(@totalDependencies, left)
        status =
          if left
            "Preparing... (#{@totalDependencies - left}/#{@totalDependencies})"
          else
            'All downloads complete.'
        @setStatus status
