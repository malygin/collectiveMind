require 'spec_helper'

describe JournalController do

  describe "GET 'enter'" do
    it "returns http success" do
      get 'enter'
      response.should be_success
    end
  end

end
