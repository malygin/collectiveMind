@resources = ->
  project = $("#option_for_project").attr('data-project')

  this.desc_show = ->
    $(this).closest('.main_res').find('.desc_resource:first').show()
  this.res_delete = ->
    $(this).closest('.main_res').remove()

  this.add_new_resource_to_concept = ->
    section = $(this).closest('.section-resources').data('section')
    field = section + '_r'
    field2 = section + '_s'
    position = parseInt($('#resources_' + field + ' .main_resources').last().data('position'))
    if not position then position = 1 else position += 1
    resource = $('#resources_' + field)
    resource.append('<div class="main_resources main_res" id="main_' + field + '_' + position + '" data-position="' + position + '">
                            <div class="col-md-8">
                              <span role="status" aria-live="polite" class="ui-helper-hidden-accessible"></span>
                              <input class="form-control autocomplete ui-autocomplete-input" data-autocomplete="/project/' + project + '/autocomplete_concept_post_resource_concept_posts" id="concept_post_resource" min-length="0" name="resor[][name]" placeholder="Введите свой ресурс или выберите из списка" type="text" autocomplete="off">
                              <input name="resor[][type_res]" type="hidden" value="' + field + '">
                            </div>
                            <div class="col-md-4">
                              <div class="pull-right">
                                <button class="btn btn-info desc_to_res" title="Добавить описание" type="button">
                                  <i class="fa fa-edit"></i>
                                </button>
                                <button class="btn btn-success plus_mean" title="Добавить средство" type="button">
                                  <i class="fa fa-plus"></i>
                                </button>
                                <button class="btn btn-danger destroy_res" title="Удалить ресурс" type="button">
                                  <i class="fa fa-trash-o"></i>
                                </button>
                              </div>
                            </div>
                            <br><br>
                            <div class="desc_resource" id="desc_' + field + '_' + position + '" data-position="' + position + '" style="display:none;">
                              <textarea class="form-control" id="res" name="resor[][desc]" placeholder="Пояснение к ресурсу" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 50px;"></textarea>
                            </div>
                            <div class="col-md-offset-1 col-md-11 means_to_resource" id="means_' + field2 + '_' + position + '"></div>
                        </div>')
    autocomplete_initialized()
    $('textarea').autosize()

  this.add_new_mean_to_resource = ->
    position = $(this).closest('.main_resources').data('position')
    section = $(this).closest('.section-resources').data('section')
    field = section + '_s'
    mean = $('#means_' + field + '_' + position)
    mean.append('<br/><div class="main_means main_res" id="main_' + field + '_' + position + '" data-position="' + position + '">
                            <div class="col-md-8">
                                <span role="status" aria-live="polite" class="ui-helper-hidden-accessible"></span>
                                <input class="form-control autocomplete ui-autocomplete-input" data-autocomplete="/project/' + project + '/autocomplete_concept_post_mean_concept_posts" id="res" min-length="0" name="resor[][means][][name]" placeholder="Введите свой ресурс или выберите из списка" type="text" autocomplete="off">
                                <input name="resor[][means][][type_res]" type="hidden" value="' + field + '">
                            </div>
                            <div class="col-md-4">
                                <div class="pull-right">
                                    <button class="btn btn-info desc_to_res" title="Добавить описание" type="button">
                                      <i class="fa fa-edit"></i>
                                    </button>
                                    <button class="btn btn-danger destroy_res" title="Удалить ресурс" type="button">
                                      <i class="fa fa-trash-o"></i>
                                    </button>
                                </div>
                            </div>
                            <br/><br/>
                            <div class="desc_resource" id="desc_' + field + '_' + position + '" data-position="' + position + '" style="display:none;">
                              <textarea class="form-control" id="res" name="resor[][means][][desc]" placeholder="Пояснение к ресурсу" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 50px;"></textarea>
                              <br>
                            </div>
                          </div>')
    autocomplete_initialized()
    $('textarea').autosize()

  $('#form_for_concept').on('click', 'button.plus_mean', this.add_new_mean_to_resource)
  $('#form_for_concept').on('click', 'a.plus_resource', this.add_new_resource_to_concept)

  $('#form_for_concept').on('click', 'button.desc_to_res', this.desc_show)
  $('#form_for_concept').on('click', 'button.destroy_res', this.res_delete)