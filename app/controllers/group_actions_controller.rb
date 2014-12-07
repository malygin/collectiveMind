class GroupActionsController < WebsocketRails::BaseController
  def initialize_session
    controller_store[:editing] = {}
  end

  def client_connected
    p 'CONNECTED!'
  end

  def start_edit
    if controller_store[:editing][message[:model_name]].present? &&
        controller_store[:editing][message[:model_name]]['id'] == message[:id] &&
        controller_store[:editing][message[:model_name]]['user_id'] != current_user.id
      WebsocketRails.users[current_user.id].send_message(:already_editing, {}, channel: 'group.actions')
    else
      controller_store[:editing] = {message[:model_name] => {model_id: message[:id].to_i, user_id: current_user.id}}
    end
  end

  def client_disconnected
    # controller_store[:editing].each do |current_edit|
    #   if ['user_id'] == current_user.id
    #     controller_store[:editing].delete current_edit
    #   end
    # end
    p 'user disconnected'
  end
end
