# require_relative is used to include other ruby files
require_relative 'app/models/product'
require_relative 'app/models/nameType'
require_relative 'app/models/cart'
require_relative 'app/models/audioProduct'
require_relative 'app/models/videoProduct'
require_relative 'app/models/bookProduct'
require_relative 'app/models/ebook'
require_relative 'app/models/paperBook'
require_relative 'app/models/enums/genreType'
require_relative 'app/models/enums/filmRateType'

# load the sentiment dictionary
def build_social_sentiment_table
  sentiment_table = {}
  begin
    File.open("socialsent.csv", "r") do |file|
      file.gets # skip header line
      file.each_line do |line|
        sentiment = line.strip.split(',')
        if sentiment.length >= 2
          word = sentiment[0].strip
          value_str = sentiment[1].strip
          
          next if word.empty? || value_str.empty?
          
          begin
            sentiment_val = Float(value_str)
            sentiment_table[word] = sentiment_val
          rescue ArgumentError => e
            puts "error parsing value for #{word}: #{e}"
          end
        end
      end
    end
  rescue Errno::ENOENT => e
    puts "warning: socialsent.csv not found. sentiment analysis disabled."
  end
  sentiment_table
end

# create sentiment table
sentiment_table = build_social_sentiment_table

# create audio products
beetles = NameType.new("beetles", "")
music1 = AudioProduct.new("yesterday", 16.5, beetles) # create an audio product with name "yesterday" and price 16.5
music1.genre = GenreType::Pop
music1.reviewRate = 9.8
music1.sentPoint = 0.75 # sample sentiment

michael = NameType.new("michael", "jackson")
music2 = AudioProduct.new("we are the world", 13.75, michael)
music2.genre = GenreType::Country
music2.reviewRate = 9.1
music2.sentPoint = 0.85 # sample sentiment

keshi = NameType.new("keshi", "")
music3 = AudioProduct.new("more", 15.50, keshi)
music3.genre = GenreType::RnB
music3.reviewRate = 9.3
music3.sentPoint = 0.7 # sample sentiment

# create video products
wise = NameType.new("robert", "wise")
video1 = VideoProduct.new("sound of music", 22.0, wise, 1965, 175)
video1.filmRate = FilmRateType::G
video1.reviewRate = 9.2
video1.sentPoint = 0.65 # sample sentiment

lucas = NameType.new("george", "lucas")
video2 = VideoProduct.new("star wars", 22.0, lucas, 1977, 120)
video2.filmRate = FilmRateType::PG
video2.reviewRate = 8.5
video2.sentPoint = 0.9 # sample sentiment

# create book products
hemingway = NameType.new("ernest", "hemingway")
book1 = Ebook.new("the old man and the sea", 8.30, hemingway, 127)
book1.reviewRate = 9.5
book1.sentPoint = 0.4 # sample sentiment

collins = NameType.new("suzanne", "collins")
book2 = PaperBook.new("the hunger games", 10.99, collins, 374)
book2.reviewRate = 9.7
book2.sentPoint = 0.6 # sample sentiment

# extra items
miyazaki = NameType.new("hayao", "miyazaki")
video3 = VideoProduct.new("ponyo", 20.0, miyazaki, 2008, 101)
video3.filmRate = FilmRateType::G
video3.reviewRate = 9.8
video3.sentPoint = 0.95 # sample sentiment

lisa = NameType.new("lisa", "cho")
myCart = Cart.new(lisa)

# add products to the cart
myCart.addItem(music1)
myCart.addItem(music2)
myCart.addItem(video1)
myCart.addItem(video2)
myCart.addItem(book1)
myCart.addItem(book2)
myCart.addItem(video3) # this will not be added since the cart is full
myCart.addItem(music3) # this will not be added since the cart is full

# display the original cart
puts "           << original cart >>"
puts "******************************************"
myCart.displayCart
puts

# save cart to a file
if myCart.saveCart("cartProducts.txt")
  puts "successfully saved cart!"
else
  puts "error: failed to save cart "
end
puts

# create new cart and load from a file
newCart = Cart.new(lisa)
if newCart.readFromFile("cartProducts.txt")
  puts "successfully loaded cart!"
  puts
else
  puts "error: failed to load cart"
end
puts

# search for products and remove them using searchProduct
puts "products to remove"
productToRemove1 = newCart.searchProduct("we are the world")
if productToRemove1
  puts "found product: #{productToRemove1.productName}"
  if newCart.removeItem(productToRemove1.productID)
    puts "removed product: #{productToRemove1.productName}"
  end
else
  puts "product not found"
end

productToRemove2 = newCart.searchProduct("the old man and the sea")
if productToRemove2
  puts "found product: #{productToRemove2.productName}"
  if newCart.removeItem(productToRemove2.productID)
    puts "removed product: #{productToRemove2.productName}"
    puts
  end
else
  puts "product not found"
end
puts

# display the final cart after removals
puts "            << final cart >>"
puts "******************************************"
newCart.displayCart
puts

# testing underflow exception
puts "        <<cartUnderflowException:"
puts "=========================================="

# create an empty cart
emptyCart = Cart.new(lisa)

# try to remove an item from the empty cart
puts "attempting to remove an item from an empty cart"
puts
emptyCart.removeItem(1)