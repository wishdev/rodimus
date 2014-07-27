require 'rodimus/configuration'
require 'rodimus/observable'
require 'rodimus/observing'
require 'rodimus/benchmark'
require 'rodimus/runtime_logging'
require 'rodimus/formatter'
require 'rodimus/row'
require 'rodimus/step'
require 'rodimus/transformation'
require 'rodimus/version'
require 'ap'

module Rodimus
  $SAFE = 1 # Because we're using DRb

  class << self
    attr_accessor :configuration
  end
  self.configuration = Configuration.new

  def self.configure
    yield configuration
  end

  def self.logger
    configuration.logger
  end
end
