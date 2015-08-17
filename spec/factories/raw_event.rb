include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :raw_event do
    sequence(:data) { fixture_file_upload("#{Rails.root}/spec/fixtures/rails4_raw_data.json", 'application/json') }
  end
end
