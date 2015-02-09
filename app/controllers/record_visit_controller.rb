class RecordVisitController < WebsocketRails::BaseController
  def stop_visit
    j = current_user.journals.unscoped.order(created_at: :desc).offset(1).find_by(type_event: 'visit_save')
    j.update_attribute(:body2, DateTime.now)
  end
end
