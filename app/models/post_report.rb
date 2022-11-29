# frozen_string_literal: true

# note: This "class PostReport < Struct.new()" is the same as "PostReport = Struct.new() do"
# * This class is responsible for generating the report of the post, an is mainly used by the PostReportJob
PostReport = Struct.new(:word_count, :word_histogram) do
  def self.generate(post)
    # * Here we are calling the same class in order to create a report
    PostReport.new(
      post.content.split.map { |word| word.gsub(/\W/, '') }.count, # :word_count
      calc_histogram(post) # :word_histogram , we calculated using the below method
    )
  end

  def self.calc_histogram(post)
    post
      .content
      .split
      .map { |word| word.gsub(/\W/, '') }
      .map(&:downcase)
      .group_by { |word| word }
      .transform_values(&:size)
  end
end
