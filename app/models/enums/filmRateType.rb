module FilmRateType
  # constants
  NotRated = "Not Rated"
  G = "G"
  PG = "PG"
  PG13 = "PG-13"
  R = "R"
  NC17 = "NC-17"

  # class method to get all film rates
  def self.all
      constants.map { |const| const_get(const) }
  end
end