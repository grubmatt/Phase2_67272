require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase
   # Relationship macros
   should have_many(:assignments)
   should have_many(:stores).through(:assignments)

   # Validation macros
   should validate_presence_of(:first_name)
   should validate_presence_of(:last_name)
   should validate_presence_of(:date_of_birth)
   should validate_presence_of(:role)
   should validate_presence_of(:ssn)

   # Validating phone
   should allow_value("4122683259").for(:phone)
   should allow_value("412-268-3259").for(:phone)
   should allow_value("412.268.3259").for(:phone)
   should allow_value("(412) 268-3259").for(:phone)
  
   should_not allow_value("2683259").for(:phone)
   should_not allow_value("4122683259x224").for(:phone)
   should_not allow_value("800-EAT-FOOD").for(:phone)
   should_not allow_value("412/268/3259").for(:phone)
   should_not allow_value("412-2683-259").for(:phone)

   # Validating ssn
   should allow_value("091233320").for(:ssn)
   should allow_value("091-23-3330").for(:ssn)

   should_not allow_value("091-23-333s").for(:ssn)
   should_not allow_value("091/23/3330").for(:ssn)

   # Validating legal age
   should allow_value("2000-12-10").for(:date_of_birth)
   should allow_value("19991230").for(:date_of_birth)

   should_not allow_value("2010-12-4").for(:date_of_birth)
   should_not allow_value("2003-12-4").for(:date_of_birth)

   context "creating four employees" do
     setup do
       @ty = FactoryGirl.create(:employee)
       @terry = FactoryGirl.create(:employee, first_name: "Terry", date_of_birth: "1990-2-1", role:"manager")
       @james = FactoryGirl.create(:employee, first_name: "James", phone: "412-268-8211", active: false)
       @alex = FactoryGirl.create(:employee, first_name: "Alex", last_name: "Heimann", date_of_birth: "1994-12-10", role:"admin")
       @cmu = FactoryGirl.create(:store, phone:"412-268-8211")
       @cmu_ty = FactoryGirl.create(:assignment, start_date: "2016-1-5", pay_level: 2)
     end

     teardown do
       @ty.destroy
  	   @terry.destroy
  	   @james.destroy
  	   @alex.destroy
       @cmu.destroy
       @cmu_ty.destroy
     end

     should "show that the factories were created correctly " do
       assert_equal "Tyler", @ty.first_name
       assert_equal "Terry", @terry.first_name
       assert_equal "James", @james.first_name
       assert_equal "admin", @alex.role
       assert !@james.active
     end

     # Testing scope younger_than_18
     should "Return two employees under 18" do
       assert_equal ["James", "Tyler"], Employee.younger_than_18.map{|o| o.first_name}.sort
     end

     # Testing scope is_18_or_older
     should "Return two employees 18 or older" do
       assert_equal ["Alex", "Terry"], Employee.is_18_or_older.map{|o| o.first_name}.sort
     end

     # Testing scope active
    should "Return three active employees" do
      assert_equal ["Alex", "Terry", "Tyler"], Employee.active.map{|i| i.first_name}.sort
    end

    # Testing scope inactive
    should "Return one inactive employee" do
      assert_equal ["James"], Employee.inactive.map{|i| i.first_name}
    end

    # Testing scope regulars
    should "Return two employees with the role employees" do
      assert_equal ["James", "Tyler"], Employee.regulars.map{|i| i.first_name}.sort
    end

    # Testing scope managers
    should "Return one employees with the role manager" do
      assert_equal ["Terry"], Employee.managers.map{|i| i.first_name}
    end

    # Testing scope admins
    should "Return one employees with the role admin" do
      assert_equal ["Alex"], Employee.admins.map{|i| i.first_name}
    end

    # Testing scope alphabetical
    should "Return employees alphabetically by name" do
      assert_equal ["Alex", "James", "Terry", "Tyler"], Employee.alphabetical.map{|i| i.first_name}
    end

    # Testing method name
    should "shows that name method works" do
      assert_equal "Heimann, Alex", @alex.name
    end

    # Testing method proper_name
    should "shows that proper_name method works" do
      assert_equal "Alex Heimann", @alex.proper_name
    end

    # Testing method current_assignment
    should "show that current_assignment method works" do
      assert_equal 1, @ty.current_assignment.id
    end

    # Testing method over_18?
    should "show that over_18? works" do
      assert @terry.over_18?
    end

    # Testing method age
    should "show that age works" do
      assert_equal 26, @terry.age 
    end

    # test the callback is working 'reformat_phone'
    should "shows that jame's phone is stripped of non-digits" do
      assert_equal "4122688211", @james.phone
    end
   end
end
