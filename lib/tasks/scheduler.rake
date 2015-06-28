desc "Remove demo users that have not chosen to sign up within 24 hours."
task :remove_expired_demo_users => :environment do
  puts "Scheduled Task: Attempting to remove demo users that have not signed up within 24 hours after trying the service."
  User.where("guest = ? AND created_at < ?", true, 24.hours.ago).delete_all
  puts "Scheduled Task: Removed all demo users created prior to 24 hours ago."
end
