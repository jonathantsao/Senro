# Senro

Senro is a Ruby Controller and Views framework that uses a Postgresql database. Senro was inspired by Ruby on Rails.

## Key Features

### SenroController


Controllers that inherit from SenroController have the following methods:

* `render(template_name)`: renders a template within the views folder with the corresponding controller name.
* `render_content(content, content_type)`: renders using a custom content type.
* `redirect_to(url)`: redirects to the specified url.
* `session`: accesses the session hash containing the session cookie.
* `flash` and `flash.now`: accesses the hash containing errors that persist through the next session and the current session, respectively.

You can also add `protect_from_forgery` to your custom controllers to protect from CSRF attacks. Add the following input tag to your form:

```html
  <input type="hidden"
  name="authenticity_token"
  value="<%= form_authenticity_token %>">
```
Then, by having `protect_from_forgery` in your custom controllers, Senro will check for the above authenticity token.

### Router

The `Router` can be used to map routes between the controllers and the views.

```Ruby
router = Router.new
router.draw do
  get Regexp.new("^/movies$"), MoviesController, :index
  post Regexp.new("^/movies$"), MoviesController, :create
  get Regexp.new("^/movies/(?<movie_id>\\d+)/Actors$"), ActorsController, :index
end
```
### Added Rack Middleware

* `Exceptions` were added to provide a detailed description of the Ruby source error. This was intended to provide information to developers in the development environment.

* `Static` were added to allow for the rendering of a static asset from the `/public` folder. Currently, .jpg, .png, .htm, .html, .txt, and .zip extensions are supported.

## How to run Example App

1. Make sure [Ruby](https://www.ruby-lang.org/en/) is up-to-date
1. `git clone https://www.github.com/jonathantsao/senro.git`
1. `cd Senro`
1. `bundle install`
1. `ruby fruits.rb`
1. Go to `http://localhost:3000`
