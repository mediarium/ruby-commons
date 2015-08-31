class Object
  ##
  # TODO:
  def mp_deep_freeze
    proc_val = Proc.new {}

    proc_hsh = Proc.new do |k, v|
      proc_val.call(v)
    end

    proc_val = Proc.new do |v|
      case v
        when Hash
          v.each_value(&proc_hsh)
        when Array
          v.each(&proc_val)
        else
          # Do nothing ..
      end

      v.freeze
    end

    proc_val.call(self)
  end
end
