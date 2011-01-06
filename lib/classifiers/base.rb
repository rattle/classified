module Classified
  class Base
    def initialize
    end
    
    # This is used to convert the classifications used by the tests
    # into a format compatible with the classifier
    def transform(text)
      text
    end
  end
end
