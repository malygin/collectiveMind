# encoding: utf-8
require 'spec_helper'
describe 'Journal ' do
  subject { page }
  # screenshot_and_open_image
  # save_and_open_page
  let (:user) {create :user }
  let (:prime_admin) {create :prime_admin }
  let (:moderator) {create :moderator }
  let (:project) {create :core_project, status: 1 }
  let (:closed_project) {create :core_project, status: 1 , type_access: 2, name: "closed project"}

  before  do
    prepare_journal(project,user)
  end

  context  'ordinary user sign in ' do
    before do
      sign_in user
      visit root_path
    end
    context 'success go to project ' do
      before do
        click_link "go_to_opened_project_#{project.id}"
        click_link "go_to_journals"
      end
      it 'have content for user ' do
        expect(page).to have_content 'События'
        expect(page).to have_selector "a", 'вернуться к процедуре'
        expect(page).to have_content 'Сегодня'
        expect(page).to have_content 'Вчера'
        expect(page).to have_content 'Ранее'
      end
      it 'have content for user ' do
        expect(page).to have_content 'news_today'
        expect(page).to have_content 'news_yesterday'
        expect(page).to have_content 'news_older'
      end
    end
  end

  context 'moderator sign in ' do
    before do
      sign_in moderator
      visit root_path
    end
    context 'success go to project ' do
      before do
        click_link "go_to_opened_project_#{project.id}"
        click_link "go_to_journals"
      end
      it 'have content for user ' do
        expect(page).to have_content 'События'
        expect(page).to have_selector "a", 'вернуться к процедуре'
        expect(page).to have_content 'Сегодня'
        expect(page).to have_content 'Вчера'
        expect(page).to have_content 'Ранее'
      end
      it 'have content for user ' do
        expect(page).to have_content 'news_today'
        expect(page).to have_content 'news_yesterday'
        expect(page).to have_content 'news_older'
      end
    end
  end

  context 'expert sign in ' do

  end
end