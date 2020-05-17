require "bundler/setup"
require "pi_bender"
require "helpers/configuration_helper"
require "helpers/cli_helper"
require "helpers/fake_client"
require "helpers/fake_http"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
