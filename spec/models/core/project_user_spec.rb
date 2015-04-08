require 'spec_helper'

describe 'Core::ProjectUser' do
  it 'default factory - valid' do
    expect(build(:core_project_user)).to be_valid
  end

  context 'invalud without' do
    it 'user' do
      expect(build(:core_project_user, user: nil)).not_to be_valid
    end

    it 'project' do
      expect(build(:core_project_user, core_project: nil)).not_to be_valid
    end
  end
end
