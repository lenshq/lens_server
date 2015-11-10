require 'rails_helper'

RSpec.describe Scenario, type: :model do
  describe 'relations' do
    it { is_expected.to respond_to :event_source }
  end

  describe 'attributes' do
    it { is_expected.to respond_to :events_hash }
  end
end
