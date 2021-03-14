# Elasticsearch Pretty Profile

Pretty print an elasticsearch profile.

Iterate quickly from an irb/pry session. Use your own code to run Elasticsearch
queries and pretty print the full profile or only the slow operations.

Or when setting up Kibana is too troublesome.


## Install

Add this line to your application's Gemfile:

```ruby
gem "elasticsearch_pretty_profile"
```

Or install it yourself as:

    $ gem install elasticsearch_pretty_profile


## Usage

```ruby
require "elasticsearch"
client = Elasticsearch::Client.new
result = client.search(body: {profile: true})

require "elasticsearch_pretty_profile/espp"
espp result, over_ms: 50
# or
require "elasticsearch_pretty_profile"
ElasticsearchPrettyProfile.pp result, breakdown: true
```

Options:
 - `over_ms` - Filter output to operations slower than threshold. Default `1`.
 - `breakdown` - Include breakdown of operations. Default `true`.

Example output:
```
[ObNbzJLfQWaafS83U5b9lg][index][2]
 108ms BooleanQuery #ConstantScore(vehicle.state:UNBUILT) (106ms next_doc)
 397ms CancellableCollector search_cancelled
  365ms MultiCollector search_multi
   271ms MultiBucketCollector: [[term_agg_body_type, term_agg_feature, collapsed_total]] aggregation

 69ms GlobalOrdinalsStringTermsAggregator term_agg_body_type (55ms collect)
 256ms GlobalOrdinalsStringTermsAggregator term_agg_feature (118ms build_aggregation 137ms collect)
  181ms CardinalityAggregator uniq_by (178ms collect)

```

The first line is the shard ID which consists of the node ID, index name, and
shard number.

The next lines consist of searches (queries and collectors), then a blank line,
and finally aggregations. Indentation denotes it is a child of the previous
operation.

The lines follow this pattern:
 1. the time taken in milliseconds by the query, collector, or aggregation;
 2. the type of the query or aggregation, or the name of the collector;
 3. the description of the query or aggregation, or the reason of the collector;
 4. the breakdown of the operation in parentheses at the end;

The breakdown is a list of sub-operation names with the associated time in
milliseconds preceding it.

More shards will be separated by a blank line and follow the same pattern as
above.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.


## Release

To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to [rubygems.org].

[rubygems.org]: https://rubygems.org


## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/pchambino/elasticsearch_pretty_profile.
