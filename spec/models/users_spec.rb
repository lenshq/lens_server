require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'enumerize' do
    it { is_expected.to enumerize(:role) }
  end
end
