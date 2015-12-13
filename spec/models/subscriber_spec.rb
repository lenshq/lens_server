require 'rails_helper'

RSpec.describe Subscriber do
  describe '#email=' do
    let(:email) { 'eMaIl@eXaMplE.com' }
    subject { described_class.new(email: email).email }

    it { is_expected.to eq email.downcase }
  end

  describe '#create' do
    let(:subscriber) { create :subscriber }
    subject(:verification_token) { subscriber.verification_token }
    subject(:unsubscription_token) { subscriber.unsubscription_token }

    it { expect(verification_token).to be_present }
    it { expect(unsubscription_token).to be_present }
  end
end
