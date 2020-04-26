Rack::Attack.throttle("Noisy requests for access grants", limit: 3, period: 15.minute) do |request|
  request.ip if request.path == "/api/auth" && request.post?
end

Rack::Attack.throttle("Noisy API clients", limit: 10, period: 1.minute) do |request|
  request.ip if request.path.starts_with?("/api")
end

Rack::Attack.throttle("Noisy web clients", limit: 30, period: 1.minute) do |request|
  request.ip if request.path == "/" || request.path.starts_with?("/admin")
end
