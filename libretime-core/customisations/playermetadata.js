                            $.ajax({url: "http://studio2.nmt.edu:8000/nowplaying.xsl", 
                                data: {"@mount": "/live"},
                                success: function(data) {
                                    if (data) {
                                        $("p.now_playing").html($.i18n._("Auto DJ") + "<span>"+ data + "</span>");
                                        console.log(data); 
                                    } else {
                                        $("p.now_playing").html($.i18n._("Off Air") + "<span>"+ $.i18n._("Offline") + "</span>");
                                        console.log("Empty Metadata fetch")
                                    }
                                },
                                failure: function() {
                                    $("p.now_playing").html($.i18n._("Off Air") + "<span>"+ $.i18n._("Offline") + "</span>");
                                    console.log("Failed Metadata fetch")
                                }
                            })