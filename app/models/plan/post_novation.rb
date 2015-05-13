class Plan::PostNovation < ActiveRecord::Base
  belongs_to :novation_post, class_name: 'Novation::Post'
  belongs_to :plan_post, class_name: 'Plan::Post', foreign_key: :plan_post_id

  def attributes_for_form
    {project: {
        project_goal: -1,
        project_change: -1,
        project_members: -1,
        project_results: -1,
        project_time: -1,
        members_execute: -1,
        members_who: -1,
        resource_financial: -1,
        resource_internal: -1,
        resource_external: true,
        resource_commands: -1,
    },
     members: {
         members_new: true,
         members_motivation: true,
         members_education: true,
         confidence_commands: false,
         resource_support: false,
     },
     resource: {
         resource_competition: true,
     },
     confidence: {
         confidence_remove_discontent: false,
         confidence_negative_results: true
     }}
  end
end
