# require_relative is used to include other Ruby files
require_relative 'product'
require_relative 'nameType'
require_relative 'enums/genreType'

class AudioProduct < Product
    attr_accessor :singer, :genre # setter 

    # initialize product name, price, and singer
    def initialize(prodName = "", price = 0.0, singer = NameType.new)
        super(prodName, price) # call superclass constructor
        @singer = singer 
        @genre = nil
    end

    # product type return "Music"
    def getProdTypeStr
        "music"
    end

    def displayContentsInfo
        puts "singer name: ".ljust(20) + @singer.to_s.ljust(10)
        puts "genre: ".ljust(20) + @genre.to_s.ljust(10)
        puts
    end

    # string representation
    def to_s 
        super + 
        ", singer:".ljust(20) + @singer.to_s.ljust(10) + "\n" + 
        "genre:".ljust(20) + @genre.to_s.ljust(10) + "\n"
    end

end