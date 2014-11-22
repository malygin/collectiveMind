class GroupChatMessage < ActiveRecord::Base
  #@todo remove
  attr_accessible :content, :group_id
  belongs_to :user
  belongs_to :group

  scope :recent, -> { last(15) }

  def time
    Russian::strftime(created_at, '%k:%M')
  end

  def self.history(to)
    where(id: (to - 15)..to).reverse.collect { |message| message.to_json }
  end

  def to_json
    {user: "#{user.name} #{user.surname}",
     avatar: user.avatar(:thumb),
     text: content,
     id: id,
     time: time}
  end
end
