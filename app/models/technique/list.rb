class Technique::List < ActiveRecord::Base
  scope :by_stage, -> (stage) { where stage: stage }
  validates :name, :code, :stage, presence: true

  def self.all_in_array
    result = {}
    all.each do |tech|
      result[tech.stage] ||= []
      result[tech.stage] << tech
    end
    result
  end
end
