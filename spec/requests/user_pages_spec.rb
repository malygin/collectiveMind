# encoding: utf-8
require 'spec_helper'

describe "index page" do
  subject { page }
  describe "GET root_path" do

    let(:user) { FactoryGirl.create(:user) }
    before(:all) { 30.times { FactoryGirl.create(:core_project) } }

    before(:each) do
      visit root_path
    end
    it { should have_selector('title', text: 'collective decision') }
    it { should have_content('Успех и благополучи') }
    it { should have_selector('h1',    text: 'МАССОВАЯ СЕТЕВАЯ РАЦИОНАЛЬНАЯ ДЕМОКРАТИЧНАЯ ИГРОВАЯ ВЫРАБОТКА РЕШЕНИЙ.') }
  end

end
