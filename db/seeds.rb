# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
genres = ["Horror","Action","Adventure","Comedy","Disaster","Documentary","ScienceFiction","Disaster"]

images = ["http://img.theqoo.net/img/ZwlOj.png",
          "http://img.theqoo.net/img/wPrNU.png",
         ]
2.times do
     Movie.create(title: Faker::Movie.quote,
                 genre: genres.sample,
                 director: Faker::Name.name,
                 user_id: 1,
                 remote_image_path_url: images.sample,
                 actor: Faker::Name.first_name,
                 description: Faker::Lorem.paragraph
                 )
end