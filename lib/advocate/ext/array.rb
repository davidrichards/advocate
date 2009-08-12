class Array
  
  # Takes an optional sorting block.  Example:
  # {|a, b| b <=> a} # sorts in reverse order
  def best_k(k, &block)
    best_k = self[0...k]
    best_k.sort!(&block)
    remaining = self[k..-1]
    return best_k unless remaining
    remaining.each {|e| best_k.place!(e, &block)}
    best_k
  end
  
  def indexes_for_best_k(k, &block)
    bk = self.best_k(k, &block)
    all = bk.map do |e|
      self.find_indexes(e)
    end.flatten
    while all.size > k
      all.pop
    end
    all
  end
  
  # Uses a value or a block to evaluate whether a match is found.
  def find_indexes(val=nil, &block)
    block = lambda{|e| e == val} if val
    (0...self.size).inject([]) do |list, i|
      list << i if block.call(self[i])
      list
    end
  end
  alias :find_indices :find_indexes
  
  # Places a value in a sorted list if the value is less than any values
  # in the existing list.  Doesn't make the list any larger.  It's a way
  # to get k-sorted values out of a list. 
  # Assumes:
  # We are working with a sorted list, so front to back works
  # We are using the same sort in this method as was used to sort the list in the first place
  def place!(val, &block)
    pos = nil
    orig_size = self.size
    block ||= lambda{|a, b| a <=> b}
    self.each_with_index do |e, i|
      if block.call(e, val) == 1
        pos = i
        break
      end
    end
    return nil unless pos
    self.insert(pos, val)
    while self.size > orig_size
      self.pop
    end
    val
  end
  
end
