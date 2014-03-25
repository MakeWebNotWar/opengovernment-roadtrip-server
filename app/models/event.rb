class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::Attributes::Dynamic
  
  field :name, type: String, default: "Untitled Event"
  field :description, type: String, default: "No Description."
  field :url, type: String, default: nil
  field :start_date, type: DateTime, default: Time.now
  field :end_date, type: DateTime, default: Time.now + 1.hour


  belongs_to :location
  has_and_belongs_to_many :datasets

  accepts_nested_attributes_for :location, inverse_of: nil


end