RSpec.describe PiBender::Configuration do
  context "#validate!" do
    let(:parsed_valid) {
      {"hosts"=>{
        "primary"=>{ "ip"=>"1.1.1.1", "nfs"=>{ "export"=>"/var/data" } },
        "drone1"=>{ "ip"=>"2.2.2.2", "nfs"=>{ "mount"=>"/var/data" } },
        "drone2"=>{ "ip"=>"2.2.2.2" }
      }}
    }
    let(:file) { "{}" }
    let(:config) { PiBender::Configuration.new(file) }

    context "with valid nfs settings" do
      it "doesn't raise an error" do
        expect { config.load(parsed_valid.to_yaml) }.not_to raise_error
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

        config.load(invalid.to_yaml)
        expect { config.validate! }.to raise_error(PiBender::Configuration::NFSError)
      end
    end
  end
end
