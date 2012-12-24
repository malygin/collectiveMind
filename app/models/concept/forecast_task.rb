class Concept::ForecastTask < ActiveRecord::Base
  attr_accessible :content, :description
  belongs_to :user
  has_many :voitings, :class_name => "Concept::FinalVoiting"


  def voiting_score
    score = 0
    self.voitings.each do |v|
      score += v.score
    end
    return score
  end

end
