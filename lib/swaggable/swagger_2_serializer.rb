module Swaggable
  class Swagger2Serializer
    def serialize api
      {
        swagger: '2.0',
        basePath: api.base_path,
        info: {
          title: api.title,
          description: api.description,
          version: api.version,
        },
      }
    end
  end
end
