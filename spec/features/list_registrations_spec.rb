require 'rails_helper'

describe "Viewing a list of registrations" do

  before do
    user = User.create!(user_attributes)
    sign_in(user)
  end
  
  it "shows the registrations for a specific event" do    
    event1 = Event.create!(event_attributes(name: "BugSmash"))
    registration1 = event1.registrations.new(registration_attributes)
    user1 = User.create!(user_attributes(name: "Larry", email: "larry@example.com"))
    registration1.user = user1
    registration1.save!
    
    registration2 = event1.registrations.new(registration_attributes)
    user2 = User.create!(user_attributes(name: "Moe", email: "moe@example.com"))
    registration2.user = user2
    registration2.save!
    
    event2 = Event.create(event_attributes(name: "Code Kata"))
    registration3 = event2.registrations.new(registration_attributes)
    user3 = User.create!(user_attributes(name: "Curly", email: "curly@example.com"))
    registration3.user = user3
    registration3.save!
    
    visit event_registrations_url(event1)
        
    expect(page).to have_text(user1.name)
    expect(page).to have_text(user2.name)
    expect(page).not_to have_text(user3.name)
  end
end
