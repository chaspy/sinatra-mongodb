# sinatra-mongodb
Sample sinatra application with MongoDB from [はじめての MongoDB](https://www.kohgakusha.co.jp/books/detail/978-4-7775-1962-0)

## Usage
Deploy MongoDB.

I used [chaspy/mongodb-vagrant](https://github.com/chaspy/vagrant-mongodb)

Set $MONGO_HOST and $MONGO_PORT as environment variable.

```
$ cp .envrc.sample .envrc
$ . .envrc
$ ruby bookshelf.rb
```

See `localhost:4567` in your browser.
