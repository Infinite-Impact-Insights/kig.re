(function ($) {
    "use strict";

    /* Mobile-menu	 */
    $(".nav-button").on("click", function () {
        $("body").toggleClass("nav-open");
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

    $(document).on("load", woodhamLines());

    $('.banner').on("show", helloWorld());

    new WOW().init();

})(jQuery);