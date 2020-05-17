RSpec.describe PiBender::Minion do
  context "#set_password" do
    let(:minion) { PiBender::Minion.new(hostname: "host", settings: {}) }

    it "sets the hashed password on the minion" do
      minion.set_password("fake_password")
      expect(minion.hashed_password).to_not be_empty
    end

    context "with an empty password" do
      it "raises a password error" do
        expect { minion.set_password("") }.to raise_error(PiBender::Minion::PasswordError)
      end
    end
  end
end
