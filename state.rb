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

  def displayAllCases
    caseFound = false
    @advocates.each do |advocateId, value|
      advocateCases = advocateId + ":"
      cases = Advocate.advocates[advocateId].allCases(@id)

      blockedCases = Advocate.advocates[advocateId].allBlockedCases(@id)
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
