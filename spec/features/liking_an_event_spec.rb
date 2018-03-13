require 'rails_helper'

describe "Liking an event" do
  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end
  
  it "creates a like for the signed-in user and shows the Unlike button" do
    event = Event.create!(event_attributes)

    visit event_url(event)

    expect(page).to have_text("0 likes")

    expect {
      click_button 'Like'
    }.to change(@user.likes, :count).by(1)
    
    expect(current_path).to eq(event_path(event))

    expect(page).to have_text("Glad you liked it!")
    expect(page).to have_text("1 like")
    expect(page).to have_button("Unlike")
  end
  
end
