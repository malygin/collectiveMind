shared_examples 'base cabinet' do
  # такая штука нужна потому что стадия называется aspect, а контроллер нужен - aspect
  let(:stage_name) { @current_stage_type }

  context 'from procedure to cabinet' do
    before do
      visit Rails.application.routes.url_helpers.send("#{@current_stage_type}_path", @project)
    end

    it 'correct link from header' do
      click_link 'open_cabinet'
      expect(current_path) == cabinet_stage_url
    end

    it 'correct link from page' do
      click_link "new_#{stage_name}"
      expect(current_path) == cabinet_stage_url
    end
  end

  context 'in cabinet' do
    before do
      visit cabinet_stage_url
    end

    it 'list forms for techniques' do
      @project.techniques.each do |technique|
        expect(page).to have_content t("techniques.#{technique.name}")
      end
    end

    it 'close sticker' do
      expect(page).to have_content t("cabinet.#{@current_stage_type}_sticker")[0..130]
      expect {
          click_link 'cabinet_close_sticker'
      }.to change(UserCheck, :count).by(1)
      refresh_page
      expect(page).not_to have_content t("cabinet.#{stage_name}_sticker")
    end
  end

  context 'stages navbar' do
    it 'have stages navbar', js: true do
      user_content_path = Rails.application.routes.url_helpers.send("user_content_#{@current_stage_type}_path", @project)
      visit user_content_path
      expect(page).to have_link("go_to_user_content_#{@current_stage_type}", href: user_content_path)
      Core::Project::STAGES.each do |num_stage, stage|
        if num_stage <= 5
          if @main_stage >= num_stage
            user_content_path = Rails.application.routes.url_helpers.send("user_content_#{stage[:type_stage]}_path", @project)
            expect(page).to have_link("go_to_user_content_#{stage[:type_stage]}", href: user_content_path)
          else
            expect(page).to have_link("go_to_user_content_#{stage[:type_stage]}", href: '#')
          end
        end
      end
    end
  end
end

def create_project_and_user_for(stage)
  @project = create :core_project, stage: stage
  pd = ProjectDecorator.new(@project)
  @current_stage_type_for_cabinet_url = pd.current_stage_type_for_cabinet_url
  @current_stage_type = pd.current_stage_type.to_s
  @main_stage = pd.main_stage
  core_project_user = create :core_project_user, core_project: @project
  @user = core_project_user.user
end
