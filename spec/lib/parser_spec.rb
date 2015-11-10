require 'rails_helper'

RSpec.describe Parser do
  describe '#klass' do
    subject { described_class.new(raw_data).klass }

    describe 'returns correct class for rails 3' do
      let(:raw_data) do
        { 'meta' => { 'client_version' => '0.0.7', 'rails_version' => '3.2.13' } }
      end

      it { is_expected.to eq Parsers::Rails::Rails3 }
    end

    describe 'returns correct class for rails 4' do
      let(:raw_data) do
        { 'meta' => { 'client_version' => '0.0.7', 'rails_version' => '4.2.4' } }
      end

      it { is_expected.to eq Parsers::Rails::Rails4 }
    end
  end
end
