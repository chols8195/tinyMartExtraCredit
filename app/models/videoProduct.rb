# require_relative is used to include other Ruby files
require_relative 'product'
require_relative 'nameType'
require_relative 'enums/filmRateType'

class VideoProduct < Product
    attr_accessor :director, :filmRate, :releaseYear, :runTime # setter 

    # constructor to initialize product name, price, and singer
    def initialize(prodName = "", price = 0.0, director = NameType.new, releaseYear = 0, runTime = 0)
        super(prodName, price) # call superclass constructor
        @director = director
        @filmRate = nil
        @releaseYear = releaseYear
        @runTime = runTime
    end

    # product type return "Music"
    def getProdTypeStr
        "movie"
    end

    def displayContentsInfo
        puts "release year: ".ljust(20) + @releaseYear.to_s.ljust(10)
        puts "film rating: ".ljust(20) + @filmRate.to_s.ljust(10)
        puts "run time: ".ljust(20) + (@runTime.to_s + " minutes").ljust(10)
        puts "director name: ".ljust(20) + @director.to_s.ljust(10)
        puts
    end

    # method to check if the product is a new release
    def isNewRelease(year)
        @releaseYear == year
    end

    # string representation
    def to_s 
        super + 
        ", singer:".ljust(20) + @singer.to_s.ljust(10) + "\n" + 
        "genre:".ljust(20) + @genre.to_s.ljust(10) + "\n"
    end
end