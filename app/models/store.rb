class Store < ActiveRecord::Base
  # Relationships
  # -----------------------------
  has_many :assignment

  # Scopes
  # -----------------------------
  # Returns active stores
  scope :active, -> { where("active = true") }
  # Returns inactive stores
  scope :inactive, -> { where("active = false") }
  # Orders results alphabetically
  scope :alphabetical, -> { order("name ASC") }

  # Validations
  # -----------------------------
  # make sure required fields are present
  validates_presence_of :name, :street, :zip
  # State must be PA, OH, or WV
  validates_inclusion_of :state, in: %w[PA OH WV], message: "is not an option", allow_blank: true

end
