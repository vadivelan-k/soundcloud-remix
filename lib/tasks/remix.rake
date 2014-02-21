desc "Find Remixes"
task :cron => :environment do
 # To enable daily cron and pull tracks from soundcloud group, uncomment the line below. more here: http://addons.heroku.com/cron  
 # if Time.now.hour == 1 # run at midnight
      # dont forget to uncomment 'end' to close
  consumer_key = YAML.load_file(File.join(Rails.root, "config", "soundcloud_auth.yml"))[RAILS_ENV]["key"]
  
  last_track = Remix.last # last imported track
  
  @tracks = HTTParty.get("http://api.soundcloud.com/groups/#{SETTINGS["group_id"]}/tracks.json?consumer_key=#{consumer_key}")
  
  @tracks = @tracks.reverse if last_track.nil? # reverse on first import
  
  for track in @tracks
    
    if last_track
      
      break if track['id'].to_i == last_track['track_id'].to_i # break if we've made it to the last imported track
      
    end
    
    # create user if they don't exist
    
    user_info = HTTParty.get("http://api.soundcloud.com/users/#{track['user_id']}.json?consumer_key=#{consumer_key}")
    
    if user_info.code != "404"
    
      user = User.find_or_create_by_soundcloud_id(user_info['id'].to_s)
      user.assign_soundcloud_attributes(user_info)
      puts user.inspect
      user.save
    
      # create the remix
    
      remix = Remix.find_or_create_by_track_id(track['id'])
      remix.user_id = user.id
      remix.title = track['title']
      remix.file = "import"
      puts remix.inspect
      remix.save
    
    end
    
  end
 #end
end