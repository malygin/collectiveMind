class Technique::List < ActiveRecord::Base
  has_many :technique_list_projects, class_name: 'Technique::ListProject', dependent: :destroy

  validates :code, :stage, presence: true

  scope :by_stage, -> (stage) { stage = :aspect_posts if stage == :collect_info_posts; where stage: stage }

  def name
    "#{stage}_#{code}"
  end

  # Формируем массив из всех техник, для отображения в форме редактирования проекта
  def self.all_in_array
    result = {}
    all.each do |tech|
      result[tech.stage] ||= []
      result[tech.stage] << tech
    end
    result
  end
end
