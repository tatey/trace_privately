json.status "OK"
json.date @updated_at.to_s(:iso8601)
json.keys @positively_infected_keys.pluck(:data)
json.deleted_keys @negatively_infected_keys.pluck(:data)
