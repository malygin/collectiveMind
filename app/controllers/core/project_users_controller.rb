class Core::ProjectUsersController < ApplicationController
  before_action :set_project

  def analytics
    # Запрос возвращает хеш, где ключ - дата, значение - количество юзеров
    # например, {2015-01-25 00:00:00 +0300=>1, 2015-01-26 00:00:00 +0300=>1}
    # и затем мы преобразуем дату для работы на клиенте (хз, почему именно так)
    visits = @project.statistic_visits.select('DISTINCT user_id').group("DATE_TRUNC('day', created_at)").count
    visits = visits.map { |k, v| {x: (k.to_datetime.to_f * 1000).to_i, y: v} }

    render json: [{key: 'Посетителей', values: visits}]
  end

  def average_time
    visits = @project.statistic_visits.select("DATE_TRUNC('day', created_at) as day, sum(updated_at - created_at) as sum").group("DATE_TRUNC('day', created_at)")
    visit_data = []
    visits.each do |visit|
      visit_data << {x: (visit.day.to_datetime.to_f * 1000).to_i, y: (visit.sum.to_datetime.to_f * 1000).to_i}
    end

    render json: [{key: 'Посетителей', values: visit_data}]
  end

  def lazy_users
    @project.journals.unscoped.where(type_event: 'visit_save').where('created_at > ?', 2.days.ago)
    @project.users
    render json: [{key: 'Посетителей', values: []}]
  end

  private
  def set_project
    @project = Core::Project.find(params[:project]) if params[:project]
  end
end
