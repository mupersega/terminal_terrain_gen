# frozen_string_literal: true

# ERROR-HANDLING
begin
  # I am INTENTIONALLY REQUIRING all dependencies to catch load errors early
  require 'fileutils'
  require 'rainbow'
  require 'chunky_png'
  require 'tty-prompt'
  require 'tty-progressbar'
  require 'json'
rescue LoadError
  puts 'There has been an error loading the necessary dependencies.'
  puts "Please:
    1. navigate to the root directory of this application,
    2. run './terra',
    3. press [i] to install all required dependencies."
  exit!
end

require_relative 'classes/launcher'
require_relative 'modules/data'
include Data::RuntimeFunx

# ERROR-HANDLING used here to inform when no cli arg has been passed
begin
  options = %w[run clear]
  # VV process cli arg here VV
  choice = ARGV[0].downcase
  options.include?(choice) ? run_task(choice) : wrong_input
rescue NoMethodError
  wrong_input
end
