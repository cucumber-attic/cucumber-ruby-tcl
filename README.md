Build status: [![Circle CI](https://circleci.com/gh/cucumber/cucumber-ruby-tcl/tree/master.svg?style=svg)](https://circleci.com/gh/cucumber/cucumber-ruby-tcl/tree/master)

Cucumber Tcl
============

Drive your Tcl code with Cucumber.

Dependencies
------------

You'll need the following:

* tcl8.5 and dev libraries
* ruby > 1.9.1 along with its dev libraries

How to use
----------

First, add the `cucumber-tcl` plugin to your Gemfile:

    gem 'cucumber-tcl'

Install it:

    bundle install

In a file in Cucumber's load path, like `features/support/env.rb`, add the following line:

    require 'cucumber/tcl'

You should now be able to start writing features, and implementing the step definitions in Tcl. These should be placed in `.tcl` files below the features directory. To create the step definitions, you're provided with `Given`, `When`, `Then` and `And` procs for you to call, for example:

    Given {^I am a logged in user$} {
      puts "I'm a logged in user
    }

    When {^I purchase a ticket$} {
      puts "Purchase a ticket"
    }

    Then {^I receive confirmation of the purchase$} {
      puts "Purchase confirmation"
    }

If your regular expression captures any matches, you should provide a list of variable names as the second parameter to any of these procedure calls. These will then be available to your script, for example:

    Given {^I am logged in with username (\w+)$} {username} {
      puts "Username is $username"
    }

    Given {^I buy (\d+) cucumbers for $(\d+)$} {quantity price} {
      puts "$quantity cucumbers bought. Price was $price"
    }

You can use basic tables in your scenarios. The data from the table s made available to your step definition, via the last variable name you pass into the capture list. For example, if you had the following step in your feature:

    Given I have added the following products to my shopping cart:
      | apple  | £2.00 |
      | orange | £3.00 |
      | banana | £1.50 |

I could write the step definition for the Given step as:

    Given {^I have added the following products to my shopping cart:$} {table_data} {
      puts "$table_data"
    }

The data in the table is provided as a list of lists, so in the above example, table data would look like:

    {"apple" "£2.00"} {"orange" "£3.00"} {"banana" "£1.50"}

meaning you can access each element using `lindex`, e.g.

    puts [lindex [lindex $table_data 0] 0]
    apple

If your step definition captures a match in the step definition as well as has a table, the table variable will always be last, e.g.

    When I buy the following items from Tesco:
      | cabbage |
      | potato  |
      | onion   |

and in your step definition, you might have

    Given {^I buy the following items from (\w+):$} {store items} {
      puts "I've been shopping at $store"
      puts "The first item I bought was [lindex $items 0]"
    }

Resetting state between scenarios
---------------------------------

Depending on how your test and/or application code is structured, there may be a chance of data persisting between scenarios, which could result in tests that pass or fail unexpectedly.  To eliminiate the risk of this, Cucumber TCL will start a new TCL interpreter between every scenario, meaning that the env.tcl file is loaded each time.  Whilst this will remove the data leakage risk, it may also cause your scenarios to run slowly if there is a lot of setup required for a scenario to run (eg, setting up fixture data, building a database or loading large amounts of data into memory).  To override the default behaviour of starting up a new interpreter, an environment variable can be passed into the 'cucumber' command disabling it:

    cucumber NEW_INTERPRETER=0

It's also possible to make the default behaviour of starting up a new interpreter explicit:

    cucumber NEW_INTERPRETER=1

If you are wrapping Cucumber around poorly understood legacy TCL code, you may wish to disable starting up a new interpreter during development in the interests of running tests quickly, but retain the default behaviour in your CI build to remove the risk of data leakage if you think there is a chance of this.
