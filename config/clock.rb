require './config/boot'
require './config/environment'
require 'clockwork'
include Clockwork

every(60.seconds, 'conditions.setter') { Condition.new.setter }

# $ bundle exec rake jobs:work & 
# $ bundle exec clockwork config/clock.rb &