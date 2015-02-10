Build status: [![Circle CI](https://circleci.com/gh/cucumber/cucumber-ruby-tcl/tree/master.svg?style=svg)](https://circleci.com/gh/cucumber/cucumber-ruby-tcl/tree/master)

Cucumber Tcl
============

Drive your Tcl code with Cucumber.

Dependencies
------------

You'll need the following:

* tcl8.5 and dev libraries
* ruby > 1.9.1 along with its dev libraries
* [Cucumber-Ruby](https://github.com/cucumber/cucumber)

How to use
----------

First, add the `cucumber-tcl` plugin to your Gemfile:

    gem 'cucumber-tcl'

Install it:

    bundle install

In a file in Cucumber's load path, like `features/support/env.rb`, add the following line:

    require 'cucumber/tcl'

You should now be able to start writing features, and implementing the step definitions in Tcl. These should be placed in a `.tcl` file below the features directory. To create the step definitions, you're provided with `Given`, `When`, `Then` and `And` procs for you to call, for example:

    Given {^I am a logged in user$} {
      puts "I'm a logged in user
    }

    When {^I purchase a ticket$} {
      puts "Purchase a ticket"
    }

    Then {^I receive confirmation of the purchase$} {
      puts "Purchase confirmation"
    }
