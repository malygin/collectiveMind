class GroupChatMessage < ActiveRecord::Base
  #@todo remove
  attr_accessible :content, :group_id
  belongs_to :user
  belongs_to :group

  COUNT_LAST_MESSAGES = 15
  GROUP_FOLDER = 'group_files'
  scope :recent, -> { last(COUNT_LAST_MESSAGES).reverse }

  def time
    Russian::strftime(created_at, '%k:%M')
  end


  def self.history(last_id)
    where(id: ((last_id - COUNT_LAST_MESSAGES)..(last_id - 1)).to_a).reverse.collect { |message| message.to_json }
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
