'use strict';

const {series, parallel, watch, src, dest} = require('gulp');

const sass = require('gulp-sass');
sass.compiler = require('node-sass');

const cleanCSS = require('gulp-clean-css');
const sourcemaps = require('gulp-sourcemaps');
const autoprefixer = require('gulp-autoprefixer');
const copy = require('gulp-copy');
const concat = require('gulp-concat');
const rename = require('gulp-rename');
const terser = require('gulp-terser');
const jshint = require('gulp-jshint');
const plumber = require('gulp-plumber');
const livereload = require('gulp-livereload');
const size = require('gulp-size');
const uglify = require('gulp-uglify');

const del = require('del');
const fs = require('fs');

const paths = {
  css: {
    src: '_vendor/css/*.css',
    dest: 'assets/css',
    file: 'vendor.min.css'
  },
  sass: {
    src: '_sass/*.scss',
    dest: 'assets/css',
    file: 'site.min.css'
  },
  js: {
    src: [
      './_vendor/js/jquery-3.4.1.min.js',
      './_vendor/js/jquery.fitvids.js',
      './_vendor/js/jquery.waypoints.min.js',
      './_vendor/js/popper.js',
      './_vendor/js/lightbox.min.js',
      './_vendor/js/bootstrap.min.js',
      './_vendor/js/easing-effect.js',
      './_vendor/js/fontawesome.min.js',
      './_vendor/js/isotope.pkgd.min.js',
      './_vendor/js/owl.carousel.min.js',
      './_vendor/js/owl.navigation.js',
      './_vendor/js/prism.js',
      './_vendor/js/wow.min.js',
      './assets/js/app.js',
    ],
    sourcemaps: [
      './_vendor/js/lightbox.min.map',
    ],
    dest: 'assets/js',
    file: 'site.min.js'
  }
};

function folders(cb) {
  const folders = [
    './assets/css',
    './assets/js',
  ];

  folders.forEach(dir => {
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir);
      console.log('📁 folder created:', dir);
    }
  });

  cb();
}


function clean(cb) {
  del([
    paths.sass.dest + '/' + paths.sass.file,
    paths.css.dest + '/' + paths.css.file,
    paths.js.dest + '/' + paths.js.file
  ]);
  cb();
};

function serve(cb) {
  livereload.listen({
    host: 'localhost',
    port: '2368',
    start: true
  });
  cb();
};


function site_sass(cb) {
  src(paths.sass.src, {sourcemaps: true})
      .pipe(sass.sync().on('error', sass.logError))
      .pipe(plumber({}))
      .pipe(autoprefixer())
      .pipe(rename(paths.sass.file))
      .pipe(cleanCSS())
      .pipe(size())
      .pipe(dest(paths.sass.dest))
      .pipe(livereload());

  var sass_source = paths.sass.dest + '/' + paths.sass.file;

  del(['_site/' + sass_source]);

  src(sass_source)
      .pipe(plumber({}))
      .pipe(copy('_site'))
      .pipe(dest('_site'));
  cb();
}

function vendor_css(cb) {
  src(paths.css.src)
      .pipe(plumber({}), {sourcemaps: true})
      .pipe(concat(paths.css.file))
      .pipe(autoprefixer())
      .pipe(cleanCSS())
      .pipe(size())
      .pipe(dest(paths.css.dest))
      .pipe(livereload());
  cb();

}

function vendor_js(cb) {
  src(paths.js.src)
      .pipe(plumber({}))
      .pipe(concat(paths.js.file))
      .pipe(uglify())
      .pipe(terser())
      .pipe(dest(paths.js.dest));

  src(paths.js.sourcemaps)
      .pipe(plumber({}))
      .pipe(copy(paths.js.dest, {prefix: 3}))
      .pipe(dest(paths.js.dest));

  cb();
}

function watch_files(cb) {
  watch('./_sass/**/*.scss', site_sass);
  watch('./_vendor/css/**/*.css', vendor_css);
  watch('./_vendor/js/**/*.js', vendor_js);
}

exports.sass = site_sass;
exports.vendor_css = vendor_css;
exports.js = vendor_js;
exports.clean = clean;
exports.serve = serve;
exports.watch = watch_files;
exports.build = series(
    folders,
    clean,
    parallel(
        vendor_js,
        series(site_sass, vendor_css)
    ),
);
