def test_cli(http: nil)
  config = test_config
  http ||= PiBender::SpecHelpers::FakeHTTP.new
  PiBender::CLI.new(config, http: http).disable_io
end
