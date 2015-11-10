class ServiceLocator
  @settings = {}

  def self.setup(&block)
    block.call(self)
  end

  def self.method_missing(m, *args)
    key = m.to_s

    if key.delete!('=')
      @settings[key] = args[0].call
    else
      @settings[key]
    end
  end
end
