# coding: utf-8
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "jima",
                         email: "jima0537@gmail.com",
                         password: "chunkybacon",
                         password_confirmation: "chunkybacon",
                         email_public: true )
    admin.toggle!(:admin)
    
    49.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      e_public = [true, false]
      email_public = e_public[rand(2)]
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password,
                   email_public: email_public)
    end

    users = User.all(limit: 6)
    30.times do

      boo = [true, false]
      c_color = [ 'red', 'blue', 'yellow' ]

#      title = Faker::Lorem.sentence(1)
      title = %w{会議 ミーティング 営業 食事 ショッピング 飲み会 反省会 打ち合わせ}
      description = Faker::Lorem.sentence(5)

      users.each { |user|
                         public_boo = false
                         public_boo = true if rand(9) == 0
                         start = Time.now - 14.days + rand(30).days + 6.hours + rand(360).minutes
                         user.events.create!(
                                              title: title[rand(8)],
                                              description: description,
                                              start_time: start,
                                              end_time: start + 30.minutes + rand(120).minutes,
                                              allday: boo[rand(2)],
                                              editable: true,
                                              classname: "classname_#{c_color[rand(3)]}",
                                              public: public_boo
                                              ) 
                  }
    end
  end
end
