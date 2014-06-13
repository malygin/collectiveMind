$(function(){
    function pageLoad(){
        $('.chzn-select').select2();
        $("#destination").mask("99999");
        $("#credit").mask("9999-9999-9999-9999");
        $("#expiration-date").datepicker();
        $("#wizard").bootstrapWizard({onTabShow: function(tab, navigation, index) {
            var $total = navigation.find('li').length;
            var $current = index+1;
            var $percent = ($current/$total) * 100;
            var $wizard = $("#wizard");
            $wizard.find('.progress-bar').css({width:$percent+'%'});

            if($current >= $total) {
                $wizard.find('.pager .next').hide();
                $wizard.find('.pager .finish').show();
                $wizard.find('.pager .finish').removeClass('disabled');
            } else {
                $wizard.find('.pager .next').show();
                $wizard.find('.pager .finish').hide();
            }
            if($current == 1) {
                $('#send_post_concept').submit();
                save_last_concept_tabs();
            }
            if($current == 2) {
                render_table();
                $('#send_post_concept').submit();
                save_last_concept_tabs();
            }
            if($current == 3) {
                render_concept_side();
            }
        }});
    }

    pageLoad();

    PjaxApp.onPageLoad(pageLoad);
});