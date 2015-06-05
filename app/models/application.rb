class Application < ActiveRecord::Base
  belongs_to :user
  has_many :application_users, dependent: :destroy
  has_many :colleagues, through: :application_users, source: :user, class_name: User

  validates :domain, presence: true, uniqueness: true
  validates :token, presence: true, uniqueness: true
  validates :title, presence: true

  before_validation :generate_token, on: :create

  def app_table_name
    "events_data_for_#{id}"
  end

  def table_exists?
    res = ActiveRecord::Base.connection.execute(%Q{
select * from information_schema.tables where table_name='#{app_table_name}';
}).to_a
    res.length == 1
  end

  def create_table_if_not_exists
    return if table_exists?
    str = %Q{CREATE TABLE #{app_table_name} (
url character varying(255),
datetime time without time zone,
data json
);
CREATE INDEX index_#{app_table_name}_on_url ON #{app_table_name} USING btree (url);
}

    ActiveRecord::Base.connection.execute(str)
  end

  def rec_data(data)
    create_table_if_not_exists
    json = filter_json_for_record(data)

    time = Time.parse(data['time']) || Time.now
    vals = [w(data['url'], "\'"), w(, "'"), w(JSON.dump(json), "'")]
    ActiveRecord::Base.connection.execute(%Q{INSERT INTO #{app_table_name} (url,datetime,data) VALUES (#{vals.join(',')})})
  end

private

  def w(str, wrapper)
    "#{wrapper}#{str}#{wrapper}"
  end

  def filter_json_for_record(data)
    out = {}
    data.each do |k, v|
      if !['url', 'time'].include?(k)
        out[k] = v
      end
    end

    out
  end

  def generate_token
    if self.token.blank?
      self.token = Digest::MD5.hexdigest([Time.now, rand(1_000_000)].join("_"))
    end
  end
end
