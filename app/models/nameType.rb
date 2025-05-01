class NameType
  # getters and setters
  attr_accessor :firstName, :lastName # setter

  # constructor to initialize first and last name
  def initialize(firstName = "", lastName = "")
      @firstName = firstName
      @lastName = lastName
  end

  # to_s is used to convert the object to a string
  def to_s
      "#{@firstName} #{@lastName}".strip
  end
end
