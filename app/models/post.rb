class Post

  attr_accessor :id, :post_url, :type, :timestamp, :date, :tags, :cell_view

  def initialize(attributes = {})
    attributes.each { |key, value|
      if self.respond_to?("#{key}=")
        self.send("#{key}=", value)
      end
    }
  end
end
