RSpec.describe ElasticsearchPrettyProfile do
  describe "version" do
    subject(:version) { described_class::VERSION }

    it "is defined" do
      expect(version).to be_a String
    end
  end

  describe ".pp" do
    def pp(...)
      described_class.pp(...)
    end

    let(:profile) { JSON.parse File.read "spec/profiles/example.json" }
    let(:default_output) { File.read "spec/outputs/example_default.txt" }
    let(:over_50ms_output) { File.read "spec/outputs/example_over_50ms.txt" }
    let(:full_no_breakdown) { File.read "spec/outputs/example_full_no_breakdown.txt" }

    it "matches default output" do
      expect { pp profile }
        .to output(default_output).to_stdout
    end

    it "matches over 50ms output" do
      expect { pp profile, over_ms: 50 }
        .to output(over_50ms_output).to_stdout
    end

    it "matches full output without breakdown" do
      expect { pp profile, over_ms: 0, breakdown: false }
        .to output(full_no_breakdown).to_stdout
    end
  end

  describe "espp" do
    it "is defined" do
      require "elasticsearch_pretty_profile/espp"
      expect(Kernel).to respond_to :espp
    end
  end
end
