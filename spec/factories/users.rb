# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
  	first_name 'First'
        last_name 'Last'
        sequence(:email) {|n| "user#{n}@example.com"}
        sequence(:profile_name) {|n| "username_#{n}"}
        about_me 'test'
        hobbies 'test'
        country 'test'
        gender 'test'

        password "mypassword"
        password_confirmation "mypassword"
  end
end
