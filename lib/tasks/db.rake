namespace :db do
  desc "Destroy all expired submissions and expired access grants."
  task prune: :environment do
    submissions = Submission.expired.destroy_all
    puts "Destroyed expired submissions: count=#{submissions.size}"

    access_grants = AccessGrant.expired.destroy_all
    puts "Destroyed expired access grants: count=#{access_grants.size}"
  end
end
