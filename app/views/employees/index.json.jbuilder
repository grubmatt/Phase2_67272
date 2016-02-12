json.array!(@employees) do |employee|
  json.extract! employee, :id, :first_name, :last_name, :ssn, :date_of_birth, :phone, :role, :active
  json.url employee_url(employee, format: :json)
end
