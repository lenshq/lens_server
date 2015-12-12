require 'rails_helper'

RSpec.describe Follower do
  describe '#email=' do
    let(:email) { 'eMaIl@eXaMplE.com' }
    subject { described_class.new(email: email).email }

    it { is_expected.to eq email.downcase }
  end
end
