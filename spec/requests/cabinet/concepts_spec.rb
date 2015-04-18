require 'rake'
require 'spec_helper'

describe 'Cabinet Concepts' do
  subject { page }
  let (:project) { create :core_project, status: Core::Project::STATUS_CODES[:concept] }
  let (:core_project_user) { create :core_project_user, core_project: project }
  let (:user) { core_project_user.user }

  before do
    # тут еще нужно прицеплять техники к проекту
    #Rake::Task['seed:migrate'].invoke
    technique_1 = Technique::List.create stage: 'concept_posts', code: 'simple'
    project.techniques << technique_1

    sign_in user
    visit project_user_path(project, user)
  end

  it 'correct link to cabinet' do
    click_link 'open_cabinet'
    expect(current_path) == new_concept_post_path(project, type_mechanic: 'simple')
  end

  it 'list forms for techniques' do
    project.techniques.each do |technique|
      expect(page).to have_content t("techniques.#{technique.name}")
    end
  end

  context 'create with simple form', js: true do
    before do
      click_link 'new_concept_posts_simple'
    end

    it 'correct' do
      expect {
        fill_in 'concept_post_title', with: 'title for concept'
        fill_in 'concept_post_goal', with: 'goal in concept'
        fill_in 'concept_post_content', with: 'content concept'
        fill_in 'concept_post_actors', with: 'actors'
        fill_in 'concept_post_impact_env', with: 'impact environment'
        click_button 'send_post_concept'
        expect(page).to have_content t('form.concept.create_success')
      }.to change(Concept::Post, :count).by(1)
    end

    it 'empty fields - error' do
      expect {
        click_button 'send_post_concept'
        within :css, 'div#notice_messages' do
          expect(page).to have_css 'div.error_explanation'
        end
      }.not_to change(Concept::Post, :count)
    end
  end

  it 'created by current user' do
    concept = create :concept, user: user, project: project
    click_link 'open_my_concept_posts'
    expect(page).to have_content concept.content
  end
end
