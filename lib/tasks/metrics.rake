require 'pp'
require 'rubygems'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..' ))
require 'classified'
include Classified

namespace :classified do
  namespace :metrics do

    task :all => [ "movie_reviews" ] do
    end

    task :movie_reviews do
      puts "Loading corpus movie_reviews"
      start_time = Time.now
      corpus = Corpus.load_movie_reviews
      puts "Took #{Time.now-start_time} secs : training #{corpus[:training].length} docs, testing #{corpus[:test].length} docs"
      puts
      Classifier::VALID_CLASSIFIERS.each do |c|
        puts "Analysing classifier: #{c}"
        classifier = Classifier.create(:classifier => c)
        puts "Training"
        start_time = Time.now
        Corpus.train_classifier classifier, corpus[:training]
        puts "Took #{Time.now-start_time} secs"
        puts "Getting metrics"
        metrics = Corpus.test_classifier classifier, corpus[:test]
        puts "Took #{Time.now-start_time} secs"
        puts
        puts "accuracy = #{metrics[:accuracy]}"
        classifier.classifications.each do |classification|
          puts "#{classification} classification metrics"
          metrics[classification].each_key do |metric|
            puts "\t#{metric} = #{metrics[classification][metric]}"
          end
          puts
        end
      end
    end
  end
end
      


