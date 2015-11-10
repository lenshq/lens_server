require 'rails_helper'

RSpec.describe 'Normalizer' do
  let(:record_with_sql) { { sql: 'select * from users where channel_id in (1, 2, 3, 4)' } }

  it 'should have no evens with not normalized params' do
    normalized_record = Normalizers::ActiveRecord::Sql.normalize(record_with_sql)
    expect(normalized_record[:content]).to eq('select * from users where channel_id in (?)')
  end
end
