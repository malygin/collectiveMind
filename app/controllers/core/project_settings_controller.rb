class Core::ProjectSettingsController < ApplicationController
  def update
    @settings = Core::ProjectSetting.find params[:id]
    @settings.stage_dates[params[:stage_dates].keys.first]['expected'] = params[:stage_dates].values.first['expected']
    @settings.stage_dates_will_change!
    @settings.save
  end
end
