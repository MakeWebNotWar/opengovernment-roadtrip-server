class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::Attributes::Dynamic
  
  field :name, type: String, default: "Untitled Event"
  field :description, type: String, default: "No Description."
  field :url, type: String, default: nil
  field :start_date, type: DateTime, default: Time.now
  field :end_date, type: DateTime, default: Time.now + 1.hour
  field :type, type: String

  belongs_to :location
  has_many :comments
  accepts_nested_attributes_for :location, inverse_of: nil
  belongs_to :user

  default_scope gt(start_date: Time.now).asc
end