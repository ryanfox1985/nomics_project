# frozen_string_literal: true

class CurrencyService
  class << self
    class Error < StandardError; end

    def metadata(options)
      http_get_request(verb: 'currencies', **options)
    end

    def ticker(options)
      http_get_request(verb: 'currencies/ticker', **options)
    end

    def sparkline(options)
      args = { **options, start: parse_date(options[:start].presence || Date.today.prev_day) }
      args[:end] = parse_date(options[:end]) if options[:end].present?

      http_get_request(verb: 'currencies/sparkline', **args)
    end

    def rate_conversion(ids:, **options)
      raise Error('Bad parameters, ids should be two elements') if Array(ids).size != 2

      args = { start: Date.today.prev_day, **options }

      rates = ids.map do |id|
        sparkline(ids: id, **args).first['prices'].first.to_f
      end

      { 'ids' => ids, 'start' => args[:start], 'rate' => rates[0] / rates[1] }
    end

    private

    def default_nomics_key
      ENV['NOMICS_KEY']
    end

    def default_nomics_endpoint
      ENV['NOMICS_ENDPOINT'] || 'https://api.nomics.com/v1/'
    end

    def http_get_request(verb:, ids:, endpoint: default_nomics_endpoint, key: default_nomics_key, **parameters)
      uri = URI("#{endpoint}#{verb}")
      uri.query = URI.encode_www_form(key: key, ids: Array(ids).join(','), **parameters)

      sleep(1) # TODO: remove this line, free account limitation
      res = Net::HTTP.get_response(uri)
      return JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)

      raise Error, "Unexpected nomics response: #{res.code}, #{res.body}"
    end

    # RFC3339
    def parse_date(date)
      if date.instance_of?(String)
        DateTime.parse(date)
      else
        date
      end.strftime('%FT%TZ')
    end
  end
end
