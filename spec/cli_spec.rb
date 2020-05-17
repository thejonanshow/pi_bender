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
  let(:test_password) { "fake_password" }

  context "#prompt" do
    it "raises a PromptError if called without a block" do
      expect { cli.prompt(message: "") }.to raise_error(PiBender::CLI::PromptError)
    end

    context "with invalid input" do
      it "prompts again" do
        test_message = "Test prompt"
        allow(cli).to receive(:input).and_return("", test_password)
        allow(cli).to receive(:output).with("Invalid response.").once

        expect(cli).to receive(:output).with(test_message).twice
        cli.prompt(message: "Test prompt") { |response| !response.empty? }
      end
    end
  end

  context "#set_passwords" do
    it "prompts for password and confirmation for each host" do
      prompt_count = parsed_valid["hosts"].length

      allow(cli).to receive(:prompt).and_return(test_password)

      expect(cli).to receive(:prompt).exactly(6).times
      cli.set_passwords
    end

    it "uses input_secure to prompt" do
      allow(cli).to receive(:input).and_return(test_password)
      expect(cli).to receive(:input_secure).and_return(test_password).at_least(:once)
      cli.set_passwords
    end

    it "never uses input" do
      allow(cli).to receive(:input_secure).and_return(test_password)
      expect(cli).not_to receive(:input)
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
