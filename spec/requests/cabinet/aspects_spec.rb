require 'rake'
require 'spec_helper'

describe 'Cabinet Aspects' do
  subject { page }
  let (:project) { create :core_project, status: Core::Project::STATUS_CODES[:collect_info] }
  let (:core_project_user) { create :core_project_user, core_project: project }
  let (:user) { core_project_user.user }

  before do
    # тут еще нужно прицеплять техники к проекту
    #Rake::Task['seed:migrate'].invoke
    sign_in user
    visit project_user_path(project, user)
  end

  xit 'list forms for techniques' do
    project.techniques.each do |techniq|
      expect(page).to have_content teachniq.name
    end
  end

  it 'aspects by current user'
end
