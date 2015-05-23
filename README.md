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
```


## TODO

* Document classes.
* Include Redirector.
* Improved collections.
* DSL.
* API Validations.
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

