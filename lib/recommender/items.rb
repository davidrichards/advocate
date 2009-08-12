module Recommender #:nodoc:
  
  # A list of named items that is implemented with a Dictionary.  I just
  # make sure that the dictionary only contains arrays in it, so that the
  # correlation matrix can be built from this. 
  class Items < Dictionary
    
    class << self
      def import(obj)
        items = new
        items.import(obj)
        items
      end
    end
    
    def import(obj=nil)
      case obj
      when Hash
        self.merge!(obj)
      when DataFrame
        hash = obj.to_hash
        obj.variables.each do |variable|
          hash[variable] ||= []
        end
        self.merge!(hash)
      when Array
        # Sets up the variables/keys
        obj.each do |key|
          self[key] ||= []
        end
      when Dictionary
        self.merge!(obj)
      else
        raise ArgumentError, "Don't know how to build an items list from #{obj.inspect}"
      end
    end
    
    def []=(index, value)
      raise ArgumentError, "Can only supply arrays to the items list." unless value.is_a?(Array)
      super
    end
    
    # For some consistency
    alias :variables :keys
    
  end
end
