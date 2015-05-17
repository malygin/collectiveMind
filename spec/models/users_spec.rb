require 'spec_helper'

describe 'User', type: :model do
  it 'default factory - valid' do
    expect(build(:user)).to be_valid
  end

  it 'project_user_for' do
    project_2 = create :core_project
    cpu_1 = create :core_project_user
    cpu_2 = create :core_project_user, user: cpu_1.user, core_project: project_2

    expect(cpu_1.user.project_user_for(cpu_1.core_project)).to eq cpu_1
    expect(cpu_1.user.project_user_for(project_2)).to eq cpu_2
  end
end
