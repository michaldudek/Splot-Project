var gulp = require('gulp'),
    util = require('gulp-util'),
    less = require('gulp-less'),
    minifyCss = require('gulp-minify-css'),
    sourcemaps = require('gulp-sourcemaps'),
    uglify = require('gulp-uglify'),
    rev = require('gulp-rev'),
    concat = require('gulp-concat');

gulp.task('less', function() {
    return gulp.src('web/less/app.less')
        .pipe(sourcemaps.init())
            .pipe(less())
            .pipe(minifyCss())
            .pipe(rev())
        .pipe(sourcemaps.write('./'))
        .pipe(gulp.dest('web/assets'));
});

gulp.task('js_libs', function() {
    return gulp.src([
        'web/components/lodash/lodash.js',
        
        //'web/components/q/q.js',
        
        'web/components/jquery/dist/jquery.js',
        'web/components/jquery-appendix/src/jquery.appendix.js',
        'web/components/jquery-autosize/dist/autosize.js',
        'web/components/angular/angular.js',
        'web/components/angular-animate/angular-animate.js',
        'web/components/angular-bindonce/bindonce.js',
        'web/components/angular-cookies/angular-cookies.js',
        'web/components/angular-ui-router/release/angular-ui-router.js'

        // jquery file upload - enable if you please
        //'web/components/blueimp-file-upload/js/jquery.iframe-transport.js',
        //'web/components/blueimp-file-upload/js/jquery.fileupload.js',
        //'web/components/blueimp-file-upload/js/jquery.fileupload-process.js',
        //'web/components/blueimp-file-upload/js/jquery.fileupload-validate.js',
        //'web/components/blueimp-file-upload/js/jquery.fileupload-angular.js',

        // Bootstrap - enable as needed
        //'web/components/bootstrap/js/affix.js',
        //'web/components/bootstrap/js/alert.js',
        //'web/components/bootstrap/js/button.js',
        //'web/components/bootstrap/js/carousel.js',
        //'web/components/bootstrap/js/collapse.js',
        //'web/components/bootstrap/js/dropdown.js',
        //'web/components/bootstrap/js/modal.js',
        //'web/components/bootstrap/js/popover.js',
        //'web/components/bootstrap/js/scrollspy.js',
        //'web/components/bootstrap/js/tab.js',
        //'web/components/bootstrap/js/tooltip.js',
        //'web/components/bootstrap/js/transition.js',

        // Angular Strap - enable as needed
        //'web/components/angular-strap/dist/modules/date-parser.js',
        //'web/components/angular-strap/dist/modules/datepicker.js',
        //'web/components/angular-strap/dist/modules/datepicker.tpl.js',
        //'web/components/angular-strap/dist/modules/dimensions.js',
        //'web/components/angular-strap/dist/modules/modal.js',
        //'web/components/angular-strap/dist/modules/modal.tpl.js',
        //'web/components/angular-strap/dist/modules/timepicker.js',
        //'web/components/angular-strap/dist/modules/timepicker.tpl.js',
        //'web/components/angular-strap/dist/modules/tooltip.js',
        //'web/components/angular-strap/dist/modules/tooltip.tpl.js',
    ]).pipe(sourcemaps.init())
            .pipe(uglify().on('error', util.log))
            .pipe(concat('libs.js'))
            .pipe(rev())
        .pipe(sourcemaps.write('./'))
        .pipe(gulp.dest('web/assets'));
});

gulp.task('js', function() {
    return gulp.src('web/js/**/*.js')
        .pipe(sourcemaps.init())
            .pipe(uglify())
            .pipe(concat('app.js'))
            .pipe(rev())
        .pipe(sourcemaps.write('./'))
        .pipe(gulp.dest('web/assets'))
});

gulp.task('watch', function() {
    gulp.watch('web/less/**/*.less', ['less']);
    gulp.watch('web/js/**/*.js', ['js']);
});

gulp.task('default', ['less', 'js_libs', 'js']);
