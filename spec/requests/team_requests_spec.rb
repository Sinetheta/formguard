require "rails_helper"

RSpec.describe "Team requests:", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:team) { create(:team) }
  let!(:action) { create(:form_action, team_id: team.id) }


  describe "GET /forms/:id" do
    subject { get "/forms/#{action.id}" }

    context "when signed in user belongs to team" do
      before do
        login_as(user)
        team.members << user
      end

      it "returns a 200 status code" do
        subject
        expect(response).to have_http_status(200)
      end
    end

    context "when signed in user does not belong to team" do
      before do
        logout(user)
        login_as(other_user)
      end

      it { is_expected.to redirect_to(authenticated_root_path) }
    end

    context "when user not signed in" do
      before do
        logout(other_user)
        logout(user)
      end

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end


  describe "GET '/teams/:id' " do
    subject { get "/teams/#{team.id}" }

    context "when user belongs to team" do
      before do
        login_as(user)
        team.members << user
      end

      it "returns a 200 status code" do
        subject
        expect(response).to have_http_status(200)
      end
    end

    context "when signed in user does not belong to team" do
      before do
        logout(user)
        login_as(other_user)
      end

      it { is_expected.to redirect_to(authenticated_root_path) }
    end

    context "when user not signed in" do
      before do
        logout(user)
        logout(other_user)
      end
      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end


  describe "POST /teams" do
    subject { post "/teams", team: attributes_for(:team) }

    context "when user signed in" do
      before { login_as(user) }

      context "with valid team params" do
        it "creates a team" do
          expect { subject }.to change(Team, :count).by(1)
        end
      end

      context "when save fails" do
        before { allow_any_instance_of(Team).to receive(:save).and_return(false) }
        it "returns a 500 error" do
          subject
          expect(response).to have_http_status(500)
        end
      end
    end

    context "when not signed in" do
      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end


  describe "GET /teams" do
    subject { get "/teams" }

    context "when user signed in" do
      before { login_as(user) }

      it "returns a 200 status code" do
        subject
        expect(response).to have_http_status(200)
      end
    end

    context "when user not signed in" do
      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end
end
