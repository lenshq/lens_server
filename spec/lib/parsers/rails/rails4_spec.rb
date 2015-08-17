require 'spec_helper'
require 'parsers/rails/rails4'

RSpec.describe Parsers::Rails::Rails4 do
  let(:raw_json_data) { File.read('spec/fixtures/rails4_raw_data.json') }

  let(:parser) { Parsers::Rails::Rails4.new(raw_json_data) }

  describe "#parse" do
    subject { parser.parse }

    it "parses data" do
      expect { subject }.to_not raise_error
    end

    it "populates :meta" do
      expect(subject[:meta]).to_not be_blank
    end

    it "populates :details" do
      expect(subject[:details]).to_not be_blank
    end
  end
end

