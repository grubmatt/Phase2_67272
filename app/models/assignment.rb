class Assignment < ActiveRecord::Base
  # Relationships
  # -----------------------------
  belongs_to :employee
  belongs_to :store

  # Scopes
  # -----------------------------
  # Gets current assignments
  scope :current, -> { where(active: true) }
  # Gets past assignments
  scope :past, -> { where(active: false) }
  # Returns all assignments for a given store
  scope :for_store, ->(store_id) { where("store_id = ?", store_id) }
  # Returns al assignments for a given employee
  scope :for_employee, ->(employee_id) { where("employee_id = ?", employee_id) }
  # Return all assignments for a given pay level
  scope :for_pay_level, ->(pay_level) { where("pay_level = ?", pay_level) }
  # Return all assignments for a given role
  scope :for_role, ->(role) { where("role = ?", role) }
  # Return all values ordered by store
  scope :by_store, -> { order('store_id') }
  # Return all values ordered by employee name
  scope :by_employee, -> { joins(:employee).order("employee.last_name, employee.first_name") }
  # Return assignments in chronological order
  scope :chronological, -> { order("start_date DSC") }
 

  # Validations
  # -----------------------------
  # make sure required fields are present
  validates_presence_of :store_id, :employee_id, :start_date, :pay_level


end
