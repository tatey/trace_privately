json.status "OK"
json.date (@keys.first&.updated_at || Time.current).to_s(:iso8601)
json.keys @keys.pluck(:data)
