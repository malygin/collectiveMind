require 'spec_helper'

describe 'User', type: :model do
  it 'default factory - valid' do
    expect(build(:user)).to be_valid
  end

  it 'project_user_for' do
    user = create :user
    project_1 = create :core_project
    project_2 = create :core_project
    cpu_1 = create :core_project_user, user: user, core_project: project_1
    cpu_2 = create :core_project_user, user: user, core_project: project_2

    expect(user.project_user_for(project_1)).to eq cpu_1
    expect(user.project_user_for(project_2)).to eq cpu_2
  end
end
