require 'spec_helper'

describe 'Core::Project' do
  it 'default factory - valid' do
    expect(build(:core_project)).to be_valid
  end

  describe 'invalid' do
    context 'without' do
      it 'name' do
        expect(build(:core_project, name: nil)).not_to be_valid
      end
    end

    xit 'status not in list' do
      expect(build(:core_project, status: -1)).not_to be_valid
    end

    xit 'type not in list' do
      expect(build(:core_project, type_access: 6)).not_to be_valid
    end
  end

  context 'methods' do
    let(:count_journals) { 10 }

    before do
      @project = create :core_project
      @second_project = create :core_project
      @project_visits = create_list :journal, count_journals, type_event: 'visit_save', project: @project
      @second_project_visits = create_list :journal, count_journals, type_event: 'visit_save', project: @second_project
    end

    context 'statistic_visits', skip: true do
      it 'only for project' do
        expect(@project.statistic_visits(5.days.ago)).to match_array @project_visits
        expect(@project.statistic_visits(5.days.ago)).not_to match_array @second_project_visits
      end

      it 'only visits' do
        expect(@project.statistic_visits(5.days.ago).map(&:type_event)).to match_array Array.new(count_journals, 'visit_save')
      end
    end

    xit 'check statuses' do
      Core::Project::STATUS_CODES.each do |key, value|
        @project.update!(status: value)
        expect(@project.send("stage_#{key}?")).to be true
      end
    end
  end
end
