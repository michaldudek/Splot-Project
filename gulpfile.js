var gulp = require('gulp'),
    less = require('gulp-less');

gulp.task('less', function() {
    return gulp.src('web/less/**/*.less')
        .pipe(less())
        .pipe(gulp.dest('web/css'));
});

gulp.task('watch', function() {
    gulp.watch('web/less/**/*.less', ['less']);
});

gulp.task('default', ['less']);