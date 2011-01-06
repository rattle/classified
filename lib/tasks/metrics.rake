require 'pp'
require 'rubygems'
require 'rake'
Bundler.require(:default, :metrics)
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..' ))
require 'classified'
include Classified

namespace :metrics do

  task :evaluate, :corpus do |t, args|
    args.with_defaults(:corpus => 'movie_reviews')
    puts "Loading corpus #{args[:corpus]}"
    corpus = nil
    case args[:corpus]
    when 'movie_reviews'
      corpus = Corpus::Utils.load_movie_reviews
    when 'twitter_sentiment'
      corpus = Corpus::Utils.load_twitter_sentiment
    end
    
    puts
    Classifiers::VALID_CLASSIFIERS.each do |c|
      classifier = Classifiers.create(:classifier => c)
      puts "Analysing classifier: #{c}"
      Metrics.train_classifier classifier, corpus[:training]
      puts
      metrics = Metrics.test_classifier classifier, corpus[:test]
      puts
      Metrics.summary(classifier, metrics)
    end
  end

  task :all do
    Rake::Task['metrics:evaluate'].invoke('movie_reviews')
  end
  
end
