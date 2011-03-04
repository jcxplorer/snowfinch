class CounterHash 
  def initialize(hash)
    @hash = hash
  end

  def [](key)
    if @hash[key]
      if @hash[key].is_a?(::Hash)
        self.class.new(@hash[key])
      else
        @hash[key]
      end
    else
      case key
      when "c"
        0
      else
        self.class.new({})
      end
    end
  end

  def method_missing(name, *args)
    @hash.send(name, *args)
  end
end
