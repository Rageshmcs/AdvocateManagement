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

  def self.getCase(id)
  	@@casesRegistry[id]
  end

  def self.addCase(id, state)
  	@@casesRegistry[id] = Case.new(id, state) unless Case.getCase(id)
  	true
  end
end
