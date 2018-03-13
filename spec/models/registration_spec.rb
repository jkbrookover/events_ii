require 'rails_helper'

describe "A registration" do
    
  it "belongs to an event" do
    event = Event.create(event_attributes)
    
    registration = event.registrations.new(registration_attributes)
    registration.user = User.new(user_attributes)

    expect(registration.event).to eq(event)
  end
  
  it "with example attributes is valid" do
    registration = Registration.new(registration_attributes)
    registration.event = Event.create!(event_attributes)
    registration.user = User.create!(user_attributes)

    expect(registration.valid?).to eq(true)
  end
  
  it "accepts any how heard option that is in an approved list" do
    options = Registration::HOW_HEARD_OPTIONS
    options.each do |option|
      registration = Registration.new(how_heard: option)
      registration.valid?
      expect(registration.errors[:how_heard].any?).to eq(false)
    end
  end
  
  it "rejects any how heard option that is not in the approved list" do
    options = %w[foo bar baz]
    options.each do |option|
      registration = Registration.new(how_heard: option)
      registration.valid?
      expect(registration.errors[:how_heard].any?).to eq(true)
    end
  end
end
