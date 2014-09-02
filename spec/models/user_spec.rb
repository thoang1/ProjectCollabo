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


end
