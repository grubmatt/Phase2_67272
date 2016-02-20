class Assignment < ActiveRecord::Base
  # create a callback that ends the previous assignment
  before_save :end_previous_assignment

  # Relationships
  # -----------------------------
  belongs_to :employees
  belongs_to :stores

  # Scopes
  # -----------------------------
  # Gets current assignments
  scope :current, -> { where("end_date = ?", nil) }
  # Gets past assignments
  scope :past, -> { where("end_date != ?", nil) }
  # Returns all assignments for a given store
  scope :for_store, ->(store_id) { where("store_id = ?", store_id) }
  # Returns al assignments for a given employee
  scope :for_employee, ->(employee_id) { where("employee_id = ?", employee_id) }
  # Return all assignments for a given pay level
  scope :for_pay_level, ->(pay_level) { where("pay_level = ?", pay_level) }
  # Return all assignments for a given role
  scope :for_role, ->(role) { where("role = ?", role) }
  # Return all values ordered by store
  scope :by_store, -> { joins(:store).order('store.name') }
  # Return all values ordered by employee name
  scope :by_employee, -> { joins(:employee).order("employee.last_name, employee.first_name") }
  # Return assignments in chronological order
  scope :chronological, -> { order("start_date DSC") }
 

  # Validations
  # -----------------------------
  # make sure required fields are present
  validates_presence_of :store_id, :employee_id, :start_date, :pay_level
  validate :employee_store_are_active

  # Callback Code
  def end_previous_assignment
    current_assignment = Assignment.for_employee(self.employee_id).current
    current_assignment.end_date = self.start_date
  end

  private
  def employee_store_are_active
    all_employee_ids = Employee.active.all.map{|i| i.id}
    all_store_ids = Store.active.all.map{|i| i.id}
    unless all_employee_ids.include?(self.employee_id)
      errors.add(:employee, "is not an active employee")
      return false
    end
    unless all_store_ids.include?(self.store_id)
      errors.add(:store, "is not an active store")
      return false
    end
    return true
  end
end
