require "test/unit"
require "./bootstrap_ar.rb"
require "database_cleaner"

DatabaseCleaner.strategy = :truncation

class Test::Unit::TestCase
  def teardown
    DatabaseCleaner.clean
  end
end