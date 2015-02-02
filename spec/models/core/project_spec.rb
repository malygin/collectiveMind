require 'spec_helper'

describe 'Core::Project' do
  let(:count_journals) { 10 }

  before do
    @project = create :core_project
    @second_project = create :core_project
    @project_visits = create_list :journal, count_journals, type_event: 'visit_save', project: @project
    @second_project_visits = create_list :journal, count_journals, type_event: 'visit_save', project: @second_project
  end

  context 'statistic_visits' do
    it 'only for project' do
      expect(@project.statistic_visits(5.days.ago)).to match_array @project_visits
      expect(@project.statistic_visits(5.days.ago)).not_to match_array @second_project_visits
    end

    it 'only visits' do
      expect(@project.statistic_visits(5.days.ago).map(&:type_event)).to match_array Array.new(count_journals, 'visit_save')
    end
  end
end
