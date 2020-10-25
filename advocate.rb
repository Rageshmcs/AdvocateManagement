class Advocate
  @@advocates = {}

  attr_accessor :id, :states, :cases, :blockedCases, :seniorId, :juniorIds
  
  def initialize(id, seniorId=nil)
    @id = id
    @states = {}
    @cases = {}
    @blockedCases = {}
    @juniorIds = {}
    @seniorId = seniorId if seniorId
  end

  def self.advocates
    @@advocates
  end

  def becomeSenior
    if @seniorId
      Advocate.advocates[@seniorId].juniorIds.delete(@id) 
      @seniorId = nil
    end
    self
  end

  def joinJunior(juniorId)
    unless @@advocates[juniorId]
      @@advocates[juniorId] = Advocate.new(juniorId, @id)
    else
      @@advocates[juniorId].seniorId = @id
      @@advocates[juniorId].juniorIds.each do |id, value|
        @@advocates[id].seniorId = @id # junior's juniors' senior id change to the new senior
        @juniorIds[id] = 1

        @@advocates[id].states.each do |state, value| # extra practising states removal
          @@advocates[id].states.delete(state) unless @states[state]
        end
      end
      @@advocates[juniorId].juniorIds = {}
      @@advocates[juniorId].states.each do |state, value| # extra practising states removal
        @@advocates[juniorId].states.delete(state) unless @states[state]
      end
    end
    @juniorIds[juniorId] = 1
  end

  def addState(state)
    return false unless State.statesRegistry[state]
    if @seniorId
      return false unless @@advocates[@seniorId].states[state] == 1
    end
    @states[state] = 1
    State.statesRegistry[state].advocates[@id] = 1 
    true
  end

  def practisingStates
    outputStates = ""
    @states.each do |key, value|
      outputStates += " #{key},"
    end
    outputStates.chop
  end

  def allCases(state = nil)
    outputCases = ""
    @cases.each do |key, value|
      if state
        outputCases += " #{key}," if Case.casesRegistry[key].state == state
      else
        outputCases += " #{key}-#{Case.casesRegistry[key].state},"
      end
    end
    outputCases.chop
  end

  def allBlockedCases(state = nil)
    outputCases = ""
    @blockedCases.each do |key, value|
      if state
        outputCases += " #{key}," if Case.casesRegistry[key].state == state
      else
        outputCases += " #{key}-#{Case.casesRegistry[key].state},"
      end
    end
    outputCases.chop
  end

  def addCase(caseId, state, blocked = false)
    return false unless State.statesRegistry[state]
    return false unless @states[state] == 1

    Case.casesRegistry[caseId] = Case.new(caseId, state) unless Case.casesRegistry[caseId]

    unless blocked
      return false if @seniorId && @@advocates[@seniorId].blockedCases[caseId]
      @cases[caseId] = 1
      @blockedCases.delete(caseId)
    else
      @blockedCases[caseId] = 1
      @cases.delete(caseId)
    end
    true
  end

  def self.displayAllAdvocates
    @@advocates.each do |id, advocate|
      unless advocate.seniorId # senior advocates
        print "#{id}:"
        print " states:#{advocate.practisingStates}" if advocate.states != {}
        print " cases:" if advocate.cases != {} || advocate.blockedCases != {}
        print "#{advocate.allCases}" if advocate.cases != {}
        print "(Rejected)#{advocate.allBlockedCases}" if advocate.blockedCases != {}
        puts ""
        advocate.juniorIds.each do |juniorId, value| # junior advocates
          junior = @@advocates[juniorId]
          print "-#{juniorId}:"
          print " states:#{junior.practisingStates}" if junior.states != {}
          print " cases:" if junior.cases != {} || junior.blockedCases != {}
          print "#{junior.allCases}" if junior.cases != {}
          print "(Rejected)#{junior.allBlockedCases}" if junior.blockedCases != {}
          puts ""
        end
      end
    end
  end

  def self.displayDetails
    puts "Display:"
    @@advocates.each do |id, advocate|
      unless advocate.seniorId # senior advocates
        puts "Advocate Name: #{id}"
        puts "practising States:#{advocate.practisingStates}" if advocate.states != {}
        puts "Practising Cases:#{advocate.allCases}" if advocate.cases != {}
        puts "Blocklist Cases:#{advocate.allBlockedCases}" if advocate.blockedCases != {}

        advocate.juniorIds.each do |juniorId, value| # junior advocates
          junior = @@advocates[juniorId]
          puts "-Advocate Name: #{juniorId}"
          puts "-Practising states:#{junior.practisingStates}" if junior.states != {}
          puts "-Practising Cases:#{junior.allCases}" if junior.cases != {}
          puts "-Blocklist Cases:#{junior.allBlockedCases}" if junior.blockedCases != {}
        end
      end
    end
  end  
end
