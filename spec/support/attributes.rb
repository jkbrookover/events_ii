def event_attributes(overrides = {})
  random_number = (0..9).to_a.shuffle[0..10].join
  {
    name: "BugSmash #{random_number}", 
    location: "Denver",     
    price: 10.00,
    description: 'A fun evening of bug smashing!',
    starts_at: 10.days.from_now,
    image_file_name: 'bugsmash.png',
    capacity: 75
  }.merge(overrides)
end

def registration_attributes(overrides = {})
  {
    how_heard: "Twitter"     
  }.merge(overrides)
end

def user_attributes(overrides = {})
  {
    name: "Example User",
    email: "user@example.com",
    password: "secret",
    password_confirmation: "secret"
  }.merge(overrides)
end
