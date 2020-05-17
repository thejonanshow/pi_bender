def config_fixture
  File.read("spec/fixtures/example_config.yml")
end

def parsed_config_fixture
  YAML.parse(config_fixture)
end

def test_config(parsed = nil)
  parsed ||= config_fixture
  PiBender::Configuration.new("{}").tap do |c|
    c.load(parsed.to_yaml)
  end
end
