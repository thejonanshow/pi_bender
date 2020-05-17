RSpec.describe PiBender::Configuration do
  let(:parsed_valid) {
    {"hosts"=>{
      "primary"=>{ "ip"=>"1.1.1.1", "nfs"=>{ "export"=>"/var/data" } },
      "drone1"=>{ "ip"=>"2.2.2.2", "nfs"=>{ "mount"=>"/var/data" } },
      "drone2"=>{ "ip"=>"2.2.2.2" }
    }}
  }
  let(:config) { test_config(parsed_valid.to_yaml) }

  context ".new" do
    it "validates the config" do
      expect(PiBender::Configuration).to receive(:validate!).once
      PiBender::Configuration.new("")
    end
  end

  context "#hostnames" do
    it "returns a list of the hostnames" do
      test_hosts = parsed_valid["hosts"].keys
      expect(config.hostnames).to eql(test_hosts)
    end
  end

  context "#settings_for_host" do
    it "returns only the settings for the supplied hostname" do
      target_hostname = parsed_valid["hosts"].keys.sample

      expect(
        config.settings_for_hostname(target_hostname)
      ).to eql(
        parsed_valid["hosts"][target_hostname]
      )
    end
  end

  context ".validate!" do
    context "with valid nfs settings" do
      it "doesn't raise an error" do
        expect { PiBender::Configuration.validate!(parsed_valid) }.not_to raise_error
      end
    end

    context "with invalid nfs settings" do
      it "raises an NFSError if more than one minion tries to export" do
        drone1_settings = parsed_valid["hosts"]["drone1"]
        invalid_drone1_settings = {
          "ip" => drone1_settings["ip"],
          "nfs" => {
            "export" => drone1_settings["nfs"]["mount"]
          }
        }

        invalid = parsed_valid
        invalid["hosts"]["drone1"] = invalid_drone1_settings

        expect { PiBender::Configuration.validate!(invalid) }.to raise_error(PiBender::Configuration::NFSError)
      end
    end
  end
end
