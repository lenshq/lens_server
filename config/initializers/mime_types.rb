Mime::Type.register 'gzip/json', :gzipjson

ActionDispatch::ParamsParser::DEFAULT_PARSERS[Mime::Type.lookup('gzip/json')] = lambda do |raw_body|
  body = ActiveSupport::Gzip.decompress(raw_body)
  JSON.parse(body).with_indifferent_access
end
