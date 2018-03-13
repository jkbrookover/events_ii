require 'rails_helper'

describe "Deleting a user" do 
    
  it "destroys the user and redirects to the home page" do
    user1 = User.create!(user_attributes)
    
    sign_in(user1)
    
    visit user_path(user1)
    
    click_link 'Delete Account'
        
    expect(current_path).to eq(root_path)
    expect(page).to have_text('Account successfully deleted!')
    
    user2 = User.create!(user_attributes(name: "Other User"))
    
    sign_in(user2)
    
    visit users_path
    
    expect(page).not_to have_text(user1.name)
  end
  
  it "automatically signs out that user" do
    user = User.create!(user_attributes)
    
    sign_in(user)
    
    visit user_path(user)
    
    click_link 'Delete Account'
        
    expect(page).to have_link('Sign In')
    expect(page).not_to have_link('Sign Out')
  end
end
