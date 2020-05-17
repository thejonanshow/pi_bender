RSpec.describe PiBender::CLI do
  let(:parsed_valid) {
    {"hosts"=>{
      "primary"=>{ "ip"=>"1.1.1.1" },
      "drone1"=>{ "ip"=>"2.2.2.2" },
      "drone2"=>{ "ip"=>"2.2.2.2" }
    }}
  }
  let(:config) { test_config(parsed_valid.to_yaml) }
  let(:cli) { PiBender::CLI.new(config).disable_io }

  context "#prompt" do
    it "raises a PromptError if called without a block" do
      expect { cli.prompt(message: "") }.to raise_error(PiBender::CLI::PromptError)
    end
  end

  context "#set_passwords" do
    it "prompts for password and confirmation for each host" do
      prompt_count = parsed_valid["hosts"].length

      allow(cli).to receive(:prompt).and_return("fake_password")

      expect(cli).to receive(:prompt).exactly(6).times
      cli.set_passwords
    end
  end

  context "#create_minions" do
    it "returns a minion for each hostname in the config" do
      minions = cli.create_minions
      hostname_count = test_config.hostnames.length
      expect(minions.length).to eql(hostname_count)
    end
  end
end
