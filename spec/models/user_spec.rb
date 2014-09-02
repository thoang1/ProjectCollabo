require 'rails_helper'

RSpec.describe User, :type => :model do


  before do
  	@user = FactoryGirl.create(:user)
  end

  subject { @user }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:profile_name) }
  it { should respond_to(:about_me) }
  it { should respond_to(:hobbies) }
  it { should respond_to(:gender) }
  it { should respond_to(:country) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }

  describe "when first name isn't present" do
    it { should validate_presence_of(:first_name) }
  end

  describe "when last name isn't present" do
    it { should validate_presence_of(:last_name) }
  end

  describe "when profile name isn't present" do
    it { should validate_presence_of(:profile_name) }
  end

  describe "that a profile name is unique" do
    it { should validate_uniqueness_of(:profile_name) }
  end

  describe "when user's about me isn't present" do
    it { should validate_presence_of(:about_me) }
  end

  describe "when user's hobbies isn't present" do
    it { should validate_presence_of(:hobbies) }
  end

  describe "when gender isn't present" do
    it { should validate_presence_of(:gender) }
  end

  describe "when country isn't present" do
    it { should validate_presence_of(:country) }
  end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end

  describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end
end
