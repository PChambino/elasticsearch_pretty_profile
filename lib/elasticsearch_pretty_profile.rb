# frozen_string_literal: true

module ElasticsearchPrettyProfile
  autoload :VERSION, "elasticsearch_profile_pp/version"

  def self.pp(result, over_ms: 1, breakdown: true)
    PrettyProfile.new(result, over_ms: over_ms, breakdown: breakdown)
      .pretty_print
  end

  class PrettyProfile
    def initialize(result, over_ms:, breakdown:)
      @result = result
      @over_ms = over_ms
      @breakdown = breakdown
    end

    def pretty_print
      profile = @result["profile"]
      return unless profile

      profile["shards"]&.each do |shard|
        puts shard["id"]

        shard["searches"]&.each do |search|
          search["query"]&.each { |op| pp_operation op }
          search["collector"]&.each { |op| pp_operation op }

          rewrite_time = ns_to_ms search["rewrite_time"]
          puts " #{rewrite_time}ms rewrite" unless rewrite_time < @over_ms
          puts
        end

        shard["aggregations"]&.each { |op| pp_operation op }
        puts
      end

      nil
    end

    private

    def ns_to_ms(nanos)
      return 0 unless nanos

      nanos / 1000 / 1000
    end

    def pp_operation(op, indent = 0)
      time = ns_to_ms op["time_in_nanos"]
      return if time < @over_ms

      puts [
        " " * indent,
        "#{time}ms",
        op["type"] || op["name"],
        op["description"] || op["reason"],
        pp_breakdown(op["breakdown"])
      ].compact.join " "

      op["children"]&.each { |child| pp_operation child, indent + 1 }
    end

    def pp_breakdown(bd)
      return unless @breakdown

      operations = bd&.map do |name, value|
        time = ns_to_ms(value)
        next if time < @over_ms

        "#{time}ms #{name}"
      end&.compact

      "(#{operations.join " "})" if operations&.any?
    end
  end
  private_constant :PrettyProfile
end
