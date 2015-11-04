class Normalizer
  def initialize(record)
    @record = record
  end

  def normalize
    return if initial_event?(@record[:etype])
    klass.normalize(@record)
  end

  def klass
    @klass ||= begin
      source_type = @record[:etype].dup

      (['normalizers'] + source_type.split('.').reverse).join('/').camelize.constantize
    rescue
      Normalizers::Base
    end
  end

  protected

  def initial_event?(type)
    type.starts_with?('!')
  end
end
