class GroupActionsController < WebsocketRails::BaseController
  def start_edit
    no_edits = true
    if editable[message[:model_name]].present?
      JSON.parse(editable[message[:model_name]]).each do |current_model|
        if current_model['model_id'] == message[:model_id]
          unless current_model['user_id'] == current_user.id
            WebsocketRails.users[current_user.id].send_message(:already_editing, {model_name: message[:model_name], model_id: message[:model_id]}, channel: 'group.actions')
            no_edits = false
            break
          end
        end
      end
    end

    if no_edits
      if editable[message[:model_name]].present?
        editing_array = JSON.parse(editable[message[:model_name]])
      else
        editing_array = Array.new
      end
      editing_array << {model_id: message[:model_id], user_id: current_user.id}
      redis.hset redis_key, message[:model_name], editing_array.to_json
    end
  end

  def client_disconnected
    editable.each do |current_edit|
      save_again = false
      editing_models = JSON.parse(current_edit[1])
      editing_models.each do |current_model|
        if current_model['user_id'] == current_user.id
          editing_models.delete current_model
          save_again = true
        end
      end
      redis.hset(redis_key, current_edit[0], editing_models.to_json) if save_again
    end
  end

  private
  def redis
    @redis ||= Redis.new(WebsocketRails.config.redis_options)
  end

  def redis_key
    'websocket_rails.editable'
  end

  def editable
    redis.hgetall redis_key
  end
end
