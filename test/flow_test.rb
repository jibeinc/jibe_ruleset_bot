require 'test_helper'

class FlowTest < Minitest::Test
  def setup
    @json = File.read("#{Dir.pwd}/test/test_json/test_json_one.json")
    @flow = Flow.build_via_json(@json)
  end

  def test_basic_flow_execution
    step_one = Step.new(name: 'Step One',
                        target: 'https://pgp.mit.edu/',
                        method: :go, value: nil, is_validator: false)
    step_two = Step.new(name: 'Step Two',
                        target: "/html/body/a[1]",
                        method: :click, value: nil, is_validator: false)
    step_three = Step.new(name: 'Validation', target: nil, method: :url_equals,
                          value: 'https://pgp.mit.edu/extracthelp.html',
                          is_validator: true)
    action = Action.new("Action", [step_one, step_two, step_three])
    bot = MechanizeBot.new
    assert Flow.new([action], bot).perform

    step_three_alt = Step.new(name: 'Validation', target: nil, method: :url_equals,
                              value: 'https://pgp.mit.edu/foo.html',
                              is_validator: true)
    action = Action.new("Alt Action", [step_one, step_two, step_three_alt])
    refute Flow.new([action], bot).perform
  end

  def test_building_from_json
    assert @flow.all_actions.first.is_a? Action
    assert @flow.actions['Action one'].is_a? Action
  end

  def test_starting_action_properly_set
    assert_equal "Action one", @flow.starting_action.name
  end
end
