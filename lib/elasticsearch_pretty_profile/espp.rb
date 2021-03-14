# frozen_string_literal: true

require "elasticsearch_pretty_profile"

module Kernel
  def espp(...)
    ElasticsearchPrettyProfile.pp(...)
  end
end
