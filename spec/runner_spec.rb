RSpec.describe PiBender::Runner do
  context "#run" do
    let(:test_command) { "ls" }
    let(:runner) { PiBender::Runner.new(test_config).disable_io }

    it "raises a CallerError if #execute would be called from a test" do
      expect { runner.run(command: test_command) }.to raise_error(PiBender::Runner::CallerError)
    end

    it "executes exactly the supplied command" do
      expect(runner).to receive(:execute).with(test_command).once
      runner.run(command: test_command)
    end

    context "during a dry run" do
      let(:runner) { PiBender::Runner.new(test_config, dry_run: true).disable_io }

      it "outputs the supplied command" do
        expect(runner).to receive(:output).with(/#{test_command}/).once
        runner.run(command: test_command)
      end

      it "does NOT execute" do
        expect(runner).not_to receive(:execute)
        runner.run(command: test_command)
      end
    end
  end
end
