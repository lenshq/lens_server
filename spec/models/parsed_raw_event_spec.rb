require 'rails_helper'

RSpec.describe ParsedRawEvent do
  let(:raw_event) { create(:raw_event) }
  let(:parsed_raw_event) { described_class.new(raw_event) }

  describe '.meta' do
    subject { parsed_raw_event.meta }

    %i(controller action url start finish duration).each do |key|
      it "should include key '#{key}'" do
        is_expected.to have_key key
      end
    end
  end

  describe '.details' do
    subject { parsed_raw_event.details }

    it 'should be Array' do
      is_expected.to be_kind_of Array
    end

    context 'returned content' do
      subject { parsed_raw_event.details.first }

      %i(type content start finish duration).each do |key|
        it "should include key '#{key}'" do
          is_expected.to have_key key
        end
      end
    end

    it 'should include BEGIN COMMIT transaction' do
      expect(subject.map { |d| d[:content] }).to include 'BEGIN COMMIT transaction'
    end
  end
end
