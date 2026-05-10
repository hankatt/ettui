desc "Remove demo users that have been inactive for 48 hours."
task :remove_expired_demo_users => :environment do
  puts "Scheduled Task: Attempting to remove demo users inactive for 48 hours."
  User.where(guest: true)
      .where("last_active_at < ? OR (last_active_at IS NULL AND created_at < ?)", 48.hours.ago, 48.hours.ago)
      .delete_all
  puts "Scheduled Task: Removed all inactive demo users."
end
