#{% capture require %}
require_relative "person_array"
person_array = $person_array
# {% endcapture %}


tall_people = People.new(person_array).tall
puts tall_people.to_a
# => [<#Person age: 45, height: 6>
#     <#Person age: 16, height: 5>
#     <#Person age: 32, height: 5>]
puts tall_people.minors.to_a
#=> [<#Person age: 16, height: 5>]
