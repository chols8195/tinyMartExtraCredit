module GenreType
  # constants 
  Blues = "blues"
  Classical = "classical"
  Country = "country"
  Folk = "folk"
  Jazz = "jazz"
  Metal = "metal"
  Pop = "pop"
  RnB = "r&b"
  Rock = "rock"

  # class method to get all genres
  def self.all 
      constants.map { |const| const_get(const) }
  end
end
  