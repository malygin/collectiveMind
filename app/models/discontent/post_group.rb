class Discontent::PostGroup
  include Virtus.model

  # include ActiveModel::Model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_reader :user
  attr_reader :discontent_post

  attribute :content, String
  attribute :whend, String
  attribute :whered, String
  attribute :status, Integer
  attribute :style, Integer
  attribute :project_id, Integer

  # @todo правильно задать связи
  # has_many :discontent_posts, class_name: 'Discontent::Post', foreign_key: 'discontent_post_id'
  # has_many :discontent_post_group_aspects, class_name: 'Discontent::PostAspect', foreign_key: 'post_id'
  # has_many :post_group_aspects, through: :discontent_post_group_aspects, source: :core_aspect, class_name: 'Core::Aspect::Post'
  #
  # #связь с идеями
  # has_many :concept_post_discontents, -> { where concept_post_discontents: {status: [0, nil]} },
  #          class_name: 'Concept::PostDiscontent', foreign_key: 'discontent_post_id'
  # has_many :dispost_concepts, through: :concept_post_discontents, source: :post, class_name: 'Concept::Post'
  #
  # #голосование
  # has_many :concept_votings, foreign_key: 'discontent_post_id', class_name: 'Concept::Voting'
  # has_many :final_votings, foreign_key: 'discontent_post_id', class_name: 'Discontent::Voting'
  # has_many :voted_users, through: :final_votings, source: :user

  validates :content, presence: true

  def persisted?
    false
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  # проверка на последний элемент в группе
  def one_last_post?
    discontent_posts.size < 2
  end

  # обновление списка аспектов для группы
  def update_union_post_aspects(aspects_new)
    aspects_old = post_group_aspects.nil? ? [] : post_group_aspects.pluck(:id)
    return if aspects_new.nil?
    aspects_new.uniq.each do |asp|
      unless aspects_old.include? asp.id
        discontent_post_group_aspects.create(aspect_id: asp.id).save!
      end
    end
  end

  # обновление аспектов группы при удалении несовершенства из группы
  def destroy_ungroup_aspects(ungroup_post)
    aspects_for_ungroup = ungroup_post.post_aspects.pluck(:id)
    union_posts = discontent_posts.where('discontent_posts.id <> ?', ungroup_post.id)
    union_posts_aspects = []
    if union_posts.present?
      union_posts.each do |p|
        union_posts_aspects |= p.post_aspects.pluck(:id) if p.post_aspects.present?
      end
    end
    return unless aspects_for_ungroup.present? && union_posts_aspects.present?
    aspects_for_ungroup.each do |asp|
      unless union_posts_aspects.include? asp
        discontent_post_group_aspects.by_aspect(asp).destroy_all
      end
    end
  end

  private

  def persist!
    @group = Discontent::Post.create!(content: content, whend: whend, whered: whered, status: status, style: style, project_id: project_id)
  end
end
