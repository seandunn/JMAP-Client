# frozen_string_literal: true

require "spec_helper"

RSpec.describe JMAP::Plugins::Core::FilterOperator do
  it "Accepts AND, OR, NOT as an operator." do
    expect {
      described_class.new(operator: :AND, conditions: :dummy_condition )
    }.not_to raise_error

    expect {
      described_class.new(operator: :OR, conditions: :dummy_condition )
    }.not_to raise_error

    expect {
      described_class.new(operator: :NOT, conditions: :dummy_condition )
    }.not_to raise_error
  end

  it "Raises an exception when its operator is not in the allowed set." do
    expect {
      described_class.new(operator: :FOO, conditions: :dummy_condition )
    }.to raise_error(JMAP::Plugins::Core::FilterOperator::InvalidOperatorError)
  end
end
