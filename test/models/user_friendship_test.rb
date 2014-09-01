require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:friend)
	
	test "a friendship works" do
		assert_nothing_raised do
			UserFriendship.create user: users(:tyler), friend: users(:zach)
		end
	end

	test "that creating a friendships based on a users id and a friends is workss" do
	    UserFriendship.create user_id: users(:tyler).id, friend_id: users(:zach).id
	    assert users(:tyler).pending_friends.include?(users(:zach))
  end

  context "a new instance" do
    setup do
      @user_friendship = UserFriendship.new user: users(:tyler), friend: users(:chad)
    end

    should "have a pending state" do
      assert_equal 'pending', @user_friendship.state
    end
  end

  context "#send_request_email" do
    setup do
      @user_friendship = UserFriendship.create user: users(:tyler), friend: users(:chad)
    end

    should "send an email" do
      assert_difference 'ActionMailer::Base.deliveries.size', 1 do
        @user_friendship.send_request_email
      end
    end
  end  
end
