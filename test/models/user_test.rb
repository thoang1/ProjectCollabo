require 'test_helper'

class UserTest < ActiveSupport::TestCase
	should have_many(:user_friendships)
  should have_many(:friends)

test "a user should enter a first name" do
    user = User.new
    assert !user.save
    assert !user.errors[:first_name].empty?
  end

  test "a user should enter a last name" do 
  	user = User.new
  	assert !user.save
  	assert !user.errors[:last_name].empty?
  end

 test "a user should live in a country" do 
 	user = User.new
 	assert !user.save
 	assert !user.errors[:country].empty?
 end

  test "a user should have a gender" do 
 	user = User.new
 	assert !user.save
 	assert !user.errors[:gender].empty?
 end

  test "a user should have a profile name" do 
 	user = User.new
 	assert !user.save
 	assert !user.errors[:profile_name].empty?
 end

  test "a user should have a unique profile name" do
    user = User.new
    user.profile_name = users(:tyler).profile_name
    assert !user.save
    assert !user.errors[:profile_name].empty?
  end

  test "a user should have a profile name without spaces" do
    user = User.new(first_name: 'Tyler', last_name: 'Oliver', email: 'tyler8oliver@gmail.com')
    user.password = user.password_confirmation = 'dfwfdwdfwf'

    user.profile_name = "tyler oliver"

    assert !user.save
    assert !user.errors[:profile_name].empty?
    assert user.errors[:profile_name].include?("Must be formatted correctly.")
  end

  #test "a user should have a correctly formatted profile name" do
   # user = User.new(first_name: 'Tyler', last_name: 'Oliver', email: 'tyler8oliver@gmail.com')
    #user.password = user.password_confirmation = 'dfwfdwdfwf'
    #user.profile_name = 'tyler8oliver'
    #assert user.valid?
    #assert user.save
  #end

  test "no error is raised when trying to access friend list" do
    assert_nothing_raised do
      users(:tyler).friends
    end
  end

  test "that creating friendships on a user works" do
    users(:tyler).pending_friends << users(:zach)
    users(:tyler).pending_friends.reload
    assert users(:tyler).pending_friends.include?(users(:zach))
  end 

  test "that calling to_param on a user returns the profile_name" do
    assert_equal "tyler8oliver", users(:tyler).to_param
  end

end
