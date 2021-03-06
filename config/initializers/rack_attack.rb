Rack::Attack.throttle("Noisy requests for access grants", limit: 3, period: 15.minute) do |request|
  anonymize(request.ip) if request.path == "/api/auth" && request.post?
end

Rack::Attack.throttle("Noisy API clients", limit: 10, period: 1.minute) do |request|
  anonymize(request.ip) if request.path.starts_with?("/api")
end

Rack::Attack.throttle("Noisy web clients", limit: 30, period: 1.minute) do |request|
  anonymize(request.ip) if request.path == "/" || request.path.starts_with?("/admin")
end

# Anonymize the client's IP by transforming it with a keyed hash function. This lets us discriminate
# against noisy clients without storing personal information from well behaved clients.
def anonymize(ip)
  IpAnonymizer.hash_ip(ip, key: Rails.application.secret_key_base)
end
