# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Restaurant.create(
    {
      name: 'Northstar',
      description: 'Trendy little cafe.',
      url: 'http://www.thenorthstarcafe.com',
      street: '951 N High St',
      city: 'Columbus',
      state: 'OH',
      zip: '43201',
      neighborhood: 'Short North',
      phone: '(614) 298-9999',
      latitude: 39.981964,
      longitude: -83.004305
    }
)