# Swaggable

[![Gem Version](https://badge.fury.io/rb/swaggable.svg)](http://badge.fury.io/rb/swaggable)
[![Build Status](https://travis-ci.org/workshare/swaggable.svg)](https://travis-ci.org/workshare/swaggable)
[![Code Climate](https://codeclimate.com/github/workshare/swaggable/badges/gpa.svg)](https://codeclimate.com/github/workshare/swaggable)

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

Mount your rack app as `swagger.json` and you can point Swagger UI to it.


## Working with Grape

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

It supports status codes and entities. A more complex Grape example here:

```ruby
class TeamCreateEntity < Grape::Entity
  def self.name
    'create team payload'
  end

  expose :name, documentation: {
    type: 'String',
    desc: 'Name for the Team',
    required: true,
  }
end

class TeamsApi < Grape::API
  format :json
  content_type :json, 'application/json'
  version 'v1.0', using: :path, vendor: :workshare
  prefix "api"

  route_param :account_uuid do
    resource :teams do
      desc "Creates a new team for such account"

      params do
        requires :account_uuid, type: String, desc: 'UUID of the account to be associated with the new team'
      end

      codes = default_codes + [
        [201, 'Created'],
        [422, 'Validations failed'],
        [404, 'Account not found']
      ]

      post(http_codes: codes, entity: TeamCreateEntity) do
        ## Some action here...
      end
    end
  end
end

api_def = Swaggable::ApiDefinition.from_grape_api(TeamsApi)
rack_app = Swaggable::RackApp.new(api_definition: api_def)
```


## Validating the resultant Swagger JSON

Validate the results against the corresponding schema in your tests:

```ruby
it "validates" do
  expect(rack_app.validate!).to be true
end
```


## Working directly with the DSL

Define the API without Grape:

```ruby
Swaggable::ApiDefinition.new do
  version '1.0'
  title 'My API'
  description 'A test API'
  base_path '/api/1.0'

  endpoints.add_new do
    path '/users/{id}'
    verb :put
    description 'Updates an user'
    summary 'Updates attributes of such user'

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

    parameters.add_new do
      name 'user'
      description 'The new attributes for the user'
      location :body
      required true

      schema do
        name :user

        attributes do
          add_new do
            name :first_name
            type :string
          end
        end
      end
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

* Document classes.
* Include Redirector.
* Request & response validations.
* Response body schemas.

## Contributing

Do not forget to run the tests with:

```bash
bundle exec rake
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

