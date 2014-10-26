module Renderable
  extend ActiveSupport::Concern
  delegate :url_helpers, to: 'Rails.application.routes'

  private
  def render_anywhere(partial, locals = {})
    ApplicationController.new.render_to_string(
        partial: partial,
        locals: locals
    )
  end
end
