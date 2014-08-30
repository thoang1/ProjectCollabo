require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase

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
          assert_redirected_to profile_path(users(:chad))
        end

        should "set the flash success message" do
          assert flash[:success]
          assert_equal "Network invitation sent to #{@friend.full_name}.", flash[:success]
        end
      end 
 		end
 	end 
end
