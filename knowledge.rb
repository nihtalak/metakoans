class Object
  def attribute(name, value = nil, &block)
    unless name.is_a? Hash
      define_method(name) do
        unless instance_variable_defined?("@#{name}")
          instance_variable_set("@#{name}", send("_#{name}"))
        else
          instance_variable_get("@#{name}")
        end
      end

      define_method("#{name}?") do
        !! send("#{name}") 
      end

      define_method("#{name}=") do |v|
        instance_variable_set("@#{name}", v)
      end

      define_method("_#{name}") do
        block_given? ? instance_exec(&block) : value
      end
    else
      name.each { |key, value| attribute(key, value) }
    end
  end
end