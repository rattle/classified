module Classified
  class Metrics
    
    def self.train_classifier classifier, corpus
      puts "Training"
      start_time = Time.now
      corpus.each do |doc|
        classifier.train doc[:classification], doc[:text]
      end
      # Call a classify action to force an syncing in the classifier to occur
      classifier.classify("It's rubbish")
      #classifier.save(:metadata => './metadata', :model => './model')
      puts "Took #{Time.now-start_time} secs : training #{corpus.length} docs"
    end

    def self.test_classifier classifier, test_corpus
      alpha = 0.5
      total = correct = 0
      metrics = {}

      puts "Getting metrics"
      start_time = Time.now

      classifier.classifications.each do |c|
        # tc - true class
        # fc - false class
        tc = c
        fc = classifier.classifications.clone
        fc.delete(tc)
        fc = fc.first
        metrics[tc] = { :precision => 0, :recall => 0, :fmeasure => 0 }
        scores = {}
        classifier.classifications.each do |classification|
          scores[classification] = { :true => 0, :false => 0 }
        end
        test_corpus.each do |doc|
          c = classifier.transform(doc[:classification])
          if classifier.classify(doc[:text]) ==  c
            scores[c][:true]+=1
          else
            scores[c][:false]+=1
          end
        end
        correct += scores[tc][:true]
        total += scores[tc][:true] + scores[tc][:false]
        metrics[tc][:precision] = scores[tc][:true].to_f / (scores[tc][:true] + scores[tc][:false])
        metrics[tc][:recall] = scores[tc][:true].to_f / (scores[tc][:true] + scores[fc][:false])
        metrics[tc][:fmeasure] = 1.0/(alpha/metrics[tc][:precision] + (1-alpha)/metrics[tc][:recall])
      end

      metrics[:correct] = correct
      metrics[:total] = total
      metrics[:accuracy] = correct.to_f / total
      metrics[:duration] = Time.now-start_time

      puts "Took #{metrics[:duration]} secs"

      metrics
    end

    def self.summary(classifier, metrics)
      puts "average classification time = #{metrics[:duration]/metrics[:total].to_f} secs"
      puts "total classifications = #{metrics[:total]}"
      puts "correct classifications = #{metrics[:correct]}"
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