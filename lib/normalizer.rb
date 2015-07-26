class Normalizer
  def initialize(record)
    @record = record
  end

  def normalize
    klass.normalize(@record)
  end

  def klass
    @klass ||= begin
                 (['normalizers'] + @record[:etype].split('.').reverse).join('/').camelize.constantize
               rescue
                 Normalizers::Base
               end
  end
end
