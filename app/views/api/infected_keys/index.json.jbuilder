json.status "OK"
json.date @updated_at.to_s(:iso8601)
json.keys @positively_infected_keys.each do |key|
  json.d key.data
  json.r key.rolling_start_number
end
json.deleted_keys @negatively_infected_keys.each do |key|
  json.d key.data
  json.r key.rolling_start_number
end
