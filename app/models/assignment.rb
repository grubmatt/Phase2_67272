class Assignment < ActiveRecord::Base
  # Relationships
  # -----------------------------
  belongs_to :employee
  belongs_to :store

  # Scopes
  # -----------------------------
  # Gets current assignments
  scope :current, -> { where("active = true") }
  # Returns all assignments for a given store
  scope :for_store, ->(store_id) { where("store_id = ?", store_id) }
  # Returns al assignments for a given employee
  scope :for_employee, ->(employee_id) { where("employee_id = ?", employee_id) }
  # Return all asinments for a given pay level
  scope :for_pay_level, ->(pay_level) { where("pay_level = ?", pay_level) }
  # Return all values ordered by pay level
  scope :by_pay_level, -> { order('pay_level ASC') }
  # Return all values ordered by store
  scope :by_store, -> { order('store_id ASC') }

  # Validations
  # -----------------------------
  # make sure required fields are present
  validates_presence_of :store_id, :employee_id, :start_date, :pay_level


end
