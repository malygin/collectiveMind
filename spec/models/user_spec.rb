require 'spec_helper'

describe User do
	before(:each) do
		@attr = {:name => "MYNAME" , :surname => "SURNAME", :email => "anmalygin@gmail.com",
					:password => "foobar", :password_confirmation => "foobar"}
	end
	it "should create a new instance given valid attributes" do
		User.create!(@attr)
	end
	it "should require a name" do
		no_name_user = User.new (@attr.merge(:name => ""))
		no_name_user.should_not be_valid
	end

	it "should reject  names that they are too long" do
		too_long_name="a"*51
		user_with_long_name = User.new (@attr.merge(:name => too_long_name))
		user_with_long_name.should_not be_valid
	end

	it "should accept valid email adresses" do 
		adresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
		adresses.each do |address|
			valid_email_user = User.new(@attr.merge(:email => address))
			valid_email_user.should be_valid
		end
	end

	describe "password_validation" do
		
		before(:each) do
	      @user = User.create!(@attr)
	    end

		it "should require a password" do
			User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
		end

		it "should require a matching password confirmation" do
			User.new(@attr.merge(:password_confirmation =>"invalid")).should_not be_valid
		end

		it "should reject short passwords" do
			short = "a" * 5
			hash = @attr.merge(:password => short, :password_confirmation =>short)
			User.new(hash).should_not be_valid
		end

		it "should reject long password" do
			long = "a" *41
			hash = @attr.merge(:password =>long, :password_confirmation =>long)
			User.new(hash).should_not be_valid
		end
	end

	describe "password encryption" do

	    before(:each) do
	      @user = User.create!(@attr)
	    end

	    it "should have an encrypted password attribute" do
	      @user.should respond_to(:encrypted_password)
	    end
	    it "should set the encrypted password" do
    	  @user.encrypted_password.should_not be_blank
    	end

    	describe "has_password? method" do

		      it "should be true if the passwords match" do
		        @user.has_password?(@attr[:password]).should be_true
		      end

		      it "should be false if the passwords don't match" do
		        @user.has_password?("invalid").should be_false
		      end
		end

		describe "authenticate method" do
			
			it "should return nil on email/password mismatch" do
				wrong_password_user = User.authenticate(@attr[:email], "wrong_password")
				wrong_password_user.should be_nil
			end

			it "should return nil for an email address with no user" do
				nonexisting_user = User.authenticate("bar@foo.com", @attr[:password])
				nonexisting_user.should be_nil
			end

			it "should return  the user on email/password match" do
				#puts User.find_by_email(@attr[:email]) == @user
				matching_user = User.authenticate(@attr[:email], @attr[:password])
				matching_user.should == @user
			end

		end
	end

end