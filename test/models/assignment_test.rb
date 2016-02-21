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

   context "Creating employees, stores, and assignments" do
        	
   end

end
