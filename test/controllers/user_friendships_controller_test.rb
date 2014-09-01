require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
  context "#index" do
    context "when not logged in" do
      should "redirect to the login page" do
        get :index
        assert_response :redirect
      end
    end

    context "when logged in" do
      setup do
        @friendship1 = create(:pending_user_friendship, user: users(:tyler), friend: create(:user, first_name: 'Pending', last_name: 'Friend'))
        @friendship2 = create(:accepted_user_friendship, user: users(:tyler), friend: create(:user, first_name: 'Active', last_name: 'Friend'))
        #@friendship3 = create(:requested_user_friendship, user: users(:tyler), friend: create(:user, first_name: 'Requested', last_name: 'Friend'))
        #@friendship4 = user_friendships(:tyler)

        sign_in users(:tyler)
        get :index
      end

      should "get the index page without error" do
        assert_response :success
      end

      should "assign user_friendships" do
        assert assigns(:user_friendship)
      end

      should "display friends' names" do
        assert_match /Pending/, response.body
        assert_match /Active/, response.body
      end

      should "display pending information on a pending friendship" do
        assert_select "#user_friendship_#{@friendship1.id}" do
          assert_select "em", "Friendship is pending."
        end
      end

      should "display date information on an accepted friendship" do
        assert_select "#user_friendship_#{@friendship2.id}" do
          assert_select "em", "Friendship started #{@friendship2.updated_at}."
        end
      end
    end
  end

	context "#new" do
		context "when not logged in" do
			should "redirect to the login page" do
				get :new
				assert_response :redirect
			end
		end

		context "when logged in" do
			setup do
				sign_in users(:tyler)
			end

			should "get new and return success" do
				get :new
				assert_response :success
			end

			should "should set a flash error if the freind_is params are missing" do
				get :new, {}
				assert_equal "Friend required", flash[:error]
			end

			should "display the friends name" do
				get :new, friend_id: users(:zach)
				assert_match /#{users(:zach).full_name}/, response.body
			end

			should "assign a new user friendship" do
				get :new, friend_id: users(:zach)
				assert assigns(:user_friendship)
			end

			should "assign a new user friendship to the correct friend" do
				get :new, friend_id: users(:zach)
				assert_equal users(:zach), assigns(:user_friendship).friend
			end

			should "assign a new user friendship to the currently logged in user" do
				get :new, friend_id: users(:zach)
				assert_equal users(:tyler), assigns(:user_friendship).user
			end

			should "returns a 404 page is no friend is found" do
				get :new, friend_id: 'invalid'
				assert_response :not_found
			end

			 should "ask if you really want to befriend the user" do
        get :new, friend_id: users(:zach)
        assert_match /Do you really want to add #{users(:zach).full_name} to your network?/, response.body
      end
		end
	end

	context "#create" do
    context "when not logged in" do
      should "redirect to the login page" do
        get :new
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

     context "when logged in" do
      setup do
        sign_in users(:tyler)
      end

      context "with no friend_id" do
        setup do
          post :create
        end

        should "set the flash error message" do
          assert !flash[:error].empty?
        end

        should "redirect to the site root" do
          assert_redirected_to root_path
        end
      end

      context "with a valid friend_id" do
      	setup do
      		post :create, user_friendship: { friend_id: users(:chad) }
      	end

      	should "assign a friend object" do
          assert assigns(:friend)
          assert_equal users(:chad), assigns(:friend)
        end


        should "assign a user_friendship object" do
          assert assigns(:user_friendship)
          assert_equal users(:tyler), assigns(:user_friendship).user
          assert_equal users(:chad), assigns(:user_friendship).friend
        end

        should "create a friendship" do
          assert users(:tyler).pending_friends.include?(users(:chad))
        end

        should "redirect to the profile page of the friend" do
          assert_response :redirect
          assert_redirected_to user_path(users(:chad))
        end

        should "set the flash success message" do
          assert flash[:success]
          assert_equal "Network invitation sent to @friend.first_name.", flash[:success]
        end
      end 
 		end
 	end

   context "#accept" do
    context "when not logged in" do
      should "redirect to the login page" do
        put :accept, id: 1
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    context "when logged in" do
      setup do
        @friend = create(:user)
        @user_friendship = create(:pending_user_friendship, user: users(:tyler), friend: @friend)
        create(:pending_user_friendship, friend: users(:tyler), user: @friend)
        sign_in users(:tyler)
        put :accept, id: @user_friendship
        @user_friendship.reload
      end

      should "assign a user_friendship" do
        assert assigns(:user_friendship)
        assert_equal @user_friendship, assigns(:user_friendship)
      end

      should "update the state to accepted" do
        assert_equal 'accepted', @user_friendship.state
      end

      should "have a flash success message" do
        assert_equal "You are now friends with #{@user_friendship.friend.full_name}", flash[:success]
      end
    end
  end

  context "#edit" do
    context "when not logged in" do
      should "redirect to the login page" do
        get :edit, id: 1
        assert_response :redirect
      end
    end

    context "when logged in" do
      setup do
        @user_friendship = create(:pending_user_friendship, user: users(:tyler))
        sign_in users(:tyler)
        get :edit, id: @user_friendship
      end

      should "get edit and return success" do
        assert_response :success
      end

      should "assign to user_friendship" do
        assert assigns(:user_friendship)
      end

      should "assign to friend" do
        assert assigns(:friend)
      end
    end
  end
end
