# Swaggable

Flexible swagger documentation generation tool.
Allows building a Rack application that 
serves [Swagger 2](http://swagger.io/) documentation 
from [Grape](https://github.com/intridea/grape) APIs.


## Getting Started

```ruby
# my_rack_app.rb
require 'swaggable'

api_def = Swaggable::ApiDefinition.from_grape_api(UsersApi)
rack_app = Swaggable::RackApp.new(api_definition: api_def)
```

You can import several Grape APIs:

```ruby
Swaggable::GrapeAdapter.new.import(UsersApi, api_def)
Swaggable::GrapeAdapter.new.import(CommentsApi, api_def)
```

You can tweak the generated ApiDefinition directly:

```ruby
api_def.title = 'My Service'
api_def.description = 'Does stuff.'
api_def.endpoints['GET /users/{id}'].description = 'Show user'
api_def.endpoints['GET /users/{id}'].tags['Users'].description = 'Users resource'
api_def.endpoints['GET /users/{id}'].parameters['filter'].description = 'Allows filtering'
api_def.endpoints['GET /users/{id}'].responses[403].description = 'Forbidden'
```

Validate the results against the corresponding schema in your tests:

```ruby
it "validates" do
  expect(rack_app.validate!).to be true
end
```

Define the API without Grape:

```ruby
api = Swaggable::ApiDefinition.new do
  version '1.0'
  title 'My API'
  description 'A test API'
  base_path '/api/1.0'

  endpoints.add_new do
    path '/users/{id}'
    verb :get
    description 'Shows an user'
    summary 'Returns the JSON representation of such user'

    tags.add_new do
      name 'Users'
      description 'Users resource'
    end

    parameters.add_new do
      name 'include_comments_count'
      description 'It will return the comments_count attribute when set to true'
      location :query # [:path, :query, :header, :body, :form, nil]
      required false
      type :boolean # [:string, :number, :integer, :boolean, :array, :file, nil]
    end

    responses.add_new do
      status 200
      description 'Success'
    end

    responses.add_new do
      status 404
      description 'User not found'
    end

    consumes << :json
    produces << :json
  end
end
```

## TODO

* Support response specs.
* Document classes.
* Include Redirector.
* DSL.
* Swagger validation.
* Request & response validations.
* Entities & schemas.


## Contributing

Do not forget to run the tests with:

```bash
rake
```


And bump the version with any of:

```bash
$ gem bump --version 1.1.1       # Bump the gem version to the given version number
$ gem bump --version major       # Bump the gem version to the next major level (e.g. 0.0.1 to 1.0.0)
$ gem bump --version minor       # Bump the gem version to the next minor level (e.g. 0.0.1 to 0.1.0)
$ gem bump --version patch       # Bump the gem version to the next patch level (e.g. 0.0.1 to 0.0.2)
```


## License

Released under the MIT License.
See the [LICENSE](LICENSE.txt) file for further details.

