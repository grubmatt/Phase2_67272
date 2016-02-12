json.array!(@assignments) do |assignment|
  json.extract! assignment, :id, :store_id, :employee_id, :start_date, :end_date, :pay_level
  json.url assignment_url(assignment, format: :json)
end
