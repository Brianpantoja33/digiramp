require 'rails_helper'

RSpec.describe "CreativeProjectUsers", :type => :request do
  describe "GET /creative_project_users" do
    it "works! (now write some real specs)" do
      get creative_project_users_path
      expect(response).to have_http_status(200)
    end
  end
end
