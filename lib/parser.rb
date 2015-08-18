class Parser
  def initialize(data)
    @data = data.with_indifferent_access
  end

  def parse
    klass.new({ data: @data}.to_json).parse
  end

  def klass
    @klass ||= begin
                 path_parts = ['parsers']
                 meta = @data[:meta]


                 if meta[:rails_version].present?
                   path_parts << 'rails'
                   path_parts << "rails#{meta[:rails_version].split('.').first}"
                 end

                 path_parts.join('/').camelize.constantize
               rescue
                 Parsers::Base
               end
  end
end
