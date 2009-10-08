module Advocate #:nodoc:
  # Creates a very large matrix of all items using Pearson's Correlation
  class CorrelationMatrix
    
    class << self
      
      # An easier way to construct a correlation matrix.
      def import(obj)
        items = Items.import(obj)
        new(items)
      end
    end
    
    # The imported data items
    attr_reader :items

    # The actual correlations stored in a matrix
    attr_reader :matrix
    
    # The labeled data in the matrix.
    attr_reader :variables
    alias :labels :variables
    
    # Note: using just a Standard Library matrix since the RNum
    # optimizations don't seem to be involved with our brand of work today. 
    def initialize(items)
      raise ArgumentError, "Must supply an items dictionary." unless items.is_a?(Items)
      @items = items
      @variables = items.keys
      correlate_items unless items.values.any? {|e| e.empty?}
    end
    
    def correlate_items
      initialize_matrix
      self.items.values.each_with_index do |e, i|
        (i + 1...self.items.size).each do |j|
          other = self.items.values[j]
          cor = e.pearson_correlation(other)
          @matrix[i][j] = cor
          @matrix[j][i] = cor
        end
      end
    end
    
    def inspect
      "CorrelationMatrix: #{self.labels.inspect}"
    end
    
    def method_missing(sym, *args, &block)
      if self.variables.include?(sym)
        open_struct_for(sym)
      else
        super
      end
    end
    
    # External interface.  Can startup an empty items dictionary, load its
    # values, then process things after the fact.  Just remember that the
    # correlations won't be useful unless whatever items are available are
    # converted to a correlation matrix. 
    def process
      self.initialize_matrix
    end
    
    protected
      # Uses an array of arrays because 
      # 1) it's simple, 
      # 2) we're not using the optimizations offered in RNum
      # 3) it's a real pain to use the standard library matrix for these kinds of things 
      def initialize_matrix
        @matrix = []
        n = self.items.size
        n.times do |i|
          @matrix << Array.new(n, 0)
        end
      end
      
      def open_struct_for(sym)
        # KStruct is a little scrapy with its constructor
        k = KStruct.new(hash_except(sym))
        # k.merge!(hash_except(sym))
      end
      
      def index_for(sym)
        self.variables.index(sym)
      end
      
      def row_for(sym)
        self.matrix[index_for(sym)].dup
      end
      
      def row_except(sym)
        row = row_for(sym)
        row.delete_at(index_for(sym))
        row
      end
      
      def labels_except(sym)
        labels = self.labels.dup
        labels.delete_at(index_for(sym))
        labels
      end
      
      def hash_except(sym)
        return {} unless index_for(sym)
        row = row_except(sym)
        labels = labels_except(sym)
        hash = {}
        labels.each_with_index do |key, i|
          hash[key] = row[i]
        end
        hash
      end
      
    # An open struct that can return a dictionary of the best k fits
    class KStruct < OpenStruct

      def initialize(obj=nil)
        super
        hash = @table
        hash ||= {}
        @table = Dictionary.new
        @table.merge!(hash)
      end
      
      def table
        @table
      end

      def keys
        self.table.keys
      end

      def values
        self.table.values
      end

      def include?(key)
        self.keys.include?(key)
      end
      
      # Not sure if I'll use this yet.  It can be forced with kth_dictionary(k, true)
      # where k is the number of recommendations to make. 
      def filtered_values
        self.values.map do |e|
          if e.nan?
            0
          elsif e < 0
            0
          else
            e
          end
        end
      end
      
      # This is the core of everything.  Example:
      # @cm.some_value.knn(3) returns a dictionary of the 3 best recommendations available.
      # A correlation will be between -1 and 1.  I am ordering these in
      # reverse order, so that the higher numebers come first. 
      # The jury is still out about whether or not to ignore negative correlation.
      def kth_dictionary(k, filtered=false)
        indexes = self.values.indexes_for_best_k(k) {|a, b| b<=>a}
        dictionary = Dictionary.new
        indexes.each do |i|
          if filtered
            dictionary[self.keys[i]] = self.filtered_values[i]
          else
            dictionary[self.keys[i]] = self.values[i]
          end
        end
        dictionary
      end
      alias :knn :kth_dictionary
      alias :k_nn :kth_dictionary
    end
  end
  
  CM = CorrelationMatrix
end