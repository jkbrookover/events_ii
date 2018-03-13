require 'rails_helper'

describe "Viewing a user's profile page" do
  
  it "shows the user's details" do
    user = User.create!(user_attributes)
    
    sign_in(user)
                          
    visit user_url(user)
    
    expect(page).to have_text(user.name)
    expect(page).to have_text(user.email)
  end

  it "shows the user's liked events in the sidebar" do
    user = User.create!(user_attributes)

    event = Event.create!(event_attributes)
    user.liked_events << event

    sign_in(user)

    visit user_url(user)

    within("aside#sidebar") do
      expect(page).to have_text(event.name)
    end
  end

  it "includes the user name in the page title" do
    user = User.create!(user_attributes)

    sign_in(user)

    visit user_url(user)

    expect(page).to have_title("Events - #{user.name}")
  end
  
end
