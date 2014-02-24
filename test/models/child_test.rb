require 'test_helper'

class ChildTest < ActiveSupport::TestCase

  # shoulda matchers
  should have_many(:chores)
  should have_many(:tasks).through(:chores)
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)  


  # set up a context for further testing
  # include Contexts  # (if not done already...)
  context "Creating a child context" do
    setup do 
      create_children
    end
    
    teardown do
      destroy_children
    end

    should "have name methods that list first_ and last_names combined" do
      assert_equal "Alex Heimann", @alex.name
      assert_equal "Mark Heimann", @mark.name
      assert_equal "Rachel Heimann", @rachel.name
    end

    should "have a method to find the points a child has earned" do
      create_tasks
      create_chores
      assert_equal 4, @alex.points_earned
      assert_equal 1, @mark.points_earned
      assert_equal 0, @rachel.points_earned
      destroy_tasks
      destroy_chores
    end
    
    should "have a scope to alphabetize children" do
      assert_equal ["Alex", "Mark", "Rachel"], Child.alphabetical.map(&:first_name)
    end
    
    should "have a scope to select only active children" do
      assert_equal ["Alex", "Mark"], Child.active.alphabetical.map(&:first_name)
    end

  end
end
