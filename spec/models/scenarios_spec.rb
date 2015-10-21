require "rails_helper"

RSpec.describe Scenario, type: :model do
  context 'instance attributes and methods' do
    # db
    it { is_expected.to respond_to :events_hash }

    # associations
    it { is_expected.to respond_to :event_source }
    it { is_expected.to respond_to :pages }
    # others
  end
end
