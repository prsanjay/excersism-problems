class WordProblem
  attr_reader :question

  OPERATORS = { 'plus' => '+', 'minus' => '-', 'multiplied' => '*', 'divided' => '/' }.freeze

  def initialize(question)
    @question = question
  end

  def answer
    @collection ||= collection
    raise ArgumentError if error_prone_input?(@collection)
    reduce_collection(@collection)
  end

  def collection
    splitted_array = question.gsub("?", "").split(" ")
    splitted_array.each_with_object([]) do |a, list|
      if operator?(a)
        list << OPERATORS[a]
      elsif number?(a)
        list << a.to_i
      end
    end.compact
  end

  def error_prone_input?(list)
    list.size == 1 || list.empty?
  end

  def operator?(ope)
    !OPERATORS[ope].nil?
  end

  def number?(string)
    !!(string =~ /\A[-+]?[0-9]+\z/)
  end

  def reduce_collection(collection)
    operands = collection.slice!(0..2) # get first 3 elements
    operator = operands.delete_at(1) # remove operator from array
    total = operands.reduce(:"#{operator}") # perform mathematical operation
    return total if collection.empty? # return if original collection empty
    collection.unshift(total) # add output of mathematical operation to first position
    reduce_collection(collection) unless collection.empty? # recursion until collection become empty
  end
end