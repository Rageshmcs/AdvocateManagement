class Advocate
  @@advocatesRegistry = {}

  attr_accessor :id, :states, :cases, :blockedCases, :seniorId, :juniorIds
  
  def initialize(id, seniorId=nil)
    @id = id
    @states = {}
    @cases = {}
    @blockedCases = {}
    @juniorIds = {}
    @seniorId = seniorId if seniorId
  end

  def self.advocatesRegistry
    @@advocatesRegistry
  end

  def self.getAdvocate(id)
    @@advocatesRegistry[id]
  end

  def self.addAdvocate(id, seniorId=nil)
    @@advocatesRegistry[id] = Advocate.new(id, seniorId)
    true
  end

  def becomeSenior
    if @seniorId
      Advocate.getAdvocate(@seniorId).juniorIds.delete(@id)
      @seniorId = nil
    end
    self
  end

  def joinJunior(juniorId)
    unless Advocate.getAdvocate(juniorId)
      Advocate.addAdvocate(juniorId, @id)
    else
      self.manageJunior(juniorId)
    end
    @juniorIds[juniorId] = 1
    true
  end

  def manageJunior(id)
    Advocate.getAdvocate(id).seniorId = @id
    Advocate.getAdvocate(id).juniorIds.each do |juniorId, value|
      Advocate.getAdvocate(juniorId).seniorId = @id # junior's juniors' senior id change to the new senior
      @juniorIds[juniorId] = 1

      Advocate.getAdvocate(juniorId).states.each do |state, value| # extra practising states removal
        Advocate.getAdvocate(juniorId).states.delete(state) unless @states[state]
      end
    end
    Advocate.getAdvocate(id).juniorIds = {}
    Advocate.getAdvocate(id).states.each do |state, value| # extra practising states removal
      Advocate.getAdvocate(id).states.delete(state) unless @states[state]
    end
  end

  # state information

  def addState(state)
    return false unless State.getState(state)
    if @seniorId
      return false unless Advocate.getAdvocate(@seniorId).states[state] == 1
    end
    State.registerAdvocate(state, @id)
    @states[state] = 1
    true
  end

  def practisingStates
    outputStates = ""
    @states.each do |key, value|
      outputStates += " #{key},"
    end
    outputStates.chop
  end

  # case information

  def addCase(caseId, state, blocked = false)
    return false unless State.getState(state)
    return false unless @states[state] == 1

    Case.addCase(caseId, state)

    unless blocked
      return false if @seniorId && Advocate.getAdvocate(@seniorId).blockedCases[caseId]
      @cases[caseId] = 1
      @blockedCases.delete(caseId)
    else
      @blockedCases[caseId] = 1
      @cases.delete(caseId)
    end
    true
  end

  def allCases(state = nil)
    self.caseList(@cases, state)
  end

  def allBlockedCases(state = nil)
    self.caseList(@blockedCases, state)
  end

  def caseList(cases, state=nil)
    outputCases = ""
    cases.each do |key, value|
      if state
        outputCases += " #{key}," if Case.getCase(key).state == state
      else
        outputCases += " #{key}-#{Case.getCase(key).state},"
      end
    end
    outputCases.chop
  end
end
