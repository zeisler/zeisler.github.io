#{% capture require %}
require_relative "person"
#{% endcapture %}
person_array = [
  Person.new(
    age: 10, height: 4
  ),
  Person.new(
    age: 19, height: 4
  ),
  Person.new(
    age: 45, height: 6
  ),
  Person.new(
    age: 16, height: 5
  ),
  Person.new(
    age: 32, height: 5
  ),
]
#{% capture global %}
$person_array = person_array
#{% endcapture %}
