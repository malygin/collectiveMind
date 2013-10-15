
$(document).ready(
    function(){
    $( "#tabs" ).tabs();
    $( "#tabs2" ).tabs();

    $('#select_discontent_').selectize({

        valueField: 'value',
        labelField: 'text',
        searchField: ['text', 'email'],
        onChange: function(item) {
            if ($('#dis_'+item).length<1){
              $('.discontents').append('<div id="dis_'+item+'"><br/>'+$('div.selected span').html()+'<input id="replace_'+item+'" name="replace['+item+']" type="hidden" value="'+item+'"><a onclick="remove_dis('+item+')">Удалить</a> </div>')
            }
        },
        render: {
            item: function(item, escape) {
                return '<div>' +
                    (item.text ? '<span class="name">' + item.text + '</span>' : '') +
                    (item.email ? '<span class="email">' + escape(item.email) + '</span>' : '') +
                    '</div>';
            },
            option: function(item, escape) {
                var label = item.text || item.email;
                var caption = item.text ? item.email : null;
                return '<div>' +
                    '<span class="label">' +label + '</span>' +

                    '</div>';
            }
        },
        create: function(input) {
            if ((new RegExp('^' + REGEX_EMAIL + '$', 'i')).test(input)) {
                return {email: input};
            }
            var match = input.match(new RegExp('^([^<]*)\<' + REGEX_EMAIL + '\>$', 'i'));
            if (match) {
                return {
                    email : match[2],
                    name  : $.trim(match[1])
                };
            }
            alert('Invalid email address.');
            return false;
        }
    });
    });
function remove_dis(id){
    $("#dis_"+id).remove();

}