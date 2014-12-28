var gulp = require('gulp');
var gutil = require('gulp-util');
var coffee = require('gulp-coffee');
var concat = require('gulp-concat');
var coffeelint = require('gulp-coffeelint');
var runSequence = require('run-sequence');
var docco = require("gulp-docco");

gulp.task('default', function(callback) {
  runSequence('coffeelint', 'coffee', 'js-dos', 'concat', 'test', 'docco', callback);
});

gulp.task('coffee', function() {
  return gulp.src('./src/*.*coffee')
    .pipe(coffee().on('error', gutil.log))
    .pipe(gulp.dest('./dist/js/'));
});

gulp.task('coffeelint', function() {
  return gulp.src('./src/*.*coffee')
    .pipe(coffeelint('coffeelint.json'))
    .pipe(coffeelint.reporter());
});

gulp.task('concat', function() {
  return gulp.src(['./src/jqlite.1.1.1.min.js', './dist/js/js-dos-core.js', './dist/js/*.js'])
    .pipe(concat('js-dos-api.js'))
    .pipe(gulp.dest('./dist/'));
});

gulp.task('js-dos', function() {
  return gulp.src('./js/js-dos.js')
    .pipe(gulp.dest('./dist/'));
});

gulp.task('test', function() {
  return gulp.src('./test/*')
    .pipe(gulp.dest('./dist/'));
});

gulp.task('docco', function() {
  return gulp.src("./src/*.*coffee")
    .pipe(docco())
    .pipe(gulp.dest('./dist/docs'));
});


gulp.task('watch', function() {
  gulp.watch(['./src/*.*coffee'], ['coffee']);
  gulp.watch(['./js/js-dos.js'], ['js-dos']);
  gulp.watch(['./dist/js/*.js'], ['concat']);
  gulp.watch(['./test/*'], ['test']);
});
