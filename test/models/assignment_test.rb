require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  # Relationship macros
   should belong_to(:stores)
   should belong_to(:employees)

   # Validation macros
end
