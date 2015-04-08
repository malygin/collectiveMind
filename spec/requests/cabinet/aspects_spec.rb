require 'spec_helper'

describe 'Cabinet Aspects' do
  subject { page }
  let (:core_project_user) { create :core_project_user }
  let (:user) { core_project_user.user }
  let (:project) { core_project_user.core_project }

  before do
    # Явно ставим статус проекту, чтобы быть уверенным, что он на аспектах
    project.update(status: Core::Project::STATUS_CODES[:collect_info])
    sign_in user
    visit project_user_path(project, user)
  end
  # тут еще нужно прицеплять техники к проекту

  it 'list forms for techniques' do
    
  end
end
