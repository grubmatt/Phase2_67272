class Store < ActiveRecord::Base
   # create a callback that will strip non-digits before saving to db
  before_save :reformat_phone

  # Relationships
  # -----------------------------
  has_many :assignments
  has_many :employees, through: :assignments

  # Scopes
  # -----------------------------
  # Returns active stores
  scope :active, -> { where(active: true) }
  # Returns inactive stores
  scope :inactive, -> { where(active: false) }
  # Orders results alphabetically
  scope :alphabetical, -> { order("name") }

  # Validations
  # -----------------------------
  validates_presence_of :name, :street, :zip
  validates_uniqueness_of :name
  validates_inclusion_of :state, in: %w[PA OH WV], message: "is not an option", allow_blank: true
  validates_format_of :phone, with: /\A(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})\z/, message: "should be 10 digits (area code needed) and delimited with dashes only"
  validates_format_of :zip, with: /\A\d{5}\z/, message: "should be five digits long", allow_blank: true

  # Callback code
  # -----------------------------
   private
     # We need to strip non-digits before saving to db
     def reformat_phone
       phone = self.phone.to_s  # change to string in case input as all numbers 
       phone.gsub!(/[^0-9]/,"") # strip all non-digits
       self.phone = phone       # reset self.phone to new string
     end
end
