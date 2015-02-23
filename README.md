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

