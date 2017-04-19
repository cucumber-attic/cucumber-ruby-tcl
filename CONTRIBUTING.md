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

## Gaining Release Privileges

To become a release manager, create a pull request adding your name to the list below, and make sure to include a link to your [Rubygems profile](https://rubygems.org/sign_up). One of the existing release managers will then add you.

Current release managers:
  * [Matt Wynne](https://rubygems.org/profiles/mattwynne)
  * [Jonathan Owers](https://rubygems.org/profiles/jowers)
  * [Shaun Bristow](https://rubygems.org/profiles/ahhbristow)

To grant release privilege, issue the following command:

    gem owner cucumber-tcl --add <NEW OWNER RUBYGEMS EMAIL>
