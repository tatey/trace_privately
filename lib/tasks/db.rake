namespace :db do
  desc "Destroy all expired submissions and expired access grants."
  task prune: :environment do
    expired_at = 30.days.ago
    submissions = Submission.where("created_at <= ?", expired_at).destroy_all
    puts "Destroyed expired submissions: count=#{submissions.size} expired=#{expired_at.to_s(:iso8601)}"

    access_grants = AccessGrant.expired.destroy_all
    puts "Destroyed expired access grants: count=#{access_grants.size}"
  end
end
