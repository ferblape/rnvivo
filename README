# Nvivo API digester

A small Ruby class for consuming [Nvivo API](http://www.nvivo.es/api/index.php).

Requires (all them installable with `sudo gem install`):

  - rubygems
  - httparty
  - mocha
  - timeout
  
## How to use it

At the moment, only the method `getCityEvents` is implemented:

    events = Nvivo.new(NVIVO_API_KEY).cityGetEvents(city_name, iso_country_code)
    
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

 - implement the rest of the API methods

Copyright (c) 2009 [Fernando Blat](http://www.inwebwetrust.net), released under the MIT license
