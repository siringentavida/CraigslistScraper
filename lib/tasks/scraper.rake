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
 
    #puts JSON.pretty_generate result["postings"]
    
    result["postings"].each do |posting|
      @post = Post.new
      @post.heading = posting["heading"]
      @post.body = posting["body"]
      @post.price = posting["price"]
      @post.neighborhood = posting["location"]["locality"]
      @post.external_url = posting["external_url"]
      @post.timestamp = posting["timestamp"]
      @post.bedrooms = posting["annotations"]["bedrooms"] if posting["annotations"]["bedrooms"].present?
      @post.bathrooms = posting["annotations"]["bathrooms"] if posting["annotations"]["bathrooms"].present?
      @post.sqft = posting["annotations"]["sqft"] if posting["annotations"]["sqft"].present?
      @post.cats = posting["annotations"]["cats"] if posting["annotations"]["cats"].present?
      @post.dogs = posting["annotations"]["dogs"] if posting["annotations"]["dogs"].present?
      @post.w_d_in_unit = posting["annotations"]["w_d_in_unit"] if posting["annotations"]["w_d_in_unit"].present?
      @post.street_parking = posting["annotations"]["street_parking"] if posting["annotations"]["street_parking"].present?
      
      @post.save
    end
    
  end

  desc "Destroy all posting data"
  task destroy_all_posts: :environment do
    Post.destroy_all
  end

end
