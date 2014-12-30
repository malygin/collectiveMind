class Core::ProjectSetting < ActiveRecord::Base
  belongs_to :project
  before_create :set_stage_dates

  private
  def set_stage_dates
    stage_dates = {}
    Core::Project::LIST_STAGES.each do |stage, data|
      data[:status].each do |status|
        stage_dates[status] = {
            expected: {
                start: Date.today,
                end: Date.today + 7.day
            },
            real: {
                start: '',
                end: ''
            },
        }
      end
    end

    stage_dates[:current] = 1
    self.stage_dates = stage_dates
  end
end
