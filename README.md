# Nvivo API digester

A small Ruby class for consuming [Nvivo API](http://www.nvivo.es/api/index.php).

## Dependencies

Just run `bundle install`.

## How to use it

Once you have your API Key, just initalize the client and run the methods you want:

    nvivo = Nvivo.new NVIVO_API_KEY
    events = nvivo.cityGetEvents('Madrid')

It returns an array of hashes with the name and the nvivo URL of each one:

    'events' => {
      'event' => [
        {
          'name' => 'Wadus event',
          'url' => 'http://wadus.com/wadus-event'
        },
        {
          'name' => 'Wadus event 2',
          'url' => 'http://wadus.com/wadus-event-2'
        }
      ]
    }

Very simple.

## TODO

 - refactor, refactor, refactor

## Special thanks

- Sergio Arbeo [@serabe](https://twitter.com/serabe) for his PRs

- Nvivo team. They are really nice!

Copyright (c) 2009 [Fernando Blat](http://fernando.blat.es), released under the MIT license
