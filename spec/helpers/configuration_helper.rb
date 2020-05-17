def config_fixture
  File.read("spec/fixtures/example_config.yml")
end

def parsed_config_fixture
  YAML.load(config_fixture)
end

def test_config(file = nil)
  file ||= config_fixture
  PiBender::Configuration.new(file)
end
