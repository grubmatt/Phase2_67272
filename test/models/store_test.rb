require 'test_helper'

class StoreTest < ActiveSupport::TestCase
  # Relationship macros
  should have_many(:assignments)
  should have_many(:employees).through(:assignments)

  # Validation macros
  should validate_presence_of(:name)
  should validate_presence_of(:street)
  should validate_presence_of(:zip)
  should validate_uniqueness_of(:name)

  # Validating state
  should allow_value("PA").for(:state)
  should allow_value("WV").for(:state)
  should allow_value("OH").for(:state)
  should_not allow_value("bad").for(:state)
  should_not allow_value(10).for(:state)
  should_not allow_value("CA").for(:state)

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

  context "Creating 3 stores"  do
  	setup do
  	  @cmu = FactoryGirl.create(:store, phone:"412-268-8211")
  	  @pitt = FactoryGirl.create(:store, name: "PITT")
  	  @mars = FactoryGirl.create(:store, name: "MARS TWP", active: false)
  	end

  	teardown do
  	  @cmu.destroy
  	  @pitt.destroy
  	  @mars.destroy
  	end

  	should "show that all factories are properly created" do
      assert_equal "CMU", @cmu.name
      assert_equal "PITT", @pitt.name
      assert_equal "MARS TWP", @mars.name
      assert @cmu.active
      assert @pitt.active
      assert !@mars.active
    end

    # test the scope 'alphabetical'
    should "shows that there are three stores in alphabetical order" do
      assert_equal ["CMU", "MARS TWP", "PITT"], Store.alphabetical.map{|o| o.name}
    end

    # test the scope 'active'
    should "shows that there are two active stores" do
      assert_equal 2, Store.active.size
      assert_equal ["CMU", "PITT"], Store.active.map{|o| o.name}.sort
    end

    # test the scope 'inactive'
    should "shows that there is one inactive stores" do
      assert_equal 1, Store.inactive.size
      assert_equal ["MARS TWP"], Store.inactive.map{|o| o.name}
    end

    # test the callback is working 'reformat_phone'
    should "shows that CMU's phone is stripped of non-digits" do
      assert_equal "4122688211", @cmu.phone
    end
  end


end
