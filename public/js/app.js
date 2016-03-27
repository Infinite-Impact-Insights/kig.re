$( document ).ready(function() {

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
