# require_relative is used to include other Ruby files
require_relative 'product'
require_relative 'nameType'

class BookProduct < Product
    attr_accessor :author, :pages # setter 

    # constructor to initialize product name, price, and singer
    def initialize(prodName = "", price = 0.0, author = NameType.new, pages = 0)
        super(prodName, price) # call superclass constructor
        @author = author
        @pages = pages
    end

    # product type return "Music"
    def getProdTypeStr
        raise NotImplementedError, "#{self.class} must implement getProdTypeStr method"
    end

    def displayContentsInfo
        puts "author:".ljust(20) + @author.to_s.ljust(10)
        puts "pages:".ljust(20) + (@pages.to_s + " pages").ljust(10)
        puts
    end

    # string representation
    def to_s 
        super + 
        ", author:".ljust(20) + @author.to_s.ljust(10) + "\n" + 
        "pages:".ljust(20) + @pages.to_s.ljust(10) + "\n"
    end
end