FactoryGirl.define do
  
  factory :employee do
    first_name "Tyler"
    last_name "Toboggan"
    date_of_birth 1994-01-23
    role "employee"
    ssn "023649320"
  end

  factory :assignment do
    store_id 1
    employee_id 1
    start_date 2015-07-15
    pay_level 2
  end

  factory :store do
  	name "UC CMU"
	street "340 Forbes Avenue"
	zip 15217 
  end

end
  