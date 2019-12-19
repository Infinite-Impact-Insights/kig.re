sub vcl_recv {
    if (req.http.host == "kiguino.moos.io") {
        set req.http.x-redir = "http://kig.re" + req.url;
        error 750 "redirect";
    }
    #FASTLY recv
}

sub vcl_error {
    if (obj.status == 750) {
        set obj.http.Location = req.http.x-redir;
        set obj.status = 301;
        return(deliver);
    }
    #FASTLY error
}
