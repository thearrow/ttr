# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Admin.create(email: 'admin@example.com', password: 'password')


#Create example restaurants around Columbus, OH
Restaurant.create(
    [{
        name: 'Northstar Café',
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
    },
    {
        name: 'Cap City Fine Diner and Bar',
        description: "As with any diner, you feel immediately comfortable and at ease.
                      Like no other diner, it's artsy and cool.",
        url: 'http://www.capcityfinediner.com',
        street: '1299 Olentangy River Rd',
        city: 'Columbus',
        state: 'OH',
        zip: '43212',
        neighborhood: 'Grandview Heights',
        phone: '(614) 291-3663',
        latitude: 39.986732,
        longitude: -83.024846,
        reservations: true,
        reservations_link: 'http://www.opentable.com',
        tt_article: 'http://www.tastingtable.com',
        tt_date: DateTime.now,
        price: 3
    }]
)

#Create example bars around Columbus, OH
Bar.create(
    [{
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
    },
    {
        name: 'Hamptons on King',
        description: 'Great, friendly bartenders with excellent service.',
        url: 'http://www.bhamptonsonking.com',
        street: '234 King Ave',
        city: 'Columbus',
        state: 'OH',
        zip: '43201',
        neighborhood: 'University District',
        phone: '(614) 299-2099',
        latitude: 39.990435,
        longitude: -83.012530,
        reservations: false,
        reservations_link: 'http://www.opentable.com',
        tt_article: 'http://www.tastingtable.com',
        tt_date: DateTime.now,
        price: 1,
        food: true
    },
    {
        name: 'The Little Bar',
        description: 'With daily drink specials and live entertainment,
                      The Little Bar is your spot to catch your favorite sporting event,
                      get together with friends or have a long night out.',
        url: 'http://www.thelittlebar.com',
        street: '2195 N. High St.',
        city: 'Columbus',
        state: 'OH',
        zip: '43201',
        neighborhood: 'University District',
        phone: '(614) 291-8887',
        latitude: 40.007064,
        longitude: -83.009805,
        reservations: false,
        reservations_link: 'http://www.opentable.com',
        tt_article: 'http://www.tastingtable.com',
        tt_date: DateTime.now,
        price: 1,
        food: false
    }]
)


#Create the 'Atmosphere' and 'Best For' tags
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