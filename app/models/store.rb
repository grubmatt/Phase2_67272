class Store < ActiveRecord::Base
   # create a callback that will strip non-digits before saving to db
  before_save :reformat_phone

  # Relationships
  # -----------------------------
  has_many :assignment
  has_many :employee, through: :assignment

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
  # make sure required fields are present
  validates_presence_of :name, :street, :zip
  # State must be PA, OH, or WV
  validates_inclusion_of :state, in: %w[PA OH WV], message: "is not an option", allow_blank: true
  # Unique Store name
  validates_uniqueness_of :name

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
