class Technique::List < ActiveRecord::Base
  scope :by_stage, -> (stage) { stage = :aspects if stage == :collect_info_posts; where stage: stage }
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
