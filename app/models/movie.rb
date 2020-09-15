class Movie < ActiveRecord::Base
    def self.all_ratings
        return %w{G PG PG-13 R}
    end

    def self.with_ratings(ratings)
        return Movie.where(:rating => ratings)
    end
end
