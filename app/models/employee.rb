class Employee < ActiveRecord::Base
  # create a callback that will strip non-digits before saving to db
  before_save :reformat_phone, :reformat_ssn


  # Relationships
  # -----------------------------
  has_many :assignments
  has_many :stores, through: :assignments

  # Scopes
  # -----------------------------
  # Returns employees under 18
  scope :younger_than_18, -> { where("date_of_birth > ?", 18.years.ago) }
  # Returns employees older then 18
  scope :is_18_or_older, -> { where("date_of_birth <= ?", 18.years.ago) }
  # Returns active employess
  scope :active, -> { where(active: true) }
  # Returns inactive employees
  scope :inactive, -> { where(active: false) }
  # Returns employees with the role employee
  scope :regulars, -> { where("role = ?", 'employee') }
  # Returns employees with the role manager
  scope :managers, -> { where("role = ?", 'manager') }
  # Returns employees with the role admin
  scope :admins, -> { where("role = ?", 'admin') }
  # Orders results alphabetically
  scope :alphabetical, -> { order("name") }

  #Validations
  # -----------------------------
  validates_presence_of :first_name, :last_name, :date_of_birth, :role, :ssn
  validates_format_of :phone, with: /\A(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})\z/, message: "should be 10 digits (area code needed) and delimited with dashes only"
  validates_format_of :ssn, with: /\A(\d{9}|\(?\d{3}\)?[-. ]\d{2}[-.]\d{4})\z/, message: "should be 9 digits and delimited with dashes only"

  # Methods
  def name
    last_name + ", " + first_name
  end

  def proper_name
    first_name + " " + last_name
  end

  def current_assignment
    self.assignments.current.first
  end

  def over_18?
    date_of_birth <= 18.years.ago
  end

  def age
    Date.today.year - date_of_birth.year
  end


  private
  # Callback code
  # We need to strip non-digits before saving to db
  def reformat_phone
    phone = self.phone.to_s  # change to string in case input as all numbers 
    phone.gsub!(/[^0-9]/,"") # strip all non-digits
    self.phone = phone       # reset self.phone to new string
  end
  # We need to strip non-digits before saving to db
  def reformat_ssn
    ssn = self.ssn.to_s      # change to string in case input as all numbers 
    ssn.gsub!(/[^0-9]/,"")   # strip all non-digits
    self.ssn = ssn           # reset self.ssn to new string
  end
end
