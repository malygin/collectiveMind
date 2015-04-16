class Technique::List < ActiveRecord::Base
  scope :by_stage, -> (stage) { stage = :aspect_posts if stage == :collect_info_posts; where stage: stage }
  validates :code, :stage, presence: true

  def name
    "#{stage}_#{code}"
  end

  def self.all_in_array
    result = {}
    all.each do |tech|
      result[tech.stage] ||= []
      result[tech.stage] << tech
    end
    result
  end
end
