namespace :db do
	desc "Fill database with sample users"
	task populate: :environment do
		admin = User.create!(name: "Jason Chance",
                 email: "astarael7@gmail.com",
                 password: "foobar",
                 password_confirmation: "foobar")

		admin.toggle!(:admin)
		
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@example.org"
			password = "password"
			User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
		end
		
		users = User.all(limit: 6)
		
		50.times do
			content = Faker::Lorem.paragraph
			title = content.split(/\s+/, 3)[0...2].join(' ').capitalize
			users.each { |user| user.posts.create!(title: title, content: content) }
		end
	end
end