class Parsers::Rails::Rails3
  def initialize(row_data)
    @row_data = JSON.parse(row_data).with_indifferent_access
    @result = {}
  end

  def parse
    @result[:meta] =
      {
        controller: @row_data[:data][:controller],
        action: @row_data[:data][:action],
        url: @row_data[:data][:url],
        start: @row_data[:data][:start],
        finish: @row_data[:data][:end],
        duration: @row_data[:data][:duration]
      }

    @result[:details] = parse_records(@row_data[:data][:records])

    @result
  end

  def parse_records(data)
    data.map do |record|
      case record[:etype]
      when 'sql.active_record'
        fill_sql(record)
      when '!render_template.action_view'
        nil #fill_render_template!(record)
      when 'render_template.action_view'
        fill_render_template(record)
      when 'render_partial.action_view'
        fill_render_partial(record)
      when 'read_fragment.action_controller'
        fill_read_fragment(record)
      else
        p record[:etype]
      end
    end.compact
  end

  def fill_read_fragment(record)
    {
      type: :cache_fetch,
      content: record[:key]
    }.merge(base_record_details(record))
  end

  def fill_render_partial(record)
    identifier = record[:identifier].split('/')
    identifier.slice!(0, identifier.index('app'))
    path = identifier.join('/')
    {
      type: :partial,
      content: path
    }.merge(base_record_details(record))
  end

  def fill_render_template(record)
    identifier = record[:identifier].split('/')
    identifier.slice!(0, identifier.index('app'))
    path = identifier.join('/')
    {
      type: :template,
      content: path,
      layout: record[:layout],
    }.merge(base_record_details(record))
  end

  def fill_render_template!(record)
    childs = []
    {
      type: :template,
      content: record[:virtual_path],
      childrens: childs
    }.merge(base_record_details(record))
  end

  def fill_sql(record)
    {
      type: :sql,
      content: PgQuery.normalize(record[:sql]),
      source: record[:name] == 'SCHEMA' ? 'Rails' : 'Application'
    }.merge(base_record_details(record))
  end

  def base_record_details(record)
    {
      duration: record[:eduration],
      start: record[:estart],
      finish: record[:efinish]
    }
  end
end
