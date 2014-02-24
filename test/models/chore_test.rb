require 'test_helper'

class ChoreTest < ActiveSupport::TestCase

  # shoulda matchers
  should belong_to(:child)
  should belong_to(:task)
  should allow_value(1.day.from_now.to_date).for(:due_on)
  should allow_value(1.day.ago.to_date).for(:due_on)
  should allow_value(Date.today).for(:due_on)
  should_not allow_value("bad").for(:due_on)
  should_not allow_value(3.14159).for(:due_on)

  # set up a context for further testing
  # include Contexts (if not done already...)
  context "Creating a chore context" do
    setup do 
      create_children
      create_tasks
      create_chores
    end
    
    teardown do
      destroy_chores
      destroy_children
      destroy_tasks
    end

    should "has a scope to order alphabetically by task name" do
      assert_equal ["Shovel driveway","Sweep floor","Sweep floor","Sweep floor", "Wash dishes","Wash dishes","Wash dishes"], Chore.by_task.map{|c| c.task.name}
    end

    should "has a scope to order chronologically by due_on date" do
      assert_equal ["Shovel driveway","Sweep floor","Wash dishes","Sweep floor","Wash dishes","Sweep floor","Wash dishes"], Chore.chronological.by_task.map{|c| c.task.name}
    end
 
    should "has a scope for pending chores" do
      assert_equal 4, Chore.pending.size
    end
    
    should "has a scope for done chores" do
      assert_equal 3, Chore.done.size
    end
    
    should "has a scope for upcoming chores" do
      assert_equal 6, Chore.upcoming.size
    end
    
    should "has a scope for past chores" do
      assert_equal 1, Chore.past.size
    end
    
    should "display the status of shoveling [@ac3] as 'Completed'" do
      assert_equal "Completed", @ac3.status
    end
    
    should "display the status of sweeping [@mc1] as 'Pending'" do
      assert_equal "Pending", @mc1.status
    end
  end
end
