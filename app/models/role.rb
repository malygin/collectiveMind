class Role < ActiveRecord::Base
  has_many :user_roles
  has_many :user, through: :user_roles

  validates :name, :code, presence: true
  before_validation :set_code

  private

  def set_code
    return unless code.nil?
    c = Role.last.try(:code)
    self.code = (1 + c) unless c.nil?
  end
end
