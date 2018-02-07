class People
  attr_reader :to_a

  def initialize(collection = [])
    @to_a = collection
  end

  def minors
    create to_a.select { |person| person.age < 19 }
  end

  def adults
    create to_a.reject { |person| minors.to_a.include?(person) }
  end

  def tall
    create to_a.select { |person| person.height >= 5 }
  end

  private

  def create(collection)
    self.class.new(collection)
  end
end
