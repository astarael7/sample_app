FactoryGirl.define do
	factory :user do
		sequence(:name) { |n| "Person #{n}" }
		sequence(:email) { |n| "person_#{n}@example.com"}
		password "foobar"
		password_confirmation "foobar"

		factory :admin do
			admin true
		end
	end

	factory :post do
		title "Lorem ipsum"
		content "dolor sit amet"
		user
	end

	factory :comment do
		content "Lorem ipsum"
		post
	end
end