class Award < ActiveRecord::Base
  has_many :user_awards
  has_many :users, through: :user_awards
  scope :for_project, lambda { |project| where('core_user_awards.project_id' => project) }

  validates :name, :url, presence: true

  # def self.reward(h={})
  #
  #   if h[:type] == 'like'
  #     awk = Core::UserAwardClick.where(user_id: h[:user], project_id: h[:project]).first_or_create
  #     awk.update_attributes(clicks: awk.clicks+1)
  #     case awk.clicks
  #       when 1
  #         a = Award.find_by_url('1like')
  #         Core::UserAward.create!(user: h[:user], award: a, project: h[:project])
  #         h[:user].journals.build(type_event: 'award_1like', project: h[:project], body: a.nil? ? '': a.name).save!
  #         h[:user].journals.build(type_event: 'my_award_1like', user_informed: h[:user], project: h[:project], body: a.nil? ? '': a.name, viewed: false, personal: true).save!
  #
  #       when 3
  #         a = Award.find_by_url('3likes')
  #         Core::UserAward.create!(user: h[:user], award: a, project: h[:project])
  #         h[:user].journals.build(type_event: 'award_3likes', project: h[:project], body: a.nil? ? '': a.name).save!
  #         h[:user].journals.build(type_event: 'my_award_3likes', user_informed: h[:user], project: h[:project], body: a.nil? ? '': a.name, viewed: false, personal: true).save!
  #
  #       when 5
  #         a = Award.find_by_url('5likes')
  #         Core::UserAward.create!(user: h[:user], award: a, project: h[:project])
  #         h[:user].journals.build(type_event: 'award_5likes', project: h[:project], body: a.nil? ? '': a.name).save!
  #         h[:user].journals.build(type_event: 'my_award_5likes', user_informed: h[:user], project: h[:project], body: a.nil? ? '': a.name, viewed: false, personal: true).save!
  #
  #       when 15
  #         a = Award.find_by_url('15liцфes')
  #         Core::UserAward.create!(user: h[:user], award: a, project: h[:project])
  #         h[:user].journals.build(type_event: 'award_15likes', project: h[:project], body: a.nil? ? '': a.name).save!
  #         h[:user].journals.build(type_event: 'my_award_15likes', user_informed: h[:user], project: h[:project], body: a.nil? ? '': a.name, viewed: false, personal: true).save!
  #
  #       when 50
  #         a = Award.find_by_url('50likes')
  #         Core::UserAward.create!(user: h[:user], award: a, project: h[:project])
  #         h[:user].journals.build(type_event: 'award_50likes', project: h[:project], body: a.nil? ? '': a.name).save!
  #         h[:user].journals.build(type_event: 'my_award_50likes', user_informed: h[:user], project: h[:project], body: a.nil? ? '': a.name, viewed: false, personal: true).save!
  #     end
  #
  #   elsif h[:type] == 'unlike'
  #     awk = Core::UserAwardClick.where(user_id: h[:user], project_id: h[:project]).first_or_create
  #     awk.update_attributes(clicks: awk.clicks-1)
  #     if awk.clicks < 1
  #       a = Award.find_by_url('1like')
  #       Core::UserAward.where(user: h[:user], award: a, project: h[:project]).destroy_all
  #       Journal.destroy_journal_award(h[:project], 'award_1like', false, h[:user])
  #       Journal.destroy_journal_award(h[:project],'my_award_1like', true, h[:user], h[:user])
  #     elsif awk.clicks < 3
  #       a = Award.find_by_url('3likes')
  #       Core::UserAward.where(user: h[:user], award: a, project: h[:project]).destroy_all
  #       Journal.destroy_journal_award(h[:project], 'award_3likes', false, h[:user])
  #       Journal.destroy_journal_award(h[:project],'my_award_3likes', true, h[:user], h[:user])
  #     elsif awk.clicks < 5
  #       a = Award.find_by_url('5likes')
  #       Core::UserAward.where(user: h[:user], award: a, project: h[:project]).destroy_all
  #       Journal.destroy_journal_award(h[:project], 'award_5likes', false, h[:user])
  #       Journal.destroy_journal_award(h[:project],'my_award_5likes', true, h[:user], h[:user])
  #     elsif awk.clicks < 15
  #       a = Award.find_by_url('15likes')
  #       Core::UserAward.where(user: h[:user], award: a, project: h[:project]).destroy_all
  #       Journal.destroy_journal_award(h[:project], 'award_15likes', false, h[:user])
  #       Journal.destroy_journal_award(h[:project],'my_award_15likes', true, h[:user], h[:user])
  #     elsif awk.clicks < 50
  #       a = Award.find_by_url('50likes')
  #       Core::UserAward.where(user: h[:user], award: a, project: h[:project]).destroy_all
  #       Journal.destroy_journal_award(h[:project], 'award_50likes', false, h[:user])
  #       Journal.destroy_journal_award(h[:project],'my_award_50likes', true, h[:user], h[:user])
  #     end
  #   elsif h[:type] == 'add'
  #     if h[:post].instance_of? Discontent::Post
  #       count_d = h[:user].discontent_posts.by_project(h[:project]).where(useful: true).count
  #       case count_d
  #         when 1
  #           a = Award.find_by_url('1imperfection')
  #           Core::UserAward.create!(user: h[:user], award: a, project: h[:project])
  #           h[:user].journals.build(type_event: 'award_1imperfection', project: h[:project], body: a.nil? ? '': a.name).save!
  #           h[:user].journals.build(type_event: 'my_award_1imperfection', user_informed: h[:user], project: h[:project], body: a.nil? ? '': a.name, viewed: false, personal: true).save!
  #         when 3
  #           a = Award.find_by_url('3imperfection')
  #           Core::UserAward.create!(user: h[:user], award: a, project: h[:project])
  #           h[:user].journals.build(type_event: 'award_3imperfection', project: h[:project], body: a.nil? ? '': a.name).save!
  #           h[:user].journals.build(type_event: 'my_award_3imperfection', user_informed: h[:user], project: h[:project], body: a.nil? ? '': a.name, viewed: false, personal: true).save!
  #         when 5
  #           a = Award.find_by_url('5imperfection')
  #           Core::UserAward.create!(user: h[:user], award: a, project: h[:project])
  #           h[:user].journals.build(type_event: 'award_5imperfection', project: h[:project], body: a.nil? ? '': a.name).save!
  #           h[:user].journals.build(type_event: 'my_award_5imperfection', user_informed: h[:user], project: h[:project], body: a.nil? ? '': a.name, viewed: false, personal: true).save!
  #         when 15
  #           a = Award.find_by_url('15imperfection')
  #           Core::UserAward.create!(user: h[:user], award: a, project: h[:project])
  #           h[:user].journals.build(type_event: 'award_15imperfection', project: h[:project], body: a.nil? ? '': a.name).save!
  #           h[:user].journals.build(type_event: 'my_award_15imperfection', user_informed: h[:user], project: h[:project], body: a.nil? ? '': a.name, viewed: false, personal: true).save!
  #         end
  #     elsif  h[:post].instance_of? Concept::Post
  #       count_d = h[:user].concept_posts.by_project(h[:project]).where(useful: true).count
  #       if count_d == 1
  #         a = Award.find_by_url('1innovation')
  #         Core::UserAward.create!(user: h[:user], award: a, project: h[:project])
  #         h[:user].journals.build(type_event: 'award_1innovation', project: h[:project], body: a.nil? ? '': a.name).save!
  #         h[:user].journals.build(type_event: 'my_award_1innovation', user_informed: h[:user], project: h[:project], body: a.nil? ? '': a.name, viewed: false, personal: true).save!
  #       elsif count_d == 3
  #         a = Award.find_by_url('3innovation')
  #         Core::UserAward.create!(user: h[:user], award: a, project: h[:project])
  #         h[:user].journals.build(type_event: 'award_3innovation', project: h[:project], body: a.nil? ? '': a.name).save!
  #         h[:user].journals.build(type_event: 'my_award_3innovation', user_informed: h[:user], project: h[:project], body: a.nil? ? '': a.name, viewed: false, personal: true).save!
  #       elsif count_d == 5
  #         a = Award.find_by_url('5innovation')
  #         Core::UserAward.create!(user: h[:user], award: a, project: h[:project])
  #         h[:user].journals.build(type_event: 'award_5innovation', project: h[:project], body: a.nil? ? '': a.name).save!
  #         h[:user].journals.build(type_event: 'my_award_5innovation', user_informed: h[:user], project: h[:project], body: a.nil? ? '': a.name, viewed: false, personal: true).save!
  #       elsif count_d == 15
  #         a = Award.find_by_url('15innovation')
  #         Core::UserAward.create!(user: h[:user], award: a, project: h[:project])
  #         h[:user].journals.build(type_event: 'award_15innovation', project: h[:project], body: a.nil? ? '': a.name).save!
  #         h[:user].journals.build(type_event: 'my_award_15innovation', user_informed: h[:user], project: h[:project], body: a.nil? ? '': a.name, viewed: false, personal: true).save!
  #       end
  #     end
  #   elsif h[:type] == 'remove'
  #     if h[:post].instance_of? Discontent::Post
  #       count_d = h[:user].discontent_posts.by_project(h[:project]).where(useful: true).count
  #       if count_d < 1
  #         a = Award.find_by_url('1imperfection')
  #         Core::UserAward.where(user: h[:user], award: a, project: h[:project]).destroy_all
  #         Journal.destroy_journal_award(h[:project], 'award_1imperfection', false, h[:user])
  #         Journal.destroy_journal_award(h[:project],'my_award_1imperfection', true, h[:user], h[:user])
  #       elsif count_d < 3
  #         a = Award.find_by_url('3imperfection')
  #         Core::UserAward.where(user: h[:user], award: a, project: h[:project]).destroy_all
  #         Journal.destroy_journal_award(h[:project], 'award_3imperfection', false, h[:user])
  #         Journal.destroy_journal_award(h[:project],'my_award_3imperfection', true, h[:user], h[:user])
  #       elsif count_d < 5
  #         a = Award.find_by_url('5imperfection')
  #         Core::UserAward.where(user: h[:user], award: a, project: h[:project]).destroy_all
  #         Journal.destroy_journal_award(h[:project], 'award_5imperfection', false, h[:user])
  #         Journal.destroy_journal_award(h[:project],'my_award_5imperfection', true, h[:user], h[:user])
  #       elsif count_d < 15
  #         a = Award.find_by_url('15imperfection')
  #         Core::UserAward.where(user: h[:user], award: a, project: h[:project]).destroy_all
  #         Journal.destroy_journal_award(h[:project], 'award_15imperfection', false, h[:user])
  #         Journal.destroy_journal_award(h[:project],'my_award_15imperfection', true, h[:user], h[:user])
  #       end
  #     elsif  h[:post].instance_of? Concept::Post
  #       count_d = h[:user].concept_posts.by_project(h[:project]).where(useful: true).count
  #       if count_d < 1
  #         a = Award.find_by_url('1innovation')
  #         Core::UserAward.where(user: h[:user], award: a, project: h[:project]).destroy_all
  #         Journal.destroy_journal_award(h[:project], 'award_1innovation', false, h[:user])
  #         Journal.destroy_journal_award(h[:project],'my_award_1innovation', true, h[:user], h[:user])
  #       elsif count_d < 3
  #         a = Award.find_by_url('3innovation')
  #         Core::UserAward.where(user: h[:user], award: a, project: h[:project]).destroy_all
  #         Journal.destroy_journal_award(h[:project], 'award_3innovation', false, h[:user])
  #         Journal.destroy_journal_award(h[:project],'my_award_3innovation', true, h[:user], h[:user])
  #       elsif count_d < 5
  #         a = Award.find_by_url('5innovation')
  #         Core::UserAward.where(user: h[:user], award: a, project: h[:project]).destroy_all
  #         Journal.destroy_journal_award(h[:project], 'award_5innovation', false, h[:user])
  #         Journal.destroy_journal_award(h[:project],'my_award_5innovation', true, h[:user], h[:user])
  #       elsif count_d < 15
  #         a = Award.find_by_url('15innovation')
  #         Core::UserAward.where(user: h[:user], award: a, project: h[:project]).destroy_all
  #         Journal.destroy_journal_award(h[:project], 'award_15innovation', false, h[:user])
  #         Journal.destroy_journal_award(h[:project],'my_award_15innovation', true, h[:user], h[:user])
  #       end
  #     end
  #
  #   elsif h[:type] == 'max'                §
  #     if h[:score] >= 100 and h[:old_score] < 100
  #       a = Award.find_by_url('100points')
  #       Core::UserAward.create!(user: h[:user], award: a, project: h[:project])
  #       h[:user].journals.build(type_event: 'award_100points', project: h[:project], body: a.nil? ? '': a.name).save!
  #       h[:user].journals.build(type_event: 'my_award_100points', user_informed: h[:user], project: h[:project], body: a.nil? ? '': a.name, viewed: false, personal: true).save!
  #     elsif h[:score] >= 500 and h[:old_score] < 500
  #       a = Award.find_by_url('500points')
  #       Core::UserAward.create!(user: h[:user], award: a, project: h[:project])
  #       h[:user].journals.build(type_event: 'award_500points', project: h[:project], body: a.nil? ? '': a.name).save!
  #       h[:user].journals.build(type_event: 'my_award_500points', user_informed: h[:user], project: h[:project], body: a.nil? ? '': a.name, viewed: false, personal: true).save!
  #     elsif h[:score] >= 1000 and h[:old_score] < 1000
  #       a = Award.find_by_url('1000points')
  #       Core::UserAward.create!(user: h[:user], award: a, project: h[:project])
  #       h[:user].journals.build(type_event: 'award_1000points', project: h[:project], body: a.nil? ? '': a.name).save!
  #       h[:user].journals.build(type_event: 'my_award_1000points', user_informed: h[:user], project: h[:project], body: a.nil? ? '': a.name, viewed: false, personal: true).save!
  #     elsif h[:score] >= 3000 and h[:old_score] < 3000
  #       a = Award.find_by_url('3000points')
  #       Core::UserAward.create!(user: h[:user], award: a, project: h[:project])
  #       h[:user].journals.build(type_event: 'award_3000points', project: h[:project], body: a.nil? ? '': a.name).save!
  #       h[:user].journals.build(type_event: 'my_award_3000points', user_informed: h[:user], project: h[:project], body: a.nil? ? '': a.name, viewed: false, personal: true).save!
  #
  #     elsif h[:old_score] >= 100 and h[:score] < 100
  #       a = Award.find_by_url('100points')
  #       Core::UserAward.where(user: h[:user], award: a, project: h[:project]).destroy_all
  #       Journal.destroy_journal_award(h[:project], 'award_100points', false, h[:user])
  #       Journal.destroy_journal_award(h[:project],'my_award_100points', true, h[:user], h[:user])
  #     elsif h[:old_score] >= 500 and h[:score] < 500
  #       a = Award.find_by_url('500points')
  #       Core::UserAward.where(user: h[:user], award: a, project: h[:project]).destroy_all
  #       Journal.destroy_journal_award(h[:project], 'award_500points', false, h[:user])
  #       Journal.destroy_journal_award(h[:project],'my_award_500points', true, h[:user], h[:user])
  #     elsif h[:old_score] >= 1000 and h[:score] < 1000
  #       a = Award.find_by_url('1000points')
  #       Core::UserAward.where(user: h[:user], award: a, project: h[:project]).destroy_all
  #       Journal.destroy_journal_award(h[:project], 'award_1000points', false, h[:user])
  #       Journal.destroy_journal_award(h[:project],'my_award_1000points', true, h[:user], h[:user])
  #     elsif h[:old_score] >= 3000 and h[:score] < 3000
  #       a = Award.find_by_url('3000points')
  #       Core::UserAward.where(user: h[:user], award: a, project: h[:project]).destroy_all
  #       Journal.destroy_journal_award(h[:project], 'award_3000points', false, h[:user])
  #       Journal.destroy_journal_award(h[:project],'my_award_3000points', true, h[:user], h[:user])
  #    end
  #   end
  #
  # end
end
