require 'corpus/utils'
require 'metrics'
require 'classifiers/base'
require 'classifiers/ankusa'
require 'classifiers/hoatzin'
require 'classifiers/classifier_bayes'
require 'classifiers/classifier_lsi'

module Classified
  class Classifiers

    class InvalidClassifier < Exception; end

    VALID_CLASSIFIERS = [:classifier_bayes, :ankusa, :hoatzin] # :classifier_lsi

    def self.create options = {}

      options = { :classifier => :ankusa }.merge!(options)
      raise InvalidClassifier unless VALID_CLASSIFIERS.include?(options[:classifier])

      case options[:classifier]
      when :ankusa
        return Classified::Ankusa.new(options)
      when :hoatzin
        return Classified::Hoatzin.new(options)
      when :classifier_bayes
        return Classified::ClassifierBayes.new(options)
      when :classifier_lsi
        return Classified::ClassifierLSI.new(options)
      end
    end
  end
end
