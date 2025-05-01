# abstract base product class
class Product
    # class variables for unique product IDs
    @@nextID = 1 # @@ indicates a class variable
  
    # getters and setters
    attr_reader :productID 
    attr_accessor :productName, :price, :reviewRate, :sentPoint
  
    # class method to create a new unique product ID
    def initialize(prodName = "", price = 0.0)
      @productID = Product.createNewID 
      @productName = prodName.empty? ? "no name product!" : prodName
      @price = setPrice(price)
      @reviewRate = 0.0
      @sentPoint = 0.0 # added sentPoint from socialSent 
    end
  
    # class method to set price 
    def setPrice(price)
      if price > 0.0 && price < 1000.00
        price
      else
        0.0
      end
    end
  
    # class method to set product ID
    def setProductID(id)
      @productID = id
    end
  
    # class method to get product ID
    def self.createNewID
      id = @@nextID 
      @@nextID += 1 # increment for the next product
      id
    end
  
    # abstract method to get product type string
    def getProdTypeStr
      raise NotImplementedError, "#{self.class} must implement getProdTypeStr method"
    end
  
    # abstract method to display contents info
    def displayContentsInfo
      raise NotImplementedError, "#{self.class} must implement displayContentsInfo method"
    end
  
    # abstract method to display product info
    def displayProdInfo 
      puts "[#{getProdTypeStr}]" 
      puts "product ID:".ljust(20) + @productID.to_s.ljust(10)
      puts "product name:".ljust(20) + @productName.to_s.ljust(10)
      puts "price:".ljust(20) + ('$%.2f' % @price).to_s.ljust(10)
      puts "review rate:".ljust(20) + ('%.2f' % @reviewRate).to_s.ljust(10)
      puts "sentiment:".ljust(20) + ('%.2f' % @sentPoint).to_s.ljust(10)
      displayContentsInfo
      puts "----------------------------------------"
      puts
    end
  
    # printing in string representation
    def to_s 
      "[#{getProdTypeStr}]\n" + 
      "product ID:".ljust(20) + @productID.to_s.ljust(10) + "\n" + 
      "product name:".ljust(20) + @productName.to_s.ljust(10) + "\n" + 
      "price:".ljust(20) + @price.to_s.ljust(10) + "\n" + 
      "review rating:".ljust(20) + @reviewRate.to_s.ljust(10) + "\n" + 
      "sentiment:".ljust(20) + @sentPoint.to_s.ljust(10) + "\n"
    end
  end