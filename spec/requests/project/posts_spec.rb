# encoding: utf-8
require 'spec_helper'
describe 'Core Project ' do
  subject { page }
  # screenshot_and_open_image
  # save_and_open_page
  let! (:user) {create :user }
  let! (:admin) {create :admin }
  let! (:project) {create :core_project, status: 1 }
  let! (:closed_project) {create :core_project, status: 1 , type_access: 2, name: "closed project"}


  context  'ordinary user sign in ' do
    before do
      sign_in user
      visit root_path
    end

    context 'not links for admin' do
      it 'not have link' do
        save_and_open_page
        expect(page).not_to  have_selector '#list_projects'
        expect(page).to have_content 'Открытые процедуры'
        expect(page).to have_content 'test project'
        expect(page).not_to have_content 'closed project'
      end

      it 'success redirect to root path for list projects' do
        visit list_projects_path
        expect(page).not_to  have_selector '#list_projects'
        expect(page).to have_content 'Открытые процедуры'
        expect(page).to have_content 'test project'
        expect(page).not_to have_content 'closed project'
      end

      it 'success redirect to root path for new project' do
        visit new_core_project_path
        expect(page).not_to  have_selector '#list_projects'
        expect(page).to have_content 'Открытые процедуры'
        expect(page).to have_content 'test project'
        expect(page).not_to have_content 'closed project'
      end

      it 'success redirect to root path for list users' do
        visit list_users_users_path(closed_project)
        expect(page).not_to  have_selector '#list_projects'
        expect(page).to have_content 'Открытые процедуры'
        expect(page).to have_content 'test project'
        expect(page).not_to have_content 'closed project'
      end
    end

    context 'root path' do
      before do
        click_link 'go_to_project'
      end
      it ' view root path redirect' do
        expect(page).not_to  have_selector '#new_aspect'
      end
      it_behaves_like 'validation links', :user, :project
    end
  end

  context 'moderator sign in' do
    before do
      sign_in admin
      visit root_path
    end

    context 'links for admin' do
      it 'link list_project' do
        expect(page).to have_selector '#list_projects'
      end
      it 'click list_project' do
        click_link 'list_projects'
        #save_and_open_page
        expect(page).to have_selector '#new_project'
      end
    end
    context 'new project' do
      before do
        visit new_core_project_path
      end

      it 'success new project' do
        expect(page).to have_content 'Форма создания новой процедуры'
        fill_in 'core_project_name', with: 'new project'
        fill_in 'core_project_short_desc', with: 'new project_short_desc'
        fill_in 'core_project_desc', with: 'new project_desc'
        select('Закрытая', :from => 'core_project_type_access')
        click_button 'send_project'
        expect(page).to have_content 'new project'
      end
    end
    context 'list_users_users' do
      before do
        visit list_users_users_path(closed_project)
      end
      it 'success list users for closed projects', js: true do
        expect(page).to have_content 'Выберите участников для закрытой процедуры'
        expect(page).to have_content closed_project.name
        expect(page).to have_content admin.to_s
        expect(page).to have_content 'Добавить'
        click_link "add_user_#{user.id}"
        expect(page).to have_selector "a", 'Удалить'
      end
    end
  end

  context 'expert sign in' do
  end

end