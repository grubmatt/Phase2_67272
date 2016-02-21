module Contexts

  def create_employees
  	@ty = FactoryGirl.create(:employee)
  	@terry = FactoryGirl.create(:employee, first_name: "Terry", date_of_birth: "1990-2-1", role:"manager")
  	@james = FactoryGirl.create(:employee, first_name: "James", active: false)
  	@alex = FactoryGirl.create(:employee, first_name: "Alex", last_name: "Heimann", role:"admin")
  end

  def create_stores
  	@cmu = FactoryGirl.create(:store, phone:"412-268-8211")
  	@pitt = FactoryGirl.create(:store, name: "PITT")
  	@mars = FactoryGirl.create(:store, name: "MARS TWP", active: false)
  end

  def create_assignments
  	@cmu_ty = FactoryGirl.create(:assignment)
    @cmu_ty2 = FactoryGirl.create(:assignment, start_date: "2016-1-5", pay_level: 2)
  	@pitt_alex = FactoryGirl.create(:assignment, start_date: "2014-1-5", employee_id: 4, store_id: 2)
 	  @pitt_terry = FactoryGirl.create(:assignment, start_date: "2015-10-9", employee_id: 2, store_id: 2)
  end

  def destroy_employees
  	@ty.destroy
  	@terry.destroy
  	@james.destroy
  	@alex.destroy
  end

  def destroy_stores
  	@cmu.destroy
  	@pitt.destroy
  	@mars.destroy
  end

  def destroy_assignments
  	@cmu_ty.destroy
  	@cmu_ty2.destroy
  	@mars_alex.destroy
  	@pitt_terry.destroy
  end

end