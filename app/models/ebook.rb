# require_relative is used to include other Ruby files
require_relative 'bookProduct'

class Ebook < BookProduct
    # constructor to initialize product name, price, author, and pages
    def initialize(prodName = "", price = 0.0, author = NameType.new, pages = 0)
        super(prodName, price, author, pages) # call superclass constructor
    end

    # product type return "ebook"
    def getProdTypeStr
        "ebook"
    end
end
        