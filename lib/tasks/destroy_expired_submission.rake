desc "Destroy all submissions older than 30 days"
task destroy_expired_submissions: :environment do
  expired_at = 30.days.ago
  submissions = Submission.where("created_at <= ?", expired_at).destroy_all
  puts "Destroyed expired submissions: count=#{submissions.size} expired=#{expired_at.to_s(:iso8601)}"
end
