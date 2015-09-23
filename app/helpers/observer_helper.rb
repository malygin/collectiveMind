module ObserverHelper
  include JournalHelper
  include ActionView::Helpers::TranslationHelper
  include ActionView::Helpers::UrlHelper

  def prepare_journal_data(journal)
    j_class = "#{journal_icon(journal.type_event)} #{journal_color(journal.type_event)}"
    j_date = Russian.strftime(journal.created_at, '%k:%M %d.%m.%Y')
    j_parser = journal_parser(journal, journal.project_id).try(:html_safe)
    { j_class: j_class, j_date: j_date, j_parser: j_parser, user_id: journal.user.id, user_name: journal.user.to_s }.stringify_keys
  end
end
