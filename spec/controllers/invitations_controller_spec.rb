require 'spec_helper'

describe InvitationsController do
  let(:user) { create(:user) }
  let(:invitation) { create(:invitation) }
  before { sign_in user }

  describe 'GET #show' do
    it 'assigns an invitation' do
      get :show, id: invitation.token

      expect(assigns[:invitation]).to eql(invitation)
    end

    it 'redirects guests to sign in' do
      sign_out user
      get :show, id: invitation.token

      expect(response).to redirect_to(user_session_path)
    end
  end

  describe 'PUT #update' do
    it 'creates a new OrganizationUser' do
      expect {
        put :update, id: invitation.token
      }.to change(OrganizationUser, :count).by(1)
    end

    it 'accepts the invitation' do
      put :update, id: invitation.token
      invitation.reload

      expect(invitation.accepted).to eql(true)
    end

    it 'redirects to the current users profile' do
      put :update, id: invitation.token

      expect(response).to redirect_to(user)
    end

    it 'creates admins if the invitation specifies as such' do
      invitation = create(:invitation, admin: true)

      expect {
        put :update, id: invitation.token
      }.to change(OrganizationUser.where(admin: true), :count).by(1)
    end
  end

  describe 'DELETE #destroy' do
    it 'declines the invitation' do
      delete :destroy, id: invitation.token
      invitation.reload

      expect(invitation.accepted).to eql(false)
    end

    it 'redirects to the current users profile' do
      delete :destroy, id: invitation.token

      expect(response).to redirect_to(user)
    end
  end
end
