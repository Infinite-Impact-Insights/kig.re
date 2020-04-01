
(function ($) {
  "use strict";

  hotkeys('ctrl+option+l,ctrl+command+l,ctrl+l,?', function (event, handler){
    event.preventDefault();
    $("#search-query").focus();
  });


  $(document).ready(function () {
    $("#search-icon").on("click", function (event) {
      $("#search-form").submit();
    });

    $("#search-form").on("submit", function (event) {
      window.open(
          "http://google.com/?site=kig.re&q=" +
          $("#search-query")[0].value +
          "&gws_rd=ssl#q=" +
          $("#search-query")[0].value +
          "+site:kig.re",
          "_blank",
          "width=700,height=1200,toolbar=1,resizable=1"
      );
      return false;
    });

    $(document).on('keypress', function (e) {
      if (e.keyCode === 63) { // question mark
        $("#search-query").focus();
      }
    });
  });


  /* Mobile-menu	 */
  $("#nav-button").on("click", function () {
    $("body").toggleClass("nav-open");
    let button = $("#nav-button");
    if (button.hasClass("fa-bars"))
      button.removeClass("fa-bars").addClass("fa-times-circle");
    else
      button.removeClass("fa-times-circle").addClass("fa-bars");
  });

  /* Post-carousel */
  $(".related-post-carousel").owlCarousel({
    dots: false,
    nav: false,
    margin: 30,
    autoplay: true,
    responsive: {
      0: {
        items: 1
      },
      600: {
        items: 2
      },
      1000: {
        items: 3
      }
    }
  });

  new WOW().init();

})(jQuery);
