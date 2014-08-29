require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:friend)
	
	test "a friendship works" do
		assert_nothing_raised do
			UserFriendship.create user: users(:one), friend: users(:two)
		end
	end

	 test "that creating a friendships based on a users id and a friends is workss" do
    UserFriendships.create user_id: users(:one).id, friend_id: users(:two).id
    assert users(:one).friends.include?(users(:two))
  end
end
