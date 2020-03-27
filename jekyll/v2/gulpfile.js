'use strict';

const sass = require('gulp-sass');

const {series, parallel, watch, src, dest} = require('gulp');
const log = require('fancy-log');

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
const size = require('gulp-size');
const rimraf = require('gulp-rimraf');
const wait = require('gulp-wait2');

const del = require('del');
const fs = require('fs');

const options = {sourcemaps: true, buffer: true, allowEmpty: false};

const paths = {
  css: {
    src: './_vendor/css/*.css',
    dest: './assets/css',
    file: 'vendor.min.css'
  },
  sass: {
    src: './_sass/*.scss',
    dest: './assets/css',
    file: 'site.min.css'
  },
  js: {
    src: [
      '_vendor/js/jquery-3.4.1.min.js',
      '_vendor/js/jquery.fitvids.js',
      '_vendor/js/jquery.waypoints.min.js',
      '_vendor/js/popper.min.js',
      '_vendor/js/bootstrap.min.js',
      '_vendor/js/easing-effect.js',
      '_vendor/js/lightbox.min.js',
      '_vendor/js/isotope.pkgd.min.js',
      '_vendor/js/owl.carousel.min.js',
      '_vendor/js/owl.navigation.js',
      '_vendor/js/prism.js',
      '_vendor/js/wow.min.js',
    ],
    sourcemaps: [
      '_vendor/js/lightbox.min.map',
      '_vendor/js/bootstrap.min.js.map',
      '_vendor/css/bootstrap.min.css.map',
    ],
    dest: 'assets/js',
    file: 'site.min.js'
  },
  assets: {
    src: [
      'assets/js/site.min.js',
      'assets/css/vendor.min.css',
      'assets/css/site.min.css',
    ],
    dest: './_site'
  }
};

function mkdirs(folders) {
  return (async () => {
    folders.forEach(dir => {
      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir);
        log.info('📁 created:', dir);
      }
    });
  })();
}

function rm_rf(files) {
  return (async () => {
    const deletedPaths = del.sync(files, {dryRun: false});
    if (deletedPaths.length > 0)
      log.info('🧨 Deleted: ', deletedPaths)
  })();
}

function folders() {
  return mkdirs(['./assets/css', './_site', './_site/assets', './_site/assets/css', './_site/assets/js']);
}

function clean() {
  let files = [].concat(paths.assets.src);
  files.push('._site/**/*');

  return rm_rf(files);
}

function site_css() {
  return src(paths.sass.src, options)
      .pipe(plumber())
      .pipe(sass.sync()
          .on('error', sass.logError)
          .on('end', callback('Sass.compile()', 'OK'))
      )
      .pipe(autoprefixer())
      .pipe(rename(paths.sass.file).on('end', callback('Sass.rename()', 'OK')))
      .pipe(cleanCSS().on('end', callback('Sass.cleanCSS()', 'OK')))
      .pipe(size().on('end', callback('CSS.size()', 'OK')))
      .pipe(dest(paths.sass.dest).on('end', callback('CSS.dest()', 'OK')))
}

function callback(operation, result) {
  return function () {
    log("    ", (result === 'OK') ? ' ✅ ' : result, operation);
  }
}

function vendor_css() {
  return src(paths.css.src, {sourcemaps: true, buffer: true, allowEmpty: false})
      .pipe(concat(paths.css.file))
      .pipe(autoprefixer())
      .pipe(cleanCSS())
      .pipe(size().on('end', callback('CSS size()', 'OK')))
      .pipe(dest(paths.css.dest));
}

function vendor_js() {
  return src(paths.js.src, {sourcemaps: true, buffer: true, allowEmpty: false})
      .pipe(concat(paths.js.file).on('end', callback('JS.concat()', 'OK')))
      .pipe(terser( {ecma: 6} ).on('end', callback('JS.terser()', 'OK')))
      .pipe(dest(paths.js.dest).on('end', callback('JS.terser()', 'OK')))
}

function vendor_js_sourcemaps(cb) {
  return src(paths.js.sourcemaps, {sourcemaps: true, buffer: true, allowEmpty: false})
      .pipe(dest(paths.js.dest).on('end', callback('JS Source Maps.dest()', 'OK')))
}

function assets() {
  return src(paths.assets.src, {sourcemaps: true, buffer: true, allowEmpty: true})
      .pipe(copy(paths.assets.dest, {prefix: 0}).on('end', callback('Assets.copy()', 'OK')))
      .pipe(dest(paths.assets.dest).on('end', callback('Assets.dest()', 'OK')))
}


function watch_files() {
  watch('./_sass/**/*.scss', series(site_css, assets));
  watch('./_vendor/css/**/*.css', series(vendor_css, assets));
  watch('./_vendor/js/**/*.js', series(vendor_js, assets));
}

exports.site_css = site_css;
exports.vendor_css = vendor_css;

exports.css = series(
    folders,
    parallel(
        site_css,
        vendor_css,
    ),
);

exports.js = vendor_js;
exports.folders = folders;

exports.build_assets = series(
    folders,
    parallel(
        site_css,
        vendor_css,
        vendor_js,
    ),
    assets
);

exports.clean = clean;
exports.watch = series(
    folders,
    watch_files
);

exports.default = exports.build = series(
    clean,
    folders,
    parallel(
        site_css,
        vendor_css,
        vendor_js,
    ),
    assets
);
