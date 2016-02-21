class Assignment < ActiveRecord::Base
  # create a callback that ends the previous assignment
  before_save :end_previous_assignment

  # Relationships
  belongs_to :employee
  belongs_to :store

  # Scopes
  # Gets current assignments
  scope :current, -> { where("end_date is null") }
  # Gets past assignments
  scope :past, -> { where("end_date is not null") }
  # Returns all assignments for a given store
  scope :for_store, ->(store_id) { where("store_id = ?", store_id) }
  # Returns al assignments for a given employee
  scope :for_employee, ->(employee_id) { where("employee_id = ?", employee_id) }
  # Return all assignments for a given pay level
  scope :for_pay_level, ->(pay_level) { where("pay_level = ?", pay_level) }
  # Return all assignments for a given role
  scope :for_role, ->(role) { joins(:employee).where("employees.role = ?", role) }
  # Return all values ordered by store
  scope :by_store, -> { joins(:store).order('stores.name') }
  # Return all values ordered by employee name
  scope :by_employee, -> { joins(:employee).order("employees.last_name, employees.first_name") }
  # Return assignments in chronological order
  scope :chronological, -> { order("start_date DESC") }
 
  # Validations
  validates_presence_of :store_id, :employee_id, :start_date, :pay_level
  validate :employee_store_are_active

  private
  # Callback Code
  def end_previous_assignment
    current_assignment = self.employee.current_assignment
    unless current_assignment == nil
      current_assignment.update(end_date: start_date)
    end
  end

  def employee_store_are_active
    all_employee_ids = Employee.active.all.map{|i| i.id}
    all_store_ids = Store.active.all.map{|i| i.id}
    unless all_employee_ids.include?(self.employee_id)
      errors.add(:assignment, "is not an active employee")
      return false
    end
    unless all_store_ids.include?(self.store_id)
      errors.add(:assignment, "is not an active store")
      return false
    end
    return true
  end
end
