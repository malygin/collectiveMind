class Core::ProjectUsersController < ApplicationController
  before_action :set_project

  def analytics
    # Запрос возвращает хеш, где ключ - дата, значение - количество юзеров
    # например, {2015-01-25 00:00:00 +0300=>1, 2015-01-26 00:00:00 +0300=>1}
    # и затем мы преобразуем дату для работы на клиенте (хз, почему именно так)
    visits = @project.journals.unscoped.select('DISTINCT user_id').where(type_event: 'visit_save').
        where('created_at > ?', 5.days.ago).group("DATE_TRUNC('day', created_at)").count
    visits = visits.map { |k, v| {x: (k.to_datetime.to_f * 1000).to_i, y: v} }

    render json: [{key: 'Посетителей', values: visits}]
  end

  def average_time
    visits = @project.journals.unscoped.select("DATE_TRUNC('day', created_at), sum(updated_at - created_at)").
        where(type_event: 'visit_save').where('created_at > ?', 5.days.ago).group("DATE_TRUNC('day', created_at)")
    visits = visits.map { |k, v| {x: (k.to_datetime.to_f * 1000).to_i, y: v} }

    render json: [{key: 'Посетителей', values: visits}]
  end

  def lazy_users
    render json: [{key: 'Посетителей', values: []}]
  end

  private
  def set_project
    @project = Core::Project.find(params[:project]) if params[:project]
  end
end
