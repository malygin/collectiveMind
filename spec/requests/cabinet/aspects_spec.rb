require 'rake'
require 'spec_helper'

describe 'Cabinet Aspects' do
  subject { page }
  let (:core_project_user) { create :core_project_user }
  let (:user) { core_project_user.user }
  let (:project) { core_project_user.core_project }

  before do
    # Явно ставим статус проекту, чтобы быть уверенным, что он на аспектах
    project.update(status: Core::Project::STATUS_CODES[:collect_info])
    Rake::Task['seed:migrate'].invoke
    sign_in user
    visit project_user_path(project, user)
  end
  # тут еще нужно прицеплять техники к проекту

  it 'list forms for techniques' do
    project.techniques.each do |techniq|
      expect(page).to have_content teachniq.name
    end
  end

  it 'aspects by current user'
end
