require_relative 'state'

class Case < State
  @@casesRegistry = {}

  attr_accessor :id, :state

  def initialize(id, state)
    @id = id
    @state = state
  end

  def self.casesRegistry
    @@casesRegistry
  end
end
