class GroupActionsController < WebsocketRails::BaseController
  def initialize_session
    p '========================initialize'
    p controller_store[:editing]
    controller_store[:editing] = {} if controller_store[:editing].nil?
  end

  def client_connected
    p '========================CONNECTED!'
  end

  def start_edit
    p controller_store[:editing]
    flag = false
    if controller_store[:editing][message[:model_name]].present?
      controller_store[:editing][message[:model_name]].each do |current_model|
        if current_model[:model_id] == message[:model_id] && current_model[:user_id] != current_user.id
          WebsocketRails.users[current_user.id].send_message(:already_editing, {model_name: message[:model_name], model_id: message[:model_id]}, channel: 'group.actions')
          break
        else
          flag = true
        end
      end
    else
      flag = true
    end

    if flag
      controller_store[:editing][message[:model_name]] = Array.new
      controller_store[:editing][message[:model_name]] << {model_id: message[:model_id], user_id: current_user.id}
    end
    WebsocketRails::Synchronization.redis.hset 'websocket_rails.editable', message[:model_name], controller_store[:editing][message[:model_name]].to_json

    p '========================start edit finish'
    p controller_store.collect_all :editing
    p controller_store[:editing]
  end

  def client_disconnected
    p controller_store[:editing]
    controller_store[:editing].each do |current_edit|
      current_edit[1].each do |current_models|
        if current_models[:user_id] == current_user.id
          current_edit[1].delete current_models
        end
      end

    end
    p '========================user disconnected'
    p controller_store[:editing]
  end
end
