class Core::ProjectUsersController < ApplicationController
  before_filter :prime_admin_authenticate
  before_action :set_project
  before_action :journal_data, only: [:user_analytics, :moderator_analytics]
  layout 'application'

  def user_analytics

  end

  def moderator_analytics
  end

  def count_people
    # Запрос возвращает хеш, где ключ - дата, значение - количество юзеров
    # например, {2015-01-25 00:00:00 +0300=>1, 2015-01-26 00:00:00 +0300=>1}
    # и затем мы преобразуем дату для работы на клиенте (хз, почему именно так)
    visits = @project.statistic_visits.not_moderators.select('DISTINCT user_id').group("DATE_TRUNC('day', journals.created_at)").count
    visits = visits.map { |k, v| {x: (k.to_datetime.to_f * 1000).to_i, y: v} }

    render json: [{key: 'Посетителей', values: visits}]
  end

  def average_time
    visits = @project.statistic_visits.not_moderators.select("DATE_TRUNC('day', journals.created_at) as day,
                  round(CAST(float8 (extract(epoch from sum(journals.updated_at - journals.created_at)::INTERVAL)/60) as numeric), 2) / count(DISTINCT journals.user_id) as minutes").
        group("DATE_TRUNC('day', journals.created_at)")
    visit_data = []
    visits.each do |visit|
      visit_data << {x: (visit.day.to_datetime.to_f * 1000).to_i, y: visit.minutes}
    end

    render json: [{key: 'Среднее время', values: visit_data}]
  end

  private
  def set_project
    @project = Core::Project.find(params[:project]) if params[:project]
  end
end
