require 'rails_helper'

describe "An event" do
  it "is free if the price is $0" do
    event = Event.new(price: 0)
    
    expect(event).to be_free
  end
  
  it "is not free if the price is non-$0" do
    event = Event.new(price: 10)
    
    expect(event).not_to be_free    
  end
  
  it "requires a name" do
    event = Event.new(name: "")
    
    event.valid? # populates errors
    
    expect(event.errors[:name].any?).to eq(true)
  end
  
  it "requires a description" do
    event = Event.new(description: "")
    
    event.valid?
    
    expect(event.errors[:description].any?).to eq(true)
  end
  
  it "requires a location" do
    event = Event.new(location: "")
    
    event.valid?

    expect(event.errors[:location].any?).to eq(true)
  end
  
  it "requires a description over 24 characters" do
    event = Event.new(description: "X" * 24)
    
    event.valid?

    expect(event.errors[:description].any?).to eq(true)
  end
  
  it "accepts a $0 price" do
    event = Event.new(price: 0.00)

    event.valid?

    expect(event.errors[:price].any?).to eq(false)
  end
  
  it "accepts a positive price" do
    event = Event.new(price: 10.00)

    event.valid?

    expect(event.errors[:price].any?).to eq(false)
  end
  
  it "rejects a negative price" do
    event = Event.new(price: -10.00)

    event.valid?

    expect(event.errors[:price].any?).to eq(true)
  end
  
  it "rejects a 0 capacity" do
    event = Event.new(capacity: 0)

    event.valid?

    expect(event.errors[:capacity].any?).to eq(true)
  end
  
  it "accepts a positive capacity" do
    event = Event.new(capacity: 5)

    event.valid?

    expect(event.errors[:capacity].any?).to eq(false)
  end
  
  it "rejects a negative capacity" do
    event = Event.new(capacity: -5)

    event.valid?

    expect(event.errors[:capacity].any?).to eq(true)
  end
  
  it "rejects a non-integer capacity" do
    event = Event.new(capacity: 3.14159)

    event.valid?

    expect(event.errors[:capacity].any?).to eq(true)
  end
  
  it "accepts properly formatted image file names" do
    file_names = %w[e.png event.png event.jpg event.gif EVENT.GIF]
    file_names.each do |file_name|
      event = Event.new(image_file_name: file_name)
      event.valid?
      expect(event.errors[:image_file_name].any?).to eq(false)
    end
  end
  
  it "reject improperly formatted image file names" do
    file_names = %w[event .jpg .png .gif event.pdf event.doc]
    file_names.each do |file_name|
      event = Event.new(image_file_name: file_name)
      event.valid?
      expect(event.errors[:image_file_name].any?).to eq(true)
    end
  end
  
  it "with example attributes is valid" do
    event = Event.new(event_attributes)
    
    expect(event.valid?).to eq(true)
  end

  it "has many reviews" do
    event = Event.new(event_attributes)
    
    registration1 = event.registrations.new(registration_attributes)
    registration2 = event.registrations.new(registration_attributes)
        
    expect(event.registrations).to include(registration1)
    expect(event.registrations).to include(registration2)
  end
  
  it "deletes associated reviews" do
    event = Event.create!(event_attributes)
    
    registration = event.registrations.new(registration_attributes)
    registration.user = User.create!(user_attributes)
    registration.save!

    expect { 
      event.destroy
    }.to change(Registration, :count).by(-1)
  end

  it "is sold out if no spots are left" do
    event = Event.new(event_attributes(capacity: 0))

    expect(event.sold_out?).to eq(true)
  end
  
  it "is not sold out if spots are available" do
    event = Event.new(event_attributes(capacity: 10))

    expect(event.sold_out?).to eq(false)
  end
  
  it "decrements spots left when a registration is created" do
    event = Event.create(event_attributes)
    
    event.registrations.create(registration_attributes)
    
    expect { 
      event.registrations.create(registration_attributes)
    }.to change(event, :spots_left).by(-1)
  end  

  context "upcoming query" do
    it "returns the events with a starts at date in the future" do
      event = Event.create!(event_attributes(starts_at: 3.months.from_now))

      expect(Event.upcoming).to include(event)
    end

    it "does not return events with a starts at date in the past" do
      event = Event.create!(event_attributes(starts_at: 3.months.ago))

      expect(Event.upcoming).not_to include(event)
    end

    it "returns upcoming events ordered with the soonest event first" do
      event1 = Event.create!(event_attributes(starts_at: 3.months.from_now))
      event2 = Event.create!(event_attributes(starts_at: 2.months.from_now))
      event3 = Event.create!(event_attributes(starts_at: 1.month.from_now))

      expect(Event.upcoming).to eq([event3, event2, event1])
    end
  end

  it "has likers" do
    event = Event.new(event_attributes)
    liker1 = User.new(user_attributes(email: "larry@example.com"))
    liker2 = User.new(user_attributes(email: "moe@example.com"))

    event.likes.new(user: liker1)
    event.likes.new(user: liker2)

    expect(event.likers).to include(liker1)
    expect(event.likers).to include(liker2)
  end

  context "past query" do
    it "returns the events with a starts at date in the past" do
      event = Event.create!(event_attributes(starts_at: 3.months.ago))

      expect(Event.past).to include(event)
    end

    it "does not return events with a starts at date in the future" do
      event = Event.create!(event_attributes(starts_at: 3.months.from_now))

      expect(Event.past).not_to include(event)
    end

    it "returns past events ordered with the soonest event first" do
      event1 = Event.create!(event_attributes(starts_at: 3.months.ago))
      event2 = Event.create!(event_attributes(starts_at: 2.months.ago))
      event3 = Event.create!(event_attributes(starts_at: 1.month.ago))

      expect(Event.past).to eq([event1, event2, event3])
    end
  end

  context "free query" do
    it "returns upcoming events with a $0 price" do
      event = Event.create!(event_attributes(starts_at: 3.months.from_now, price: 0))

      expect(Event.free).to include(event)
    end
    
    it "does not return upcoming events with a non-$0 price" do
      event = Event.create!(event_attributes(starts_at: 3.months.from_now, price: 10))

      expect(Event.free).not_to include(event)
    end
    
    it "does not return past events with a $0 price" do
      event = Event.create!(event_attributes(starts_at: 1.month.ago, price: 0))

      expect(Event.free).not_to include(event)
    end
  end

  context "recent query" do
    before do
      @event1 = Event.create!(event_attributes(starts_at: 3.months.ago))
      @event2 = Event.create!(event_attributes(starts_at: 2.months.ago))
      @event3 = Event.create!(event_attributes(starts_at: 1.month.ago))
      @event4 = Event.create!(event_attributes(starts_at: 1.week.ago))
      @event5 = Event.create!(event_attributes(starts_at: 3.months.from_now))
    end

    it "returns a specified number of past events ordered with the most recent event first" do
      expect(Event.recent(2)).to eq([@event1, @event2])
    end

    it "returns a default of 3 past events ordered with the most recent event first" do
      expect(Event.recent).to eq([@event1, @event2, @event3])
    end
  end

end
