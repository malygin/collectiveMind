require 'spec_helper'

describe 'Collect info' do
  subject { page }

  let!(:user) { @user = create :user }
  let (:user_data) { create :user }
  let!(:moderator) { @moderator = create :moderator }
  let (:project) { create :core_project }

  before do
    @post1 = create :collect_info_post, project: project
    @post2 = create :collect_info_post, project: project
    @aspect1 = @post1.aspect
    @aspect2 = @post2.aspect
    @comment_1 = create :collect_info_comment, post: @post1, user: user
    @comment_2 = create :collect_info_comment, post: @post1, comment: @comment_1
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
    end

    context 'life tape list ' do
      before do
        visit collect_info_posts_path(project)
      end

      it_behaves_like 'content with comments'
    end

    context 'success go to project ' do
      before do
        click_link "go_to_opened_project_#{project.id}"
      end

      it 'have content' do
        expect(page).to have_content @aspect1.content
        expect(page).to have_content @aspect2.content
        expect(page).to have_selector 'textarea#comment_text_area'
        validate_default_links_and_sidebar(project, user)
        validate_not_have_admin_links_for_user(project)
        validate_not_have_moderator_links_for_user(project)

        validation_visit_links_for_user(project, user)
        validation_visit_not_have_links_for_user(project, user)
      end
    end
  end

  context 'moderator sign in' do
    before do
      sign_in moderator
    end

    context 'success go to project ' do
      before do
        click_link "go_to_opened_project_#{project.id}"
      end

      it 'have content for moderator ' do
        expect(page).to have_content @aspect1.content
        expect(page).to have_content @aspect2.content
        expect(page).to have_selector 'textarea#comment_text_area'

        validate_default_links_and_sidebar(project, moderator)
        validate_not_have_admin_links_for_moderator(project)
        validate_have_moderator_links(project)

        validation_visit_links_for_user(project, moderator)
        validation_visit_links_for_moderator(project)
        validation_visit_not_have_links_for_moderator(project, moderator)
      end
    end

    context 'life tape list ' do
      before do
        visit collect_info_posts_path(project)
      end

      it_behaves_like 'content with comments', 'CollectInfo::Comment', true
    end
  end
end
