require "./spec_helper"
require "../../src/models/bike.cr"

describe Bike do
  Spec.before_each do
    Bike.clear
  end
end
