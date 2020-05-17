RSpec.describe PiBender::CLI do
  let(:parsed_valid) {
    {"hosts"=>{
      "primary"=>{ "ip"=>"1.1.1.1" },
      "drone1"=>{ "ip"=>"2.2.2.2" },
      "drone2"=>{ "ip"=>"2.2.2.2" }
    }}
  }
  let(:config) { test_config(parsed_valid) }
  let(:cli) { PiBender::CLI.new(config, test: true) }

  context "#prompt" do
    it "raises a PromptError if called without a block" do
      expect { cli.prompt }.to raise_error(PiBender::CLI::PromptError)
    end
  end
end
