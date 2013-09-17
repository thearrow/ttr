# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Admin.create(email: 'admin@example.com', password: 'password')

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
      longitude: -83.004305,
      reservations: true,
      reservations_link: 'http://www.opentable.com',
      tt_article: 'http://www.tastingtable.com',
      tt_date: DateTime.now,
      price: 2
    }
)

Bar.create(
    {
        name: 'Out-R-Inn',
        description: 'Grungy Campus Bar.',
        url: 'http://www.outrinn.com',
        street: '20 E Frambes Ave',
        city: 'Columbus',
        state: 'OH',
        zip: '43201',
        neighborhood: 'University District',
        phone: '(614) 294-9259',
        latitude: 40.004964,
        longitude: -83.008696,
        reservations: false,
        reservations_link: 'http://www.opentable.com',
        tt_article: 'http://www.tastingtable.com',
        tt_date: DateTime.now,
        price: 1,
        food: false
    }
)

atmospheres = ['Romantic', 'Fancy', 'Take Your Parents', 'Good for a Group', 'Foodist Scene', 'Kid-Friendly',
        'Casual', 'Good for Doing Business', 'Quiet', 'Wine Bar', 'Classic Cocktails', 'Innovative Cocktails',
        'Dive Bar', 'Neighborhood Bar', 'Beer Bar', 'Lounge', 'Speakeasy', 'Pub', 'Care Bar', 'Nightclub']
best_fors = ['Breakfast/Brunch', 'Lunch', 'Dinner', 'Late Night', 'Take Out', 'Delivery', 'Snack',
        'Dates', 'Happy Hour', 'Late-Night', 'Birthdays/Large Parties', 'Turbo-drinking', 'Work Drinks']

atmospheres.each do |tag|
  TagAtmosphere.create(name: tag)
end

best_fors.each do |tag|
  TagBestFor.create(name: tag)
end