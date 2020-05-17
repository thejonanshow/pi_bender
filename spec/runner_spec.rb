RSpec.describe PiBender::Runner do
  context "#run" do
    let(:test_command) { "ls" }
    let(:runner) { PiBender::Runner.new(test_config).disable_io }

    it "raises a CallerError if #execute would be called from a test" do
      expect { runner.run(command: test_command) }.to raise_error(PiBender::Runner::CallerError)
    end

    it "executes the supplied command" do
      expect(runner).to receive(:execute).with(test_command).once
      runner.run(command: test_command)
    end
  end
end
