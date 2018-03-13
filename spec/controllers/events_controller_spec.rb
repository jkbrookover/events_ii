require 'rails_helper'

describe EventsController do
  
  before do
    @event = Event.create!(event_attributes)
  end
  
  context "when signed in as a non-admin" do
    
    before do
      non_admin = User.create!(user_attributes(admin: false))
      session[:user_id] = non_admin.id
    end
    
    it "cannot access new" do
      get :new
      
      expect(response).to redirect_to(root_url)
    end
    
    it "cannot access create" do
      post :create
      
      expect(response).to redirect_to(root_url)
    end
    
    it "cannot access edit" do
      get :edit, params: { id: @event }
      
      expect(response).to redirect_to(root_url)
    end
    
    it "cannot access update" do
      patch :update, params: { id: @event }
      
      expect(response).to redirect_to(root_url)
    end
    
    it "cannot access destroy" do
      delete :destroy, params: { id: @event }
      
      expect(response).to redirect_to(root_url)
    end
    
  end
  
  context "when not signed in" do
    
    before do
      session[:user_id] = nil
    end
    
    it "cannot access new" do
      get :new
      
      expect(response).to redirect_to(new_session_url)
    end
    
    it "cannot access create" do
      post :create
      
      expect(response).to redirect_to(new_session_url)
    end
    
    it "cannot access edit" do
      get :edit, params: { id: @event }
      
      expect(response).to redirect_to(new_session_url)
    end
    
    it "cannot access update" do
      patch :update, params: { id: @event }
      
      expect(response).to redirect_to(new_session_url)
    end
    
    it "cannot access destroy" do
      delete :destroy, params: { id: @event }
      
      expect(response).to redirect_to(new_session_url)
    end
    
  end
  
end
