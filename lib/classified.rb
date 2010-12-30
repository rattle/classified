require 'corpus'
require 'classifier/base'
require 'classifier/ankusa'

module Classified
  class Classifier

    class InvalidClassifier < Exception; end
    
    VALID_CLASSIFIERS = [:ankusa]

    def self.create options = {}
      options = { :classifier => :ankusa }.merge!(options)
      raise InvalidClassifier unless VALID_CLASSIFIERS.include?(options[:classifier])

      case options[:classifier]
      when :ankusa
        return Classified::Ankusa.new(options)
      end
    end
  end
end
