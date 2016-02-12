class Employee < ActiveRecord::Base
  # Relationships
  # -----------------------------
  has_many :assignment

  # Scopes
  # -----------------------------
  # Returns employees under 18
  scope :younger_than_18, -> { where("date_of_birth > ?", 18.years.ago) }
  # Returns employees older then 18
  scope :'18_or_older', -> { where("date_of_birth < ?", 18.years.ago) }
  # Returns active employess
  scope :active, -> { where("active = true") }
  # Returns inactive employees
  scope :inactive, -> { where("active = false") }
  # Returns employees with the role employee
  scope :regulars, -> { where("role = 'employee'") }
  # Returns employees with the role manager
  scope :managers, -> { where("role = 'manager'") }
  # Returns employees with the role admin
  scope :admins, -> { where("role = 'admin'") }
  # Orders results alphabetically
  scope :alphabetical, -> { order("name ASC") }

end
