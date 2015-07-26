class Normalizer
  def initialize(record, skip_initial_events = true)
    @record = record
    @skip_initial_events = skip_initial_events
  end

  def normalize
    return nil if @record[:etype].starts_with?('!') && @skip_initial_events

    klass.normalize(@record)
  end

  def klass
    @klass ||= begin
                 source_type = @record[:etype].dup

                 unless @skip_initial_events
                   source_type.gsub!('!', 'initial_')
                 end

                 (['normalizers'] + source_type.split('.').reverse).join('/').camelize.constantize
               rescue
                 Normalizers::Base
               end
  end
end
