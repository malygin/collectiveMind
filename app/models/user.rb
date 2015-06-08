class User < ActiveRecord::Base
  include ApplicationHelper
  include MarkupHelper
  include PgSearch

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lastseenable

  has_many :journals
  has_many :loggers, class_name: 'JournalLogger'

  has_many :discontent_posts, class_name: 'Discontent::Post'
  has_many :core_aspects, class_name: 'Core::Aspect::Post'
  has_many :concept_posts, class_name: 'Concept::Post'
  has_many :novation_posts, class_name: 'Novation::Post'
  has_many :plan_posts, class_name: 'Plan::Post'

  has_many :core_aspect_comments, class_name: 'Core::Aspect::Comment'
  has_many :discontent_comments, class_name: 'Discontent::Comment'
  has_many :concept_comments, class_name: 'Concept::Comment'
  has_many :novation_comments, class_name: 'Novation::Comment'
  has_many :plan_comments, class_name: 'Plan::Comment'

  has_many :voting_core_aspect_posts, class_name: 'Core::Aspect::PostVoting'
  has_many :voting_discontent_posts, class_name: 'Discontent::PostVoting'
  has_many :voting_concept_posts, class_name: 'Concept::PostVoting'
  has_many :voting_novation_posts, class_name: 'Novation::PostVoting'
  has_many :voting_plan_posts, class_name: 'Plan::PostVoting'

  has_many :voting_core_aspect_comments, class_name: 'Core::Aspect::CommentVoting'
  has_many :voting_discontent_comments, class_name: 'Discontent::CommentVoting'
  has_many :voting_concept_comments, class_name: 'Concept::CommentVoting'
  has_many :voting_novation_comments, class_name: 'Novation::CommentVoting'
  has_many :voting_plan_comments, class_name: 'Plan::CommentVoting'

  has_many :aspect_votings, class_name: 'CollectInfo::Voting'
  has_many :voted_aspects, through: :aspect_votings, source: :aspect, class_name: 'Core::Aspect::Post'

  has_many :post_votings, class_name: 'Discontent::Voting'
  has_many :voted_discontent_posts, through: :post_votings, source: :discontent_post, class_name: 'Discontent::Post'

  has_many :concept_post_votings, class_name: 'Concept::Voting'
  has_many :voted_concept_post, through: :concept_post_votings, source: :concept_post, class_name: 'Concept::Post'

  has_many :novation_post_votings, class_name: 'Novation::Voting'
  has_many :voted_novation_post, through: :novation_post_votings, source: :novation_post, class_name: 'Novation::Post'

  has_many :plan_post_votings, class_name: 'Plan::Voting'
  has_many :voted_plan_posts, through: :plan_post_votings, source: :plan_post, class_name: 'Plan::Post'

  has_many :core_project_users, class_name: 'Core::ProjectUser'
  has_many :projects, through: :core_project_users, source: :core_project, class_name: 'Core::Project'

  has_many :user_checks, class_name: 'UserCheck'
  has_many :user_answers, class_name: 'CollectInfo::UserAnswers'
  has_many :news, class_name: 'News'
  has_many :core_content_user_answers, class_name: 'Core::ContentUserAnswer'
  # scope :check_field, ->(p, c) { joins(:user_checks).where(user_checks: {project: p.id, status: 't', check_field: c}) }

  validates :name, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  def last_event(project)
    Journal.last_event_for(self, project)
  end

  def to_s
    "#{name} #{surname}"
  end

  def role_name
    'модератор' if type_user == 1
  end

  def boss?
    type_user == 1
  end

  def add_score(h = {})
    case h[:type]
      when :plus_comment
        add_score_by_type(h[:project], 5, h[:type_score])
        # journals.build(type_event: 'my_add_score_' + h[:model_score], project: h[:project], user_informed: self, body: h[:score], first_id: h[:post].id, body2: trim_content(field_for_journal(h[:post])), viewed: false, personal: true).save!
      when :to_archive_plus_comment
        add_score_by_type(h[:project], -5, h[:type_score])
      when :plus_post
        add_score_by_type(h[:project], h[:score], h[:type_score])
        journals.build(type_event: 'my_add_score_' + h[:model_score], project: h[:project], user_informed: self, body: h[:score], first_id: h[:post].id, body2: trim_content(field_for_journal(h[:post])), viewed: false, personal: true).save!

      when :to_archive_plus_post
        add_score_by_type(h[:project], -h[:score], h[:type_score])
        Journal.destroy_journal_record(h[:project], 'my_add_score_' + h[:model_score], self, h[:post], true)

    end
  end

  def add_score_by_type(project, score, type = :collect_info_posts_score)
    ps = core_project_users.by_project(project).first_or_create
    ps.update_attributes!(score: score + (ps.score || 0), type => (ps.read_attribute(type) || 0) + score)
  end

  def my_journals(project)
    events = Journal.events_for_my_feed project.id, id
    g = events.group_by { |e| [e.first_id, e.type_event] }
    g.collect { |_k, v| [v.first, v.size] }
  end

  def my_journals_viewed(project)
    events = Journal.events_for_my_feed_viewed project.id, id
    g = events.group_by { |e| [e.first_id, e.type_event] }
    g.collect { |_k, v| [v.first, v.size] }
  end

  def project_user_for(project)
    core_project_users.find_by(project_id: project.id)
  end

  def can_vote_for(stage, project)
    if stage == :collect_info && project.stage == '1:2' && project.get_free_votes_for(self, stage) > 0
      return true
    elsif stage == :discontent && project.stage == '2:1' && project.get_free_votes_for(self, stage) > 0
      return true
    elsif stage == :concept && project.stage == '3:1' && project.get_free_votes_for(self, stage) > 0
      return true
    elsif stage == :novation && project.stage == '4:1' && project.get_free_votes_for(self, stage) > 0
      return true
    end
    false
  end

  def content_for_project(stage, project)
    if stage == :collect_info_posts
      core_aspects.by_project(project)
    else
      send(stage).by_project(project.id)
    end
  end

  def comment_for_project(stage, project)
    if stage == :collect_info_posts
      core_aspect_comments.joins(:post).where("core_aspect_posts.project_id = ?", project)
    else
      send(stage.to_s.gsub('_posts', '_comments')).joins(:post).where("#{stage}.project_id = ?", project)
    end
  end

  def like_content_for(stage, project)
    if stage == :collect_info_posts
      voting_core_aspect_posts.joins(:post).where("core_aspect_posts.project_id = ?", project)
    else
      send('voting_'+stage.to_s).joins(:post).where("#{stage}.project_id = ?", project)
    end
  end

  def like_comment_for(stage, project)
    if stage == :collect_info_posts
      voting_core_aspect_comments.joins(:comment).joins("INNER JOIN core_aspect_posts ON core_aspect_posts.id = core_aspect_comments.post_id").where("core_aspect_posts.project_id = ?", project)
    else
      send('voting_'+stage.to_s.gsub('_posts', '_comments')).joins(:comment).joins("INNER JOIN #{stage} ON #{stage}.id = #{stage.to_s.gsub('_posts', '_comments')}.post_id").where("#{stage}.project_id = ?", project)
    end
  end

  def approve_content_for(stage, project)
    if stage == :collect_info_posts
      core_aspects.by_project(project).where(approve_status: true)
    else
      send(stage).by_project(project.id).where(approve_status: true)
    end
  end

  def approve_comment_for(stage, project)
    if stage == :collect_info_posts
      core_aspect_comments.joins(:post).where("core_aspect_posts.project_id = ?", project).where(approve_status: true)
    else
      send(stage.to_s.gsub('_posts', '_comments')).joins(:post).where("#{stage}.project_id = ?", project).where(approve_status: true)
    end
  end

  def likes_posts_for(stage, project)
    if stage == :collect_info_posts
      core_aspects.by_project(project).joins(:post_votings)
    else
      send(stage).by_project(project.id).joins(:post_votings)
    end
  end

  def likes_comments_for(stage, project)
    if stage == :collect_info_posts
      core_aspect_comments.joins(:post).where("core_aspect_posts.project_id = ?", project).joins(:comment_votings)
    else
      send(stage.to_s.gsub('_posts', '_comments')).joins(:post).where("#{stage}.project_id = ?", project).joins(:comment_votings)
    end
  end
end
