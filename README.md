Snowfinch
=========

Snowfinch is a realtime web analytics application written in Ruby, and 
using MongoDB. It provides everything you need to track and visualize 
analytics from multiple sites. While – at the moment – it may not be as 
full featured as commercial alternatives, it is free and released under 
the MIT license.

At the moment, Snowfinch supports: number of pageviews, active visits, 
and visitors for a site; pageviews and active visitors for a given page; 
monitoring based on a URI query key-value pair, or based on any given 
number of referrers (think campaigns or tracking the number of visits 
from social media sites). It's not much, but this is only the beginning.  
Take a look at the Roadmap section to know what's coming.


Getting started
---------------

You will need recent versions of Ruby (1.9.2 recommended) and MongoDB.

If you don't have Bundler installed, install it with:

    gem install bundler

Clone the repository:

    git clone https://github.com/snowfinch/snowfinch.git

Edit the following files to suit your needs:

* `config/database.yml`
* `config/snowfinch.yml`

Some information is stored in a relational database, so you can use any 
that is supported by Rails. SQLite 3 might work out for you even in 
production, as it won't hold much data or be accessed often.

Install the application dependencies by running `bundle` in the 
application directory.

Run `rake db:setup` to create a database and an initial user.

You are now ready to launch the application using your favorite Ruby 
application server such as Passenger or Unicorn. Sign in with the email 
address _user@snowfinch.net_ and password _snowfinch_. Don't forget to 
change those credentials on your account page!


High performance and scaling
----------------------------

Are the pages you are tracking getting too many hits? Good for you!  
Fortunately you don't need to deploy entire instances of Snowfinch in 
multiple hosts. All data collection and storing is a done by a Rack 
application available as a gem. Just install the `snowfinch-collector` 
gem, and deploy using a `config.ru` file similar to the following 
example:

    require "snowfinch/collector"
    Snowfinch::Collector.db = Mongo::Connection.new.d)("snowfinch")
    run Snowfinch::Collector

Now you can deploy that on several hosts and get the web scale fix you 
were looking for. Throw some MongoDB shards at it as needed.

By default `snowfinch-collector` is mounted in the Rails application at 
"/collector" for easier deployment. If you run your own instance, 
remember to make sure that the MongoDB database is the same that the 
Rails application is using, and configure the URI to the collector in 
`config/snowfinch.yml`.

Just running one separate instance of `snowfinch-collector` will perform 
better than when mounted in the Rails application, as there will be no 
overhead from the Rails router and middleware.


Roadmap
-------

* Display data for any given period of time (currently the past 2 days).
* Collect and display referrer information.
* Custom visitor tagging.
* Geographic location of visitors.
* Filter by custom page metadata (e.g. for A/B testing).
* Asynchronous data collector.


Reporting bugs
--------------

If you think you found a bug, please file an issue on GitHub. Please try 
your best to provide steps on how to reproduce the issue you are 
experiencing. Failing tests are highly appreciated!


Contributing
------------

If you want to contribute, fork away and send a pull request. If you 
want to be sure something will be merged before spending time on it, 
feel free to contact me. Don't worry, hard work won't be thrown away.

Always try to provide tests with your pull requests. If you're not sure 
on how to test something, mention it on the pull request so that you can 
get some help.

I appreciate if you try to stick to the existing coding style, but I can 
always refactor later on. If you can stick to 80 characters a line, 
please do. If you don't yet, try it. It makes you write better code.


Copyright and licensing
-----------------------

Copyright 2011, João Cardoso. Snowfinch is released under the MIT 
license.
