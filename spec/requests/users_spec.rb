require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "POST /users" do
    let(:password) { "Password123!@#" }
    let(:user_params) do
      {
        user: {
          email: Faker::Internet.email,
          password: password,
          password_confirmation: password,
        },
      }
    end

    context "when user is valid" do
      before do
        post "/users", params: user_params
      end

      it "returns status code 201" do
        user = User.last
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to eq({
                                               "id" => user.id,
                                               "email" => user_params[:user][:email],
                                               "created_at" => user.created_at.as_json,
                                               "updated_at" => user.updated_at.as_json,
                                             })
        expect { User.find_by(email: user.email) }.not_to raise_error
      end

      it "returns an error when the parameters are invalid" do
        user_params[:user][:email] = nil
        post "/users", params: user_params
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({
                                               "errors" => ["Email can't be blank", "Email is invalid"],
                                             })
      end
    end
  end
end
