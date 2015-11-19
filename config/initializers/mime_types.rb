Mime::Type.register 'gzip/json', :gzipjson
ActionDispatch::ParamsParser::DEFAULT_PARSERS[Mime::Type.lookup('gzip/json')] = lambda do |raw_body|
  body = ActiveSupport::Gzip.decompress(raw_body)
  JSON.parse(body).with_indifferent_access
end

Mime::Type.register 'lz4/json', :lz4json
ActionDispatch::ParamsParser::DEFAULT_PARSERS[Mime::Type.lookup('lz4/json')] = lambda do |raw_body|
  body = LZ4::uncompress(raw_body)
  JSON.parse(body).with_indifferent_access
end

Mime::Type.register 'lz4hc/json', :lz4hcjson
ActionDispatch::ParamsParser::DEFAULT_PARSERS[Mime::Type.lookup('lz4hc/json')] = lambda do |raw_body|
  body = LZ4::uncompress(raw_body)
  JSON.parse(body).with_indifferent_access
end
