class Role < ActiveRecord::Base
  validates :name, :code, presence: true
  before_validation :set_code

  private
  def set_code
    if code.nil?
      c = Role.last.try(:code)
      self.code = (1 + c) unless c.nil?
    end
  end
end
