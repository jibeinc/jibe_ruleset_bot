require "test_helper"
require "web_minion/histories/flow_history"
require "web_minion/histories/action_history"

# Class for testing History classes
class HistoryTest < Minitest::Test
  include WebMinion

  def test_auto_set_runtime
    t1 = Time.parse("25-05-2016 12:00:00")
    t2 = Time.parse("25-05-2016 12:05:00")
    hist = History.new(t1)
    hist.end_time = t2
    assert_equal 5 * 60, hist.runtime
  end

  def test_can_set_status_from_bool
    hist = History.new
    hist.status = true
    assert_equal "Successful", hist.status
    hist.status = false
    assert_equal "Unsuccessful", hist.status
  end

  def test_flow_history_generation
    hist = FlowHistory.new
    assert_equal [], hist.action_history
    assert hist.start_time
  end

  def test_action_history_generation
    hist = ActionHistory.new("Test", 1)
    assert_equal "Test", hist.action_name
    assert hist.start_time
  end

  def test_parse_status
    hist = History.new
    assert_raises(History::InvalidStatus) { hist.status = WebMinion }
    assert_raises(History::InvalidStatus) { hist.status = "NOOOOOO" }
    hist.status = true
    assert_equal "Successful", hist.status
    hist.status = "skipped"
    assert_equal "Skipped", hist.status
  end
end
