require "rails_helper"

RSpec.describe "Users" do
  describe "POST /users" do
    let(:password) { "Password123!@#" }
    let(:user_params) do
      attributes_for(:user, password:, password_confirmation: password)
    end

    context "when user is valid" do
      before do
        post "/users", params: user_params
      end

      it { expect(response).to have_http_status(:created) }

      it {
        expect(response.parsed_body).to eq({ "id" => User.last.id,
                                             "email" => user_params[:email],
                                             "created_at" => User.last.created_at.as_json,
                                             "updated_at" => User.last.updated_at.as_json })
      }

      it { expect { User.find_by(email: user_params[:email]) }.not_to raise_error }
    end

    context "when user is invalid" do
      before do
        post "/users", params: { user: { email: "" } }
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it {
        expect(response.parsed_body["errors"]).to include("Email can't be blank")
      }
    end
  end
end
