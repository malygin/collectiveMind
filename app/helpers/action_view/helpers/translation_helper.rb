##
# Переопределяем хелпер `t` для перевода с кастомным параметром (тип процедуры)
module ActionView::Helpers::TranslationHelper
  def t(key, options = {})
    if !@project.nil? and !@project.project_type_id.nil?
      value = I18n.t("#{key}_#{@project.project_type.code}", options)
      return value unless value.to_s.match(/title="translation missing: (.+)"/)
    end
    I18n.t(key, options)
  end
end
