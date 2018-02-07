class Person
  attr_reader :height, :age

  def initialize(age:, height:)
    @age    = age
    @height = height
  end

  def to_s
    "<#Person age: #{age}, height: #{height}>"
  end
end
