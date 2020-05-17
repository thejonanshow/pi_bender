def test_config(parsed)
  PiBender::Configuration.new("{}").tap do |c|
    c.load(parsed.to_yaml)
  end
end
