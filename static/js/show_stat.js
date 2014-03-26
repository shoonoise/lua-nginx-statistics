/**
 * Created by Alexander Kushnarev on 26.03.14.
 */

$( document ).ready(function() {
    $.getJSON( "/stat", function( data ) {
        var statistic = function () {
            var main = "<h1>Nginx statistic page</h1>";
            $.each(data, function (stat_type, stat_data) {
                main += "<h2>" + stat_type + "</h2>";
                $.each(stat_data, function (loc, values) {
                    var counters_list = '<h3> In '+ loc +':</h3>';
                    counters_list += "<ul>";
                    $.each(values, function (s, count) {
                        counters_list += "<li>" + "<b>" + s + "</b>" +" status was occurred " + count + " times " + "</li>";
                    });
                    counters_list += "</ul>";
                    main += counters_list;
                })
            });
            return main;
        };
        $("body").append(statistic);
    });
});
