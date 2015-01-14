namespace :scraper do
  desc "TODO"
  task scrape: :environment do
    require 'open-uri'
    require 'json'
  
    auth_token = "a23f2c2436dfcac948390a3c5b5d4b33"
    polling_url = "http://polling.3taps.com/poll"
  
    params = {
      auth_token: auth_token,
      anchor: 1718409122,
      source: "CRAIG",
      category_group: "RRRR",
      category: "RHFR",
      'location.state' => "USA-IL",
      retvals: "location,external_url,heading,body,timestamp,price,images,annotations"
    }
   
    uri = URI.parse(polling_url)
    uri.query = URI.encode_www_form(params)
 
    result = JSON.parse(open(uri).read)
 
    #puts JSON.pretty_generate result["postings"].first["heading"]
    
    result["postings"].each do |posting|
      @post = Post.new
      @post.heading = posting["heading"]
      @post.body = posting["body"]
      @post.price = posting["price"]
      @post.neighborhood = posting["location"]["locality"]
      @post.external_url = posting["external_url"]
      @post.timestamp = posting["timestamp"]
      
      @post.save
    end
    
  end

  desc "TODO"
  task destroy_all_posts: :environment do
  end

end
