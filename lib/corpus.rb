module Classified
  class Corpus

    def self.load_movie_reviews
      # See if we've already unpacked them
      base_dir = File.join(File.dirname(__FILE__), '..', 'test', 'corpora', 'movie_reviews')
      classification_count = { :negative => 0, :positive => 0}
      movie_review_corpus = []
      if File.directory?(File.join(base_dir, 'movie_reviews', 'neg'))
        ['negative', 'positive'].each do |classification|
          dir = File.join(base_dir, 'movie_reviews', classification[0,3])
          Dir[dir + "/*.txt"].each do |filename|
            movie_review_corpus << {:classification => classification.to_sym, :text => File.read(filename) }
            classification_count[classification.to_sym] +=1
          end
        end
      else
        Archive.read_open_filename(File.join(base_dir, 'movie_reviews.zip')) do |ar|
          while entry = ar.next_header
            name = entry.pathname
            if name =~ /\/$/
              FileUtils.mkdir_p File.join(base_dir, name)
              next
            end
            classification = name =~ /neg/ ? :negative : :positive
            text = ar.read_data
            movie_review_corpus << { :classification => classification, :text => text }
            file = File.join(base_dir, name)
            File.open(file, 'w') {|f| f.write(text) }
            classification_count[classification.to_sym] +=1
          end
        end
      end
      movie_review = { :training => [], :test => [] }
      count = { :positive => 0, :negative => 0}
      movie_review_corpus.each do |doc|
        count[doc[:classification]]+=1
        if count[doc[:classification]] > classification_count[doc[:classification]]*3/4
          # Add to test set
          movie_review[:test] << doc
        else
          # Add to training set
          movie_review[:training] << doc
        end
      end
      movie_review
    end

    def self.train_classifier classifier, corpus
      corpus.each do |doc|
        classifier.train doc[:classification], doc[:text]
      end
    end

    def self.test_classifier classifier, test_corpus
      alpha = 0.5
      total = correct = 0
      metrics = {}
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
          if classifier.classify(doc[:text]) == doc[:classification]
            scores[doc[:classification]][:true]+=1
          else
            scores[doc[:classification]][:false]+=1
          end
        end

        correct += scores[tc][:true]
        total += scores[tc][:true] + scores[tc][:false]
        metrics[tc][:precision] = scores[tc][:true].to_f / (scores[tc][:true] + scores[tc][:false])
        metrics[tc][:recall] = scores[tc][:true].to_f / (scores[tc][:true] + scores[fc][:false])
        metrics[tc][:fmeasure] = 1.0/(alpha/metrics[tc][:precision] + (1-alpha)/metrics[tc][:recall])
      end

      metrics[:accuracy] = correct.to_f / total
      metrics
    end

  end
end