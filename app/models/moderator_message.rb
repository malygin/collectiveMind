class ModeratorMessage < ActiveRecord::Base
  belongs_to :user

  scope :recent, -> { last(15) }

  def self.history(to)
    where(id: (to - 15)..to).reverse.collect { |message| message.to_json }
  end

  def to_json
    {user: "#{user.name} #{user.surname}",
     avatar: user.avatar(:thumb),
     text: message,
     id: id,
     time: created_at}
  end
end
