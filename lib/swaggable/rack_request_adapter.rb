module Swaggable
  class RackRequestAdapter
    def initialize env
      @env = env || raise("env hash is required")
    end

    def [] key
      env[key]
    end

    private

    attr_reader :env
  end
end
