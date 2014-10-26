module Renderable
  extend ActiveSupport::Concern

  private
  def render_anywhere(partial, locals = {})
    action_view = ActionView::Base.new(Rails.configuration.paths['app/views'])
    action_view.class_eval do
      include Rails.application.routes.url_helpers
      include JournalHelper

      def protect_against_forgery?
        false
      end
    end
    action_view.render partial: partial, locals: locals
  end
end
