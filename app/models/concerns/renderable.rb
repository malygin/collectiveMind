module Renderable
  extend ActiveSupport::Concern
  #include Rails.application.routes.url_helpers
  delegate :url_helpers, to: 'Rails.application.routes'

  private
  def render_anywhere(partial, locals = {}, assigns = {})
    ApplicationController.new.render_to_string(
        partial: partial,
        locals: locals
    )
    # view = ActionView::Base.new ActionController::Base.view_paths, assigns
    # view.extend JournalHelper
    # view.render partial: partial, locals: locals
  end
end
