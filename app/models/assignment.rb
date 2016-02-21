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
  scope :chronological, -> { order("start_date, end_date") }
 
  # Validations
  validates_presence_of :store_id, :employee_id, :start_date, :pay_level
  validates :pay_level, :numericality => { :greater_than => 0, :less_than => 6}
  validate :employee_is_active
  validate :store_is_active

  private
  # Callback Code
  def end_previous_assignment
    current_assignment = self.employee.current_assignment
    if current_assignment and current_assignment.id != id
      current_assignment.update_attribute(:end_date, self.start_date)
      current_assignment.save!
    end
  end

  def employee_is_active
    all_employee_ids = Employee.active.all.map{|i| i.id}
    unless all_employee_ids.include?(self.employee_id)
      errors.add(:assignment, "is not an active employee")
      return false
    end
    return true
  end
  def store_is_active
    all_store_ids = Store.active.all.map{|i| i.id}
    unless all_store_ids.include?(self.store_id)
      errors.add(:assignment, "is not an active store")
      return false
    end
    return true
  end
end
