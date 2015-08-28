# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Badge.create(name: 'Silver Bull', image_url: "http://www.musemelody.com/images/silver-badge.png", description: "Get over 1001 points", required_rating: 1001)
Badge.create(name: 'Gold Bull', image_url: "http://www.nwunity.org/wp-content/uploads/2014/04/Gold-Badge.png", description: "Get over 1020 points", required_rating: 1020)
