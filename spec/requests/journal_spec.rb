require 'spec_helper'

describe 'Journal ' do
  subject { page }

  let (:user) { create :user }
  let (:moderator) { create :moderator }
  let (:project) { create :core_project }
  let! (:opened_project) { create :core_project }
  let! (:club_project) { create :core_project }

  before do
    Journal.destroy_all
    @journal_today = create :journal, project: project, user: user, body: 'news_today', created_at: Time.zone.now.utc.to_date + 12.hours
    @journal_yesterday = create :journal, project: project, user: user, body: 'news_yesterday', created_at: Time.zone.now.utc.yesterday.to_date + 12.hours
    @journal_older = create :journal, project: project, user: user, body: 'news_older', created_at: Time.zone.now.utc.yesterday.to_date - 12.hours
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
    end

    context 'success go to project ' do
      before do
        click_link "go_to_opened_project_#{project.id}"
        click_link 'go_to_journals'
      end

      it 'have content status ' do
        expect(page).to have_content 'События'
        expect(page).to have_selector 'a', 'вернуться к процедуре'
        expect(page).to have_content 'Сегодня'
        expect(page).to have_content 'Вчера'
        expect(page).to have_content 'Ранее'
      end

      it 'have content ' do
        expect(page).to have_content 'news_today'
        expect(page).to have_content 'news_yesterday'
        expect(page).to have_content 'news_older'
      end
    end

    context 'not have go to general_news ' do
      it 'not have news ' do
        expect(page).not_to have_content 'Общие новости'
      end

      it ' not admin set' do
        click_link "go_to_opened_project_#{project.id}"
        expect(page).not_to have_content 'Настройки Администратора'
      end

      it 'for general_news ' do
        visit '/general_news'
        expect(page.current_path).to eq root_path
        expect(page).not_to have_content 'Общие новости'
      end

      it 'for general_news project ' do
        visit "/project/#{project.id}/general_news"
        expect(page.current_path).to eq root_path
        expect(page).not_to have_content 'Общие новости'
      end

      it 'for general_rating ' do
        visit '/general_rating'
        expect(page.current_path).to eq root_path
        expect(page).not_to have_content 'Общие новости'
      end

      it 'for general_rating project ' do
        visit "/project/#{project.id}/general_rating"
        expect(page.current_path).to eq root_path
        expect(page).not_to have_content 'Общие новости'
      end
    end
  end

  context 'moderator sign in ' do
    before do
      sign_in moderator
    end

    context 'success go to project ' do
      before do
        click_link "go_to_opened_project_#{project.id}"
        click_link 'go_to_journals'
      end

      it 'have content status ' do
        expect(page).to have_content 'События'
        expect(page).to have_selector 'a', 'вернуться к процедуре'
        expect(page).to have_content 'Сегодня'
        expect(page).to have_content 'Вчера'
        expect(page).to have_content 'Ранее'
      end

      it 'have content ' do
        expect(page).to have_content 'news_today'
        expect(page).to have_content 'news_yesterday'
        expect(page).to have_content 'news_older'
      end
    end

    context 'success go to general news ' do
      before do
        click_link 'general_news'
      end

      it 'have content status and links ' do
        expect(page).to have_content 'События'
        expect(page).to have_content 'Сегодня'
        expect(page).to have_content 'Вчера'
        expect(page).to have_content 'Ранее'
        expect(page).to have_content 'news_today'
        expect(page).to have_content 'news_yesterday'
        expect(page).to have_content 'news_older'
        expect(page).to have_content 'ВСЕ НОВОСТИ'
        expect(page).to have_content 'Список процедур'
        expect(page).to have_content 'Фильтры'
      end

      it 'have project list ' do
        expect(page).to have_content opened_project.name
        expect(page).to have_content club_project.name
      end

      it 'have filter list ' do
        fill_in 'date_begin', with: Time.zone.now.utc.to_date
        fill_in 'date_end', with: Time.zone.now.utc.to_date
        click_button 'send_filter'
        expect(page).to have_content 'Сегодня'
        expect(page).not_to have_content 'Вчера'
        expect(page).not_to have_content 'Ранее'
        expect(page).to have_content 'news_today'
        expect(page).not_to have_content 'news_yesterday'
        expect(page).not_to have_content 'news_older'
      end

      it 'have go to project ' do
        click_link "go_to_project_#{project.id}"
        expect(page.current_path).to eq "/project/#{project.id}/general_news"
        expect(page).to have_content 'Сегодня'
        expect(page).to have_content 'Вчера'
        expect(page).to have_content 'Ранее'
        expect(page).to have_content 'news_today'
        expect(page).to have_content 'news_yesterday'
        expect(page).to have_content 'news_older'
      end

      it 'have go to project not event ' do
        click_link "go_to_project_#{opened_project.id}"
        expect(page.current_path).to eq "/project/#{opened_project.id}/general_news"
        expect(page).not_to have_content 'Сегодня'
        expect(page).not_to have_content 'Вчера'
        expect(page).not_to have_content 'Ранее'
        expect(page).not_to have_content 'news_today'
        expect(page).not_to have_content 'news_yesterday'
        expect(page).not_to have_content 'news_older'
      end
    end

    context 'success go to general_rating ' do
      before do
        click_link 'general_news'
        click_link 'go_to_rating'
      end

      it 'have content status and links ' do
        expect(page).to have_content 'Рейтинг участников'
        expect(page).to have_content 'ВСЕ УЧАСТНИКИ'
        expect(page).to have_content 'Список процедур'
        expect(page).to have_content 'Фильтры'
      end
    end
  end
end
