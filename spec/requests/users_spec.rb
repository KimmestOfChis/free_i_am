require "rails_helper"

RSpec.describe "Users" do
  let(:password) { "Password123!@#" }
  let(:user_params) do
    attributes_for(:user, password:, password_confirmation: password)
  end

  describe "POST /users" do
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
        expect(response.parsed_body).to include({ "status" => 422, "message" => "Validation Failed",
                                                  "details" => [
                                                    "Password can't be blank",
                                                    "Email can't be blank",
                                                    "Email is invalid",
                                                    "Password is too short (minimum is 6 characters)",
                                                    "Password Complexity requirement not met. Please use: 1 uppercase, 1 lowercase, 1 digit and 1 special character"
                                                  ] })
      }
    end

    context "when email is already taken" do
      before do
        create(:user, email: user_params[:email])
        post "/users", params: user_params
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it {
        expect(response.parsed_body).to include({
                                                  "status" => 422,
                                                  "message" => "Validation Failed",
                                                  "details" => ["Email has already been taken"]
                                                })
      }
    end
  end

  describe "PUT /users/:id" do
    let(:email) { Faker::Internet.email }
    let(:user) { create(:user) }

    context "when user is valid" do
      before do
        put "/users/#{user.id}", params: { email:, password:, password_confirmation: password }
      end

      let(:fetched_user) { User.find(user.id) }

      it { expect(response).to have_http_status(:ok) }

      it {
        expect(response.parsed_body).to eq({ "id" => fetched_user.id,
                                             "email" => email,
                                             "created_at" => fetched_user.created_at.as_json,
                                             "updated_at" => fetched_user.updated_at.as_json })
      }
    end

    context "when email is already taken" do
      before do
        new_user = create(:user)
        put "/users/#{new_user.id}", params: { email: user.email, password:, password_confirmation: password }
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it {
        expect(response.parsed_body).to include({
                                                  "status" => 422,
                                                  "message" => "Validation Failed",
                                                  "details" => ["Email has already been taken"]
                                                })
      }
    end
  end

  describe "DELETE /users/:id" do
    let(:user) { create(:user) }

    context "when the user exists" do
      before do
        delete "/users/#{user.id}"
      end

      it { expect(response).to have_http_status(:ok) }

      it {
        expect(response.parsed_body).to eq({ "status" => 200, "message" => "User deleted successfully" })
      }
    end

    context "when the user does not exist" do
      before do
        delete "/users/0"
      end

      it { expect(response).to have_http_status(:not_found) }

      it {
        expect(response.parsed_body).to eq({ "status" => 404, "message" => "Not Found", "details" => "Couldn't find User with 'id'=0" })
      }
    end
  end
end
