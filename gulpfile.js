/* jshint node: true */
'use strict';

var fs = require('fs'),
    jsonMinify = require('jsonminify'),
    _ = require('lodash'),
    gulp = require('gulp'),
    less = require('gulp-less'),
    minifyCss = require('gulp-minify-css'),
    sourcemaps = require('gulp-sourcemaps'),
    uglify = require('gulp-uglify'),
    ngAnnotate = require('gulp-ng-annotate'),
    jshint = require('gulp-jshint'),
    rev = require('gulp-rev'),
    concat = require('gulp-concat'),
    clean = require('gulp-clean');

/*
 * CSS (LESS) TASKS
 */
// dynamically generate tasks for all the packages
var cssPackages = ['lib', 'app'];
_.forEach(cssPackages, function(name) {
    // clean generated files
    gulp.task('less:' + name + ':clean', function() {
        return gulp.src('web/assets/' + name + '-*.css{.map,}', {read: false})
            .pipe(clean());
    });

    // compile appropriate less file
    gulp.task('less:' + name, ['less:' + name + ':clean'], function() {
        return gulp.src('web/less/' + name + '.less')
            .pipe(sourcemaps.init())
                .pipe(less())
                .pipe(minifyCss({
                    processImport : false
                }))
                .pipe(rev())
            .pipe(sourcemaps.write('./'))
            .pipe(gulp.dest('web/assets'));
    });
});

// general less task that compiles all the files
gulp.task('less', _.map(cssPackages, function(name) {
    return 'less:' + name;
}));

/*
 * JAVASCRIPT TASKS
 */
// this is a manifest of which files should go into what packages
var jsPackages = JSON.parse(jsonMinify(fs.readFileSync('./js-build.json', 'utf8')));

// dynamically generate tasks for all the packages
_.forEach(jsPackages, function(files, name) {
    // clean generated files
    gulp.task('js:' + name + ':clean', function() {
        return gulp.src('web/assets/' + name + '-*.js{.map,}', {read: false})
            .pipe(clean());
    });

    // compile package files
    gulp.task('js:' + name, ['js:' + name + ':clean'], function() {
        return gulp.src(files)
            .pipe(sourcemaps.init())
                .pipe(ngAnnotate())
                .pipe(uglify())
                .pipe(concat(name + '.js'))
                .pipe(rev())
            .pipe(sourcemaps.write('./'))
            .pipe(gulp.dest('web/assets'));
    });
});

// general js task that compiles all the js files
var jsTasks = _.map(_.keys(jsPackages), function(name) {
    return 'js:' + name;
});
gulp.task('js', jsTasks);

// lint all the js files
gulp.task('js:lint', function() {
    var config = JSON.parse(jsonMinify(fs.readFileSync('./.jshintrc', 'utf8')));
    config.lookup = false;
    return gulp.src('web/js/**/*.js')
        .pipe(jshint(config))
        .pipe(jshint.reporter('jshint-stylish'));
});

/*
 * WATCHING
 */
gulp.task('watch', function() {
    // watch files from each package separately and then some
    _.forEach(cssPackages, function(name) {
        gulp.watch([
            // common global includes
            'web/less/lib/lesselements.less',
            'web/less/_varmix.less',
            // the package file itself
            'web/less/' + name + '.less',
            // the files that the package usually imports
            'web/less/' + name + '/**/*.less'
        ], ['less:' + name]);
    });

    // watch files from each package separately
    _.forEach(jsPackages, function(files, name) {
        gulp.watch(files, ['js:' + name]);
    });
});

/*
 * DEFAULT BUILD ALL
 */
gulp.task('default', ['less', 'js']);
