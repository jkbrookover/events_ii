require 'rails_helper'

describe RegistrationsController do
  
  before do
    @event = Event.create!(event_attributes)
  end
  
  context "when not signed in" do
    
    before do
      session[:user_id] = nil
    end
    
    it "cannot access index" do
      get :index,  params: { event_id: @event.id }
      
      expect(response).to redirect_to(new_session_url)
    end
    
    it "cannot access new" do
      get :new, params: { event_id: @event.id }
      
      expect(response).to redirect_to(new_session_url)
    end
    
    it "cannot access create" do
      post :create, params: { event_id: @event.id }
      
      expect(response).to redirect_to(new_session_url)
    end
    
  end
  
end
