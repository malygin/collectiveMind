require 'rails_helper'

RSpec.describe "Discontent::PostAdvices", :type => :request do
  describe "GET /discontent_post_advices" do
    it "works! (now write some real specs)" do
      get discontent_post_advices_path
      expect(response).to have_http_status(200)
    end
  end
end
