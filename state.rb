class State
  @@statesRegistry = {}

  attr_accessor :id, :advocates

  def initialize(id)
    @id = id
    @advocates = {}
  end

  def self.statesRegistry
    @@statesRegistry
  end

  def self.getState(id)
    @@statesRegistry[id]
  end

  def self.addState(id)
    @@statesRegistry[id] = State.new(id)
  end

  def self.addStates(ids)
    ids.each {|id| addState(id)}
  end

  def self.registerAdvocate(state, advocateId)
    State.getState(state).advocates[@id] = 1
  end

  def displayAllCases
    caseFound = false
    @advocates.each do |advocateId, value|
      advocateCases = advocateId + ":"
      cases = Advocate.getAdvocate(advocateId).allCases(@id)
      blockedCases = Advocate.getAdvocate(advocateId).allBlockedCases(@id)

      if cases != "" || blockedCases != ""
        caseFound = true
        print advocateId + ":" + cases
        print " (Rejected)" + blockedCases if blockedCases != ""
        puts ""
      end
    end
    caseFound
  end
end
