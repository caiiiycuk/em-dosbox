# js-dos

The aim of the project is to provide nice web-API for em-dosbox.

## How to build

Follow to the guide: https://github.com/dreamlayers/em-dosbox/#compiling to build em-dosbox, and then:

```
cd js-dos
mkdir build
cd build
./emcmake cmake ../api
make -j4
```

## Building api

```
cd js-dos/api
npm install gulp gulp-coffee gulp-concat gulp-coffeelint gulp-docco run-sequence
gulp
```

Built will be in js-dos/api/dist folder, use test.html as example.