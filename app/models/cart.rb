# require_relative is used to include other ruby files
require_relative 'nameType'

# class for overflow and underflow exception
class CartOverflowException < StandardError; end
class CartUnderflowException < StandardError; end

# class for cart
class Cart
  MAX_ITEMS = 7 # maximum number of items in the cart

  # getters for owner, itemNum, purchasedItems
  attr_reader :owner, :itemNum, :purchasedItems, :removedItems

  # constructor to initialize owner, itemNum, and purchasedItems
  def initialize (owner = NameType.new)
    @owner = owner
    @itemNum = 0
    @purchasedItems = [] # array to store purchased items
    @removedItems = []   # array to store removed items
  end

  # operator overloading - add product to cart
  def +(product)
    addItem(product)
    self # return self to allow chaining of operations
  end

  # add item to cart
  def addItem(product)
    begin
      if isCartFull?
        raise CartOverflowException, "cart overflow! cannot add product to cart :(\n" + 
                                    "name: #{product.productName}\n" + 
                                    "prod ID: #{product.productID}\n" + 
                                    "max items: #{MAX_ITEMS}"
      end
        
      @purchasedItems << product # add product to purchased items
      @itemNum += 1 # increment item number
      return true # true if item is added successfully
    rescue CartOverflowException => e
      puts e.message # print error message
      return false
    end
  end

  # remove item from cart
  def removeItem(productID)
    begin 
      if @itemNum == 0 # check if cart is empty
        raise CartUnderflowException, "cart underflow! cannot remove product from cart :(\n" + 
                                     "prod ID: #{productID}\n" + 
                                     "max items: #{MAX_ITEMS}"
      end
      
      # find the item to be removed
      itemToRemove = @purchasedItems.find { |item| item.productID == productID }
      if itemToRemove
        # add to removed items list before removing
        @removedItems << itemToRemove
      end
        
      initialSize = @purchasedItems.size # store initial size of purchased items
      @purchasedItems.reject! { |item| item.productID == productID } # remove product from purchased items
    
      if @purchasedItems.size < initialSize # check if item was removed
        @itemNum = @purchasedItems.size # update item number
        return true # return true if item was removed successfully
      end
    
      return false # return false if item was not removed
    rescue CartUnderflowException => e
      puts e.message # print error message
      return false
    end 
  end

  # search for item in cart by name - renamed to match requirement
  def searchProduct(productName)
    @purchasedItems.find { |item| item.productName == productName } # find item by name
  end

  # display what is in the cart 
  def displayCart
    puts "              << my cart >> "
    puts "=========================================="
    puts "cart owner: #{@owner}"
    puts

    totalAmount = 0.0 # total amount of items in the cart

    @purchasedItems.each do |item| # iterate through purchased items    
      item.displayProdInfo # display item information
      totalAmount += item.price # add item price to total amount
    end

    # display removed items if any
    if !@removedItems.empty?
      puts "            << removed items >>"
      puts "==========================================="
      @removedItems.each do |item|
        puts "removed item:"
        puts "  product ID: #{item.productID}"
        puts "  name: #{item.productName}" 
        puts "  price: $#{'%.2f' % item.price}"
      end
      puts
    end

    puts "========== summary of purchase =========="
    puts "total number of items:".ljust(30) + @itemNum.to_s.ljust(10)
    puts "total purchase amount:".ljust(30) + ('$%.2f' % totalAmount).to_s.ljust(10)
    puts "average cost:".ljust(30) + ('$%.2f' % (totalAmount / @itemNum)).to_s.ljust(10) if @itemNum > 0
    
    # add removed items count to summary if any
    if !@removedItems.empty?
      puts "total removed items:".ljust(30) + @removedItems.size.to_s.ljust(10)
    end
    
    puts "========================================="
    puts
  end

  # save cart content to file with sentiment - renamed to match requirement
  def saveCart(fileName)
    begin 
      File.open(fileName, "w") do |file| # open file in write mode
        @purchasedItems.each do |item| # iterate through purchased items
          case item 
          when AudioProduct
            file.puts "audio,#{item.productName},#{item.price},#{item.singer},#{item.genre},#{item.reviewRate},#{item.sentPoint}"
          when VideoProduct
            file.puts "video,#{item.productName},#{item.price},#{item.director},#{item.releaseYear},#{item.runTime},#{item.filmRate},#{item.reviewRate},#{item.sentPoint}"
          when Ebook
            file.puts "ebook,#{item.productName},#{item.price},#{item.author},#{item.pages},#{item.reviewRate},#{item.sentPoint}"
          when PaperBook
            file.puts "paper book,#{item.productName},#{item.price},#{item.author},#{item.pages},#{item.reviewRate},#{item.sentPoint}"
          end
        end
        
        # also save removed items with a special marker
        @removedItems.each do |item| # iterate through removed items
          case item 
          when AudioProduct
            file.puts "removed,audio,#{item.productName},#{item.price},#{item.singer},#{item.genre},#{item.reviewRate},#{item.sentPoint}"
          when VideoProduct
            file.puts "removed,video,#{item.productName},#{item.price},#{item.director},#{item.releaseYear},#{item.runTime},#{item.filmRate},#{item.reviewRate},#{item.sentPoint}"
          when Ebook
            file.puts "removed,ebook,#{item.productName},#{item.price},#{item.author},#{item.pages},#{item.reviewRate},#{item.sentPoint}"
          when PaperBook
            file.puts "removed,paper book,#{item.productName},#{item.price},#{item.author},#{item.pages},#{item.reviewRate},#{item.sentPoint}"
          end
        end
      end
      return true # return true if saved successfully
    
    rescue => e
      puts "error saving cart: #{e.message}" # print error message
      return false # return false if cart not saved
    end
  end

  # read products from a file and add to cart with sentiment
  def readFromFile(fileName)
    begin
      File.open(fileName, "r") do |file| # open file in read mode
        file.each_line do |line|
          tokens = line.strip.split(",")
          
          # check if this is a removed item
          if tokens[0] == "removed"
            isRemoved = true
            tokens.shift
            productType = tokens[0]
          else
            isRemoved = false
            productType = tokens[0]
          end

          case productType
          when "audio"
            name = tokens[1]
            price = tokens[2].to_f
            singer = NameType.new(tokens[3], "")
            product = AudioProduct.new(name, price, singer)
            product.genre = tokens[4]
            product.reviewRate = tokens[5].to_f
            product.sentPoint = tokens[6].to_f if tokens.size > 6
            if isRemoved
              @removedItems << product
            else
              addItem(product) # add product to cart
            end
          when "video"
            name = tokens[1]
            price = tokens[2].to_f
            director = NameType.new(tokens[3], "")
            releaseYear = tokens[4].to_i
            runTime = tokens[5].to_i
            product = VideoProduct.new(name, price, director, releaseYear, runTime)
            product.filmRate = tokens[6]
            product.reviewRate = tokens[7].to_f
            product.sentPoint = tokens[8].to_f if tokens.size > 8
            if isRemoved
              @removedItems << product
            else
              addItem(product) # add product to cart
            end
          when "ebook"
            name = tokens[1]
            price = tokens[2].to_f
            author = NameType.new(tokens[3], "")
            pages = tokens[4].to_i
            product = Ebook.new(name, price, author, pages)
            product.reviewRate = tokens[5].to_f
            product.sentPoint = tokens[6].to_f if tokens.size > 6
            if isRemoved
              @removedItems << product
            else
              addItem(product) # add product to cart
            end
          when "paper book"
            name = tokens[1]
            price = tokens[2].to_f
            author = NameType.new(tokens[3], "")
            pages = tokens[4].to_i
            product = PaperBook.new(name, price, author, pages)
            product.reviewRate = tokens[5].to_f
            product.sentPoint = tokens[6].to_f if tokens.size > 6
            if isRemoved
              @removedItems << product
            else
              addItem(product) # add product to cart
            end
          end
        end
      end
      return true 

    rescue => e 
      puts "error reading file: #{e.message}" # print error message
      return false
    end
  end

  # printing using string 
  def to_s
    result = "cart owner: #{@owner}\n"
    result += "total number of items: #{@itemNum}\n"

    totalAmount = 0.0

    @purchasedItems.each do |item| # iterate through purchased items
      result += item.to_s + "\n" 
      totalAmount += item.price
    end

    result += "total purchase amount:".ljust(30) + ('$%.2f' % totalAmount).to_s.ljust(10) + "\n"
    result += "average cost:".ljust(30) + ('$%.2f' % (totalAmount / @itemNum)).to_s.ljust(10) + "\n" if @itemNum > 0
    
    # add removed items count if any
    if !@removedItems.empty?
      result += "total removed items:".ljust(30) + @removedItems.size.to_s.ljust(10) + "\n"
    end
    
    result 
  end

  private
  # private method to check if cart is full
  def isCartFull?
    @itemNum >= MAX_ITEMS # check if cart is full
  end
end