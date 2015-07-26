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
      Normalizer.new(record).normalize
    end.compact
  end
end
