require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  # Relationship macros
   should belong_to(:store)
   should belong_to(:employee)

   # Validation macros
   should validate_presence_of(:store_id)
   should validate_presence_of(:employee_id)
   should validate_presence_of(:pay_level)
   should validate_presence_of(:start_date)

   # Validate pay_level
   should allow_value(1).for(:pay_level)
   should allow_value(3).for(:pay_level)
   should allow_value(5).for(:pay_level)

   should_not allow_value(0).for(:pay_level)
   should_not allow_value(6).for(:pay_level)
   should_not allow_value(7).for(:pay_level)

   context "Creating employees, stores, and assignments" do
     setup do
       @ty = FactoryGirl.create(:employee)
       @terry = FactoryGirl.create(:employee, first_name: "Terry", date_of_birth: "1990-2-1", role:"manager")
       @alex = FactoryGirl.create(:employee, first_name: "Alex", last_name: "Heimann", date_of_birth: "1994-12-10", role:"admin")
       @cmu = FactoryGirl.create(:store, phone:"412-268-8211")
       @pitt = FactoryGirl.create(:store, name: "PITT")
       @mars = FactoryGirl.create(:store, name: "MARS TWP", active: false)
       @cmu_ty = FactoryGirl.create(:assignment)
       @cmu_ty2 = FactoryGirl.create(:assignment, start_date: "2016-1-5", pay_level: 2)
       @pitt_alex = FactoryGirl.create(:assignment, start_date: "2014-1-5", employee_id: 3, store_id: 2, pay_level: 5)
       @pitt_terry = FactoryGirl.create(:assignment, start_date: "2015-10-9", employee_id: 2, store_id: 2, pay_level: 3)
     end

     teardown do
       @ty.destroy
       @terry.destroy
       @alex.destroy
       @cmu.destroy
       @pitt.destroy
       @mars.destroy
       @cmu_ty.destroy
       @cmu_ty2.destroy
       @pitt_alex.destroy
       @pitt_terry.destroy
     end

     should "show that the factories were created correctly " do
       assert_equal "Tyler", @ty.first_name
       assert_equal "Terry", @terry.first_name
       assert_equal "admin", @alex.role
       assert_equal "CMU", @cmu.name
       assert_equal "PITT", @pitt.name
       assert_equal "MARS TWP", @mars.name
       assert_equal 1, @cmu_ty.pay_level
       assert_equal 2, @cmu_ty2.pay_level
       assert_equal 3, @pitt_alex.employee_id
       assert_equal 2, @pitt_terry.employee_id
       assert @cmu.active
       assert @pitt.active
       assert !@mars.active
     end

     # Testing scope current
     should "return all the current assignments" do
       assert_equal [2, 3, 5], Assignment.current.map{|i| i.pay_level}.sort
     end

     # Testing scope past
     should "return all the past assignments" do
       assert_equal [1], Assignment.past.map{|i| i.pay_level}.sort
     end

     # Testing scope for_store
     should "return all assignments for a store" do
       assert_equal [2, 3], Assignment.for_store(2).map{|i| i.employee_id}.sort
     end

     # Testing scope for_employee
     should "return all assignments for an employee" do
       assert_equal [2], Assignment.for_employee(2).map{|i| i.store_id}.sort
     end

     # Testing scope for_pay_level
     should "return all assignments for a pay_level" do
       assert_equal [2], Assignment.for_pay_level(3).map{|i| i.store_id}
     end

     # Testing scope for_role
     should "return all assignments for a role" do
       assert_equal [5], Assignment.for_role("admin").map{|i| i.pay_level}.sort
     end

     # Testing scope by_store
     should "return all assignments in order of store name" do
       assert_equal [1, 1, 2, 2], Assignment.by_store.map{|i| i.store_id}
     end

     # Testing scope by_employee
     should "return all assignments in order of employee names" do
       assert_equal [3, 2, 1, 1], Assignment.by_employee.map{|i| i.employee_id}
     end

     # Testing scope chronological
     should "return assignments chronologically" do
       assert_equal [3, 1, 4, 2], Assignment.chronological.map{|i| i.id}
     end

     # Testing end_previous_assignment
     should "ensure the previous assignment is ended correctly" do
       assert_equal ["2016-1-5"], @cmu_ty.end_date
     end
   end

end
