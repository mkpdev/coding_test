class LokaliseService
  attr_reader :client, :project_id

  def initialize
    @client = Lokalise.client('79f58e3b769ce941f75bab97d7fb17f118cf5524')
    @project_id = '296344285ec22d64085400.99297850'
  end

  def generate_keys(json, parent = 'BMI')
    keys = {}

    json.each do |key, value|
      if value.is_a?(String)
        keys["#{parent}_#{key}"] = value
      elsif value.is_a?(Hash)
        hsh = generate_keys(value, "#{parent}_#{key}")
        keys.merge!(hsh) if hsh.values.all? { |v| v.is_a?(String) }
      end
    end
    keys.presence
  end

  def create_keys(json)
    client.create_keys(project_id, keys_params(json))
  end

  def keys_params(json)
    generate_keys(json).map do |k, v|
      { "key_name": k, "platforms": ["ios", "android", "web", "other"], "translations": [{ "language_iso": "en", "translation": v }] }
    end
  end
end
