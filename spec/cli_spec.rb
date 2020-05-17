RSpec.describe PiBender::CLI do
  let(:parsed_valid) {
    {"hosts"=>{
      "primary"=>{ "ip"=>"1.1.1.1" },
      "drone1"=>{ "ip"=>"2.2.2.2" },
      "drone2"=>{ "ip"=>"2.2.2.2" }
    }}
  }
  let(:config) { test_config(parsed_valid.to_yaml) }
  let(:cli) { test_cli }
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

  context "#set_authorized_keys" do
    it "prompts for a GitHub username" do
      allow(cli).to receive(:fetch_keys)

      expect(cli).to receive(:prompt).with(message: /GitHub/)
      cli.set_authorized_keys
    end

    it "sets the keys on the minions" do
      allow(cli).to receive(:username_valid?).and_return(true)
      allow(cli).to receive(:fetch_keys).and_return([])

      expect(cli).to receive(:set_keys_on_minions)
      cli.set_authorized_keys
    end
  end

  context "#set_keys_on_minions" do
    let(:keys) { ["KEY1", "KEY2"] }

    it "sets the keys on each minion" do
      allow(cli).to receive(:username_valid?).and_return(true)
      allow(cli).to receive(:fetch_keys).and_return(keys)

      cli.minions.each do |minion|
        expect(minion).to receive(:set_keys).with(keys)
      end

      cli.set_authorized_keys
    end
  end

  context "with the HTTP client" do
    let(:http) { test_http }
    let(:cli) { test_cli(http: http) }
    let(:username) { "fake_github_user" }

    context "#username_valid?" do
      let(:response) { double("HTTPResponse", status: 200) }

      it "makes a head request" do
        expect(http).to receive(:head).and_return(response)
        cli.username_valid?(username)
      end

      it "returns true if the response status is 200" do
        allow(http).to receive(:head).and_return(response)
        expect(cli.username_valid?(username)).to be(true)
      end

      it "returns false if the response status is not 200" do
        failed_response = double("FailedHTTPResponse", status: 404)
        allow(http).to receive(:head).and_return(failed_response)
        expect(cli.username_valid?(username)).to be(false)
      end
    end

    context "#fetch_keys" do
      let(:response) { double("GET Response", body: "") }

      it "makes a get request" do
        expect(http).to receive(:get).and_return(response)
        cli.fetch_keys(username)
      end

      it "returns a single key from the response body" do
        keys = "ssh-rsa FAKE1\n"
        response = double("GET Reponse", body: keys)
        allow(http).to receive(:get).and_return(response)

        expect(cli.fetch_keys(username).length).to eql(1)
      end

      it "returns multiple keys from the response body" do
        keys = "ssh-rsa FAKE1\nssh-rsa FAKE2\n"
        response = double("GET Response", body: keys)
        allow(http).to receive(:get).and_return(response)

        expect(cli.fetch_keys(username).length).to be > 1
      end
    end
  end
end
