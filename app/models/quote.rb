class Quote < Post
  attr_accessor :text, :source

  def font
    @quote_font ||= ['AmericanTypewriter', 'Futura-Medium', 'ChalkboardSE-Regular'].sample
  end
end
