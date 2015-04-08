class Discontent::PostGroup
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_reader :user
  attr_reader :discontent

  attribute :content, String

  validates :content, presence: true


  def persisted?
    false
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  private

  def persist!
    @group = Discontent::Post.create!(content: content)
  end
end
