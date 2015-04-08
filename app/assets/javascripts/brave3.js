//$( function() {
//    // init Isotope
//    var $container = $('#tab_aspect_posts').isotope({
//        itemSelector: '.discontent-block',
//        layoutMode: 'fitRows',
//        getSortData: {
//            //rate: '[data-rate] parseFloat',
//            //date: '[data-date] parseFloat',
//            rate: function( itemElem ) { // function
//                return parseFloat( $(itemElem).data('rate') );
//            },
//            date: function( itemElem ) { // function
//                return parseFloat( $(itemElem).data('date') );
//            }
//        }
//    });
//
//    // filter functions
//    //var filterFns = {
//    //    // show if number is greater than 50
//    //    numberGreaterThan50: function() {
//    //        var number = $(this).find('.number').text();
//    //        return parseInt( number, 10 ) > 50;
//    //    },
//    //    // show if name ends with -ium
//    //    ium: function() {
//    //        var name = $(this).find('.name').text();
//    //        return name.match( /ium$/ );
//    //    }
//    //};
//
//    // bind filter button click
//    $('#filter').on( 'click', 'li', function() {
//        var filterValue = $(this).attr('data-aspect');
//        // use filterFn if matches value
//        //filterValue = filterFns[ filterValue ] || filterValue;
//        $container.isotope({ filter: filterValue });
//    });
//
//    $('#filter_all').on( 'click', function() {
//        var filterValue = $(this).attr('data-aspect');
//        // use filterFn if matches value
//        //filterValue = filterFns[ filterValue ] || filterValue;
//        $('.select-aspect').html('Выберите аспект <span class="caret"></span>');
//        $container.isotope({ filter: filterValue });
//    });
//
//    // bind sort button click
//    $('#sorter').on( 'click', 'span', function() {
//        var sortByValue = $(this).attr('data-type');
//        var sortByDesc = $(this).attr('data-desc');
//
//        var desc, num;
//
//        if (sortByDesc === "1") {
//            desc = true;
//            num = "-1";
//        } else {
//            desc = false;
//            num = "1";
//        }
//
//        $(this).attr("data-desc", num);
//
//
//        $container.isotope({
//            sortBy: sortByValue,
//            sortAscending: desc
//        });
//    });
//
//    // change is-checked class on buttons
//    //$('.button-group').each( function( i, buttonGroup ) {
//    //    var $buttonGroup = $( buttonGroup );
//    //    $buttonGroup.on( 'click', 'button', function() {
//    //        $buttonGroup.find('.is-checked').removeClass('is-checked');
//    //        $( this ).addClass('is-checked');
//    //    });
//    //});
//
//});