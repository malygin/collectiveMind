class Novation::Post < ActiveRecord::Base
  include BasePost
  SCORE = 100

  has_many :voted_users, through: :final_votings, source: :user
  has_many :final_votings, foreign_key: 'novation_post_id', class_name: 'Novation::Voting'

  has_many :novation_post_concepts, class_name: 'Novation::PostConcept'
  has_many :novation_concepts, through: :novation_post_concepts, source: :concept_post, class_name: 'Concept::Post'

  has_many :core_content_questions, -> { where post_type: 'novation' }, class_name: 'Core::Content::Question'

  validates :title, presence: true
  ATTRIBUTES_WITH_BOOL = %w(members_new members_education members_motivation resource_commands resource_support resource_competition
                            confidence_commands confidence_remove_discontent confidence_negative_results)

  def attributes_for_form
    result = {}
    used_attributes.each do |attribute|
      attribute_parts = attribute.split('_')
      unless attribute_parts.last == 'bool'
        result[attribute_parts[0]] ||= []
        result[attribute_parts[0]] << [attribute, ATTRIBUTES_WITH_BOOL.include?(attribute)]
      end
    end

    result
  end

  def used_attributes
    (attribute_names - %w(id title user_id number_views status project_id created_at updated_at content approve_status fullness useful))
  end

  # @todo refac
  # def update_fullness
  #   count_all = 0
  #   count_filled = 0
  #   attributes_for_form.each do |type_attribute|
  #     type_attribute.second.each do |attribute, bool_attribute|
  #       count_all += 1
  #       count_filled += 1 if send(attribute) != ''
  #       if bool_attribute
  #         count_all += 1
  #         count_filled += 1 unless send("#{attribute}_bool").nil?
  #       end
  #     end
  #   end
  #
  #   self.fullness = ((count_filled.to_f / count_all) * 100).to_i
  #   save
  # end
end
