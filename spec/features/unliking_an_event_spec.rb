require 'rails_helper'

describe "Unliking an event" do
  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end
  
  it "deletes the like and shows the Like button" do
    event = Event.create!(event_attributes)

    visit event_url(event)
    click_button 'Like'

    expect(page).to have_text("1 like")

    expect {
      click_button 'Unlike'
    }.to change(@user.likes, :count).by(-1)
    
    expect(current_path).to eq(event_path(event))

    expect(page).to have_text("Sorry you unliked it!")
    expect(page).to have_text("0 likes")
    expect(page).to have_button("Like")
  end
  
end
