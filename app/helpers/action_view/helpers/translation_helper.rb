##
# Переопределяем хелпер `t` для перевода с кастомным параметром (тип процедуры)
module ActionView::Helpers::TranslationHelper
  def t(key, options = {})
    if !@project.nil? && !@project.project_type_id.nil?
      value = I18n.t("#{key}_#{@project.project_type.code}", options)
      return value unless value.match 'translation missing: (.+)'
    end
    I18n.t(key, options)
  end
end
