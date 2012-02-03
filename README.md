# Verver

Automating our build environments should be easier.

[We][versionone-team] have a large CI environment in which various jobs
have to install, configure, and uninstall our application. Some jobs
also install, restore, and tear-down databases while running test or
deploying the application to test environments. There is a lot to do.

Verver was extracted from a number of Rake tasks we had grown up over
the years. It is an attempt to centralize and abstract away the boring,
complicated, or overly-generic details found across our codebases and
their Rake tasks.

## Installation

__NOTE:__ gem install only works if we push this to RubyGems.org
Add this line to your application's Gemfile:

    gem 'verver'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install verver

## Usage

Verver has couple of primary objects and modules. They are:

### Verver::Instance

An abstraction over an instance of the VersionOne Appliation.

    require 'verver/instance'

    app = Verver::Instance.new # use the defaults
    app.name #=> Jenkins job name and build number
    app.path #=> 'C:\inetpub\wwwroot\' + instance name
    app.database_name #=> instance name
    app.database_server #=> '(local)'
    app.installer #=> first 'VersionOne.Setup*.exe' found in root dir
    app.license #=> 'VersionOne.dev.lic' file found in root dir

    # All of these can be overridden. For example:
    Verver::Instance.new(
      :name => 'Bob-Job',
      :database_server => 'YourSqlServer',
      :license => File.join("C:", "licenses", "my.lic")
    )

Once you have an instance, you can install and uninstall it, and its
database, license file, etc. with:

    app.install!
    app.uninstall!

In cases where you need to install the app, then do something to/with it
(like run Cucumber specs), and then want to ensure the app gets
uninstalled, you can use:

    require 'verver/instance'

    Verver::Instance.execute( :name => 'Bob-Job') do |app|
      # Do something against the app here.
    end

### Verver::IIS

Automated management of IIS, in particular `Verver::IIS::AppPool`
can start, stop, recycle, etc., app pools.

    require 'verver/iis'

    app_pool = Verver::IIS::AppPool.new('DefaultAppPool')

    app_pool.stop unless app_pool.stopped? || app_pool.stopping?
    app_pool.start
    app_pool.recycle

### Verver::Jenkins

Provides a consisten interface for getting information out of a
Jenkins Job. This could be extended in the future to allow controlling
and creating Jenkins jobs.

    require 'verver/jenkins'

    Verver::Jenkins.job_name #=> 'some-job-name'
    Verver::Jenkins.build_number #=> 321

Typically, this information is used inside of other objects, like
`Verver::Instance` for getting sensible defaults.

### Verver::Document

A simple abstraction over Erb templating.

    # /path/to/template.erb
    #    Hi, my name is <%= name %>, and I am <%= age %> years old.

    require 'verver/document'

    doc = Verver::Document.new('/path/to/template.erb')
    doc.interpolate(:name => 'Bob', :age => 42) #=> Hi, my name is Bob, and I am 42 years old.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Make sure all of the specs pass! (`rake spec`)
4. Commit your changes (`git commit -am 'Added some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

## Also....

Much of this Gem is very specific to the needs of
[VersionOne][versionone], but there are some generally applicable
things, like `Verver::Document` and all of the `Verver::IIS` automation
wrappers. Perhaps this Gem should be stripped down to just the generic
stuff, with a new Gem, `verver-versionone` laying the
VersionOne-specific things atop it? Feel free to fork and make-it-so, if
we don't get to it first.

[versionone]: http://versionone.com
[versionone-team]: http://github.com/versionone
