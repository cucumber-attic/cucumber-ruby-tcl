## Running tests

    gem install bundler
    bundle install
    bundle exec rake

This runs tests on both the Ruby and Tcl code.

## Release Process

* Bump the version number in `lib/cucumber/tcl/version`.

Now release it

    bundle update && bundle exec rake # check all tests are passing
    git commit -m "Release `cat lib/cucumber/tcl/version`"
    rake release

## Gaining Release Karma

To become a release manager, create a pull request adding your name to the list below, and include your [Rubygems email address](https://rubygems.org/sign_up) in the ticket. One of the existing Release managers will then add you.

Current release managers:
  * [Matt Wynne](https://github.com/mattwynne)

To grant release karma, issue the following command:

    gem owner cucumber-tcl --add <NEW OWNER RUBYGEMS EMAIL>
