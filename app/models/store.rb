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


end
