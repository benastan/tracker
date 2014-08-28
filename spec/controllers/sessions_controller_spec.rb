require 'spec_helper'

describe SessionsController do
  specify { expect(patch: '/session').to route_to(controller: 'sessions', action: 'update') }
  
  describe 'PATCH #update' do
    before do
      patch :update, sidebar: { focus: true }
    end

    specify { expect(session[:sidebar]).to eq('focus' => true) }
    specify { expect(response.code).to eq('200') }
  end
end