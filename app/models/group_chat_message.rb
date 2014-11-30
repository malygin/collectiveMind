class GroupChatMessage < ActiveRecord::Base
  #@todo remove
  attr_accessible :content, :group_id
  belongs_to :user
  belongs_to :group

  COUNT_LAST_MESSAGES = 15
  scope :recent, -> { last(COUNT_LAST_MESSAGES) }

  def time
    Russian::strftime(created_at, '%k:%M')
  end

  def self.history(to)
    start_message_id = to - COUNT_LAST_MESSAGES
    if start_message_id >= 0
      where(id: start_message_id..to).collect { |message| message.to_json }
    else
      []
    end
  end

  def to_json
    {user: "#{user.name} #{user.surname}",
     avatar: user.avatar(:thumb),
     text: content,
     id: id,
     time: time,
     created_at: created_at}
  end
end
