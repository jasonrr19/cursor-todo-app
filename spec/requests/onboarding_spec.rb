require 'rails_helper'

RSpec.describe "Onboardings", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/onboarding/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/onboarding/update"
      expect(response).to have_http_status(:success)
    end
  end

end
