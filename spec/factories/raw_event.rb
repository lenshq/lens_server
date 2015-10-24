include ActionDispatch::TestProcess

path_to_file = "#{Rails.root}/spec/fixtures/rails4_raw_data.json"

FactoryGirl.define do
  factory :raw_event do
    association :application
    sequence(:data) { JSON.parse(File.read(path_to_file))['data'].to_json }
  end
end
