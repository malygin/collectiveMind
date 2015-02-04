class RecordVisitController < WebsocketRails::BaseController
  def stop_visit
    j = current_user.journals.unscoped.order(created_at: :desc).offset(1).find_by(type_event: 'visit_save').update_attribute(:body2, DateTime.now)
    p "========#{j.id}, #{j.created_at}"
  end
end
