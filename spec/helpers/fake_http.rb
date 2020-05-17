module PiBender
  module SpecHelpers
    class FakeHTTP
      include FakeClient

      def head(url)
      end

      def get(url)
      end
    end
  end
end

def test_http
  PiBender::SpecHelpers::FakeHTTP.new
end
