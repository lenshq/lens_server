class ParsedRawEvent
  attr_accessor :raw_event

  def initialize(raw_event)
    @raw_event = raw_event
  end

  def meta
    @meta ||= extract_meta
  end

  def details
    @details ||= extract_details
  end

  private

  def extract_data
    raw_data = JSON.parse(raw_event.data)
    Parser.new(raw_data).parse
  end

  def data
    @data ||= extract_data
  end

  def extract_meta
    data[:meta]
  end

  def extract_details
    raw_details = data[:details]
    add_transactions_to_details(raw_details)
  end

  def add_transactions_to_details(details)
    position = nil

    details.each_with_object({}).with_index do |(row, memo), index|
      case row[:content]
      when transaction_begin?
        memo[:type] = row[:type]
        memo[:start] = row[:start]
        position = index
      when transaction_end?
        if position
          memo[:content] = "BEGIN #{row[:content]} transaction"
          memo[:finish] = row[:finish]
          memo[:duration] = ((memo[:finish] - memo[:start]) * 1000)
          details.insert(position, memo.dup)
          memo.clear
          position = nil
        end
      end
    end

    details
  end

  def transaction_begin?
    ->(content) { content == 'BEGIN' }
  end

  def transaction_end?
    ->(content) { %w(ROLLBACK COMMIT).include? content }
  end
end
