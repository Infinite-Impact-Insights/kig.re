$(document ).ready(function() {

  $('#search-icon').on('click', function(event)  {
    $('#search-form').submit()
  });

  $('#search-form').on('submit', function(event)  {
     window.open("http://google.com/?site=kig.re&q=" +
          $("#search-query")[0].value +
          "&gws_rd=ssl#q=" +
          $("#search-query")[0].value +
          "+site:kig.re",
          "_blank",
          "width=1000,height=700,toolbar=1,resizable=1")
      return false;
  })
});

class Site {
  constructor(url) {
    this.url = url;
    this.regex = /(localhost|127\.0\.0\.1):4000/;
  }

  isLocal() {
    if (window.location.href.match(this.localhostRegex)) {
      return true;
    } else {
      return false;
    }
  }
};

var site = new Site(window.location.href);

/*
 * jQuery Table of Content Generator Support for Jekyll v1.0
 *
 * https://github.com/dafi/jekyll-tocmd-generator
 * Examples and documentation at: https://github.com/dafi/jekyll-tocmd-generator
 *
 * Requires: jQuery v1.7+
 *
 * Copyright (c) 2013 Davide Ficano
 *
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 */
(function($) {
    $.toc = {};
    $.toc.clickHideButton = function(settings) {
        var config = {
            saveShowStatus: false,
            hideText: 'hide',
            showText: 'show'};

        if (settings) {
            $.extend(config, settings);
        }

        $('#toctogglelink').click(function() {
            var ul = $($('#toc ul')[0]);

            if (ul.is(':visible')) {
                ul.hide();
                $(this).text(config.showText);
                if (config.saveShowStatus) {
                    $.cookie('toc-hide', '1', { expires: 365, path: '/' });
                }
                $('#toc').addClass('tochidden');
            } else {
                ul.show();
                $(this).text(config.hideText);
                if (config.saveShowStatus) {
                    $.removeCookie('toc-hide', { path: '/' });
                }
                $('#toc').removeClass('tochidden');
            }
            return false;
        });

        if (config.saveShowStatus && $.cookie('toc-hide')) {
            var ul = $($('#toc ul')[0]);

            ul.hide();
            $('#toctogglelink').text(config.showText);
            $('#toc').addClass('tochidden');
        }

    }
})(jQuery);
