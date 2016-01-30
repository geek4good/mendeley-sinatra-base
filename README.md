# Mendeley Ruby Example

This is an example of how to consume the Mendeley API in a Ruby web application. It's only intention is to get you going straight away without having to deal with authentication or authorisation – at least not at the beginning. As the name suggests, it's based on the [Sinatra microframework](https://github.com/sinatra/sinatra). So there should be enough [documentation](http://www.sinatrarb.com/intro.html) around to help you build something useful.

## Installation

Simply clone or fork this repository.

## Usage

First, if you don't have one already, you need to [create a Mendeley account](https://www.mendeley.com/join/). Next, you have to [register the application](http://dev.mendeley.com/reference/topics/application_registration.html) you're about to build.

You can freely choose the application name and description. Please use `http://localhost:9393/auth/callback` as redirect URL. After submitting the form you'll receive your client ID and client secret. Make sure to keep these safe at all time.

Copy the file `config.yml.example` to `config.yml` and put your credentials into the newly created file. The file `config.yml` is listed in the `.gitignore` file so that you don't accidentally commit and publish your credentials.

In the base directory of your new app, i.e. where `app.rb` and your new `config.yml` are located, run `bundle install`. Once all the required libraries are installed. Run `bundle exec shotgun config.ru` this will start the web application. When you go to `http://localhost:9393/profile` you'll be taken through the authorisation flow. As a result you should be redirected back to your new application, which will display your profile data as JSON. You're now ready to start developing your application. Whenever you change `app.rb` the web server automatically reloads the application. So you should see changes you make straight away by simply hitting the reload button in your browser.

Making an API request is simple. Once you've completed the authorisation, you have an access token at your disposal. Just think of the access token as of an authorised http client. You can use it to make all the [API calls](https://api.mendeley.com/apidocs), e.g.:

```ruby
res = token.get("/profiles/me")
res.body
```

## Troubleshooting

Should you at some point encounter an error message that says you're token has expired, just open the web development console in your browser, go to *Resources* and delete the cookie called *rack.session* from *localhost*. The cleaner solution would be to implement the refresh token flow, of course. So please feel free to do that instead and open a pull request against the upstream repository. ;)