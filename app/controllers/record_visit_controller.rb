class RecordVisitController < WebsocketRails::BaseController
  def start_visit
    current_user.journals.create type_event: 'visit_save', project_id: message['location']['0']['pathname'].split('/')[2].to_i,
                                 body: message['location']['0']['href']
  end

  def stop_visit
    current_user.journals.unscoped.order(created_at: :desc).find_by(type_event: 'visit_save').update_attribute(:body2, DateTime.now)
  end
end