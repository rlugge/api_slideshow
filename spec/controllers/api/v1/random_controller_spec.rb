require 'rails_helper'

RSpec.describe Api::V1::RandomController, :type => :controller do

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET update" do
    it "returns http success" do
      put :update, {seed:1}
      expect(response).to have_http_status(:success)
    end
  end

end
