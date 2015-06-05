class Application < ActiveRecord::Base
  belongs_to :user
  has_many :application_users, dependent: :destroy
  has_many :colleagues, through: :application_users, source: :user, class_name: User

  validates :domain, presence: true, uniqueness: true
  validates :token, presence: true, uniqueness: true
  validates :title, presence: true

  before_validation :generate_token, on: :create


  GROUPS = [
    100, 200, 300,500,750,1000,
    1250,1500,2000,3000,3000,5000,7000,10000000000
  ]

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
id serial primary key,
url character varying(255),
datetime timestamp without time zone,
duration integer,
data json
);
CREATE INDEX index_#{app_table_name}_on_url ON #{app_table_name} USING btree (url);
}

    ActiveRecord::Base.connection.execute(str)
  end

  def requests(params = {})
    request_id    = params[:id]            ? params[:id].to_s.to_i            : nil
    start_period  = params[:date_from]     ? Time.parse(params[:date_from])   : nil
    end_period    = params[:date_from]     ? Time.parse(params[:date_to])     : nil
    duration_from = params[:duration_from] ? params[:duration_from].to_s.to_i : nil
    duration_to   = params[:duration_to]   ? params[:duration_from].to_s.to_i : nil
    last_id       = params[:last_id]       ? params[:last_id].to_s.to_i       : nil
    limit         = params[:per_page]      ? params[:per_page].to_s.to_i      : 10
    page          = params[:page]          ? params[:page].to_s.to_i          : 1
    page          = page > 0 ? page : 1
    offset        = (page - 1) * limit

    tbl = Arel::Table.new(app_table_name)
    query = query.project(Arel.star)

    if request_id
      query = query.where(tbl[:id].eq(request_id))
    else
      query = query.where(tbl[:datetime].gteq(start_period.to_s(:db)))   if start_period.present?
      query = query.where(tbl[:datetime].lteq(end_period.to_s(:db)))   if end_period.present?
      query = query.where(tbl[:url].matches(params[:url]))             if params[:url]
      query = query.where(tbl[:duration].gteq(duration_from))          if duration_from
      query = query.where(tbl[:duration].lteq(duration_to))            if duration_to
      query = query.where(tbl[:id].lteq(last_id))                      if last_id
      query = query.skip(offset)                                       if offset > 0
      query = query.take(limit)
      query = query.order(tbl[:datetime].desc)
    end

    query = query.project(Arel.star)

    ActiveRecord::Base.connection.execute(query.to_sql).to_a
  end

  def rec_data(data)
    create_table_if_not_exists
    json = filter_json_for_record(data)

    data.stringify_keys!
    if data['time'].is_a?(Time)
      time = data['time']
    else
      time = Time.parse(data['time']) || Time.now
    end


    sql = sanitize_query(["INSERT INTO #{app_table_name} (url,datetime,duration,data) VALUES (?,?,?,?)", data['url'], time, data['duration'].to_i, JSON.dump(json)])
    ActiveRecord::Base.connection.execute(sql)
  end

  def run_query(params)
    start_period = Time.parse(params[:date_from])
    end_period = Time.parse(params[:date_to])


    tbl = Arel::Table.new(app_table_name)
    query = tbl.project(Arel.star)
    if params[:date_from].present?
      query = tbl.where(tbl[:datetime].gteq(start_period.to_s(:db)))
    end

    if params[:date_to].present?
      query = tbl.where(tbl[:datetime].lteq(end_period.to_s(:db)))
    end

    if params[:url]
      query = query.where(tbl[:url].matches(params[:url]))
    end

    if params[:duration_from]
      query = query.where(tbl[:duration].gteq(params[:duration_from]))
    end

    if params[:duration_to]
      query = query.where(tbl[:duration].lteq(params[:duration_to]))
    end

    query = query.project(Arel.star)


    res = ActiveRecord::Base.connection.execute(query.to_sql).to_a
    sort_into_groups(res)
  end

private

  def sort_into_groups(res)
    grouped = {}
    res.each do |event|
      detected_group = GROUPS.detect {|g| g > event['duration'].to_i }
      grouped[detected_group] ||= 0
      grouped[detected_group] += 1
    end

    out = []
    grouped.each do |k, v|
      start_ind = GROUPS.index(k) - 1
      start = start_ind >= 0 ? GROUPS[start_ind] : 0
      out << {group: [start, k], count: v}
    end

    out
  end

  def w(str, wrapper)
    "#{wrapper}#{str}#{wrapper}"
  end

  def sanitize_query(arr)
    self.class.send(:sanitize_sql, arr)
  end


  def filter_json_for_record(data)
    out = {}
    data.each do |k, v|
      if !['url', 'time', 'duration'].include?(k)
        out[k] = v
      end
    end

    #out['records'] = <D-d>

    out
  end

  def generate_token
    if self.token.blank?
      self.token = Digest::MD5.hexdigest([Time.now, rand(1_000_000)].join("_"))
    end
  end
end
