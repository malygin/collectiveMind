shared_examples 'base cabinet' do
  # такая штука нужна потому что стадия называется collect_info, а контроллер нужен - aspect
  let(:stage_name) { @project.current_stage_type.to_s == 'collect_info_posts' ? 'aspect_posts' : @project.current_stage_type.to_s }

  context 'from procedure to cabinet' do
    before do
      visit Rails.application.routes.url_helpers.send("#{@project.current_stage_type.to_s}_path", @project)
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
      expect(page).to have_content t("cabinet.#{@project.current_stage_type.to_s}_sticker")[0..130]
      expect {
        within :css, '.stages_block' do
          click_link 'close_sticker'
        end
      }.to change(UserCheck, :count).by(1)
      refresh_page
      expect(page).not_to have_content t("cabinet.#{stage_name}_sticker")
    end
  end
end

def create_project_and_user_for(stage)
  @project = create :core_project, status: Core::Project::STATUS_CODES[stage]
  core_project_user = create :core_project_user, core_project: @project
  @user = core_project_user.user
end
