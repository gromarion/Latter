# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Badge.create(
  name: 'Break the Ice',
  image_url: 'https://s3.amazonaws.com/f.cl.ly/items/0n3N252J1q1l333B2o3W/price-silver.png',
  description: 'Get over 1001 points',
  required_rating: 1001
)

Badge.create(
  name: 'Bronze',
  image_url: 'https://s3.amazonaws.com/f.cl.ly/items/0v1Z0p230I2j1T402K0P/price-gold.png',
  description: 'Get over 1100 points',
  required_rating: 1100
)

Badge.create(
  name: 'Silver',
  image_url: 'https://s3.amazonaws.com/f.cl.ly/items/0v1Z0p230I2j1T402K0P/price-gold.png',
  description: 'Get over 1500 points',
  required_rating: 1500
)

Badge.create(
  name: 'Gold',
  image_url: 'https://s3.amazonaws.com/f.cl.ly/items/0v1Z0p230I2j1T402K0P/price-gold.png',
  description: 'Get over 2000 points',
  required_rating: 2000
)

Badge.create(
  name: 'Platinum',
  image_url: 'https://s3.amazonaws.com/f.cl.ly/items/0v1Z0p230I2j1T402K0P/price-gold.png',
  description: 'Get over 2500 points',
  required_rating: 2500
)
