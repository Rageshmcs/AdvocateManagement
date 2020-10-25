class State
  @@statesRegistry = {}

  attr_accessor :id, :advocates, :cases

  def initialize(id)
    @id = id
    @advocates = {}
    @cases = {}
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

class Advocate
  @@advocates = {}

  attr_accessor :id, :states, :cases, :blockedCases, :rejected_cases, :seniorId, :juniorIds
  
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
      puts "in unless blocked....."
      return false if @seniorId && @@advocates[@seniorId].blockedCases[caseId]
      @cases[caseId] = 1
      @blockedCases.delete(caseId)
    else
      puts " in else...."
      @blockedCases[caseId] = 1
      @cases.delete(caseId)
    end
    true
  end

  def self.displayAllAdvocates
    @@advocates.each do |id, advocate|
      unless advocate.seniorId # senior advocates
        print "Name: #{id}"
        print " states:#{advocate.practisingStates}" if advocate.states != {}
        print " cases:" if advocate.cases != {} || advocate.blockedCases != {}
        print "#{advocate.allCases}" if advocate.cases != {}
        print "(Rejected)#{advocate.allBlockedCases}" if advocate.blockedCases != {}
        puts ""
        advocate.juniorIds.each do |juniorId, value| # junior advocates
          junior = @@advocates[juniorId]
          print "-Name: #{juniorId}"
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

# Options:
# 1. Add an advocate
# 2. Add junior advocates
# 3. Add states for advocate
# 4. Add cases for advocate
# 5. Reject a case.
# 6. Display all advocates
# 7. Display all cases under a state

# add default states
states = ['TN', 'AP', 'KA', 'KE']

states.each do |state|
  State.statesRegistry[state] = State.new(state)
end

while 1
	print  "Input: "
	input = gets.chomp

	case input
	when '1'
    print "Add an Advocate: "
    id = gets.chomp
    puts "Output:"
    unless Advocate.advocates[id]
      Advocate.advocates[id] = Advocate.new(id)
      puts "Advocate added #{id}"
    else
      puts "Advocate #{id} already present" 
    end
	when '2'
    print "Senior Advocate ID: "
    seniorId = gets.chomp
    unless Advocate.advocates[seniorId]
      Advocate.advocates[seniorId] = Advocate.new(seniorId)
      puts "Advocate added #{seniorId}"
    end
    print "Junior ID: "
    juniorId = gets.chomp

    Advocate.advocates[seniorId].becomeSenior.joinJunior(juniorId)
    puts "Output:"
    puts "Advocate added #{juniorId} under #{seniorId}"
	when '3'
    print "Advocate ID: "
    id = gets.chomp
    print "Practicing State: "
    state = gets.chomp.upcase
    stateAdded = Advocate.advocates[id].addState(state)
    puts "Output:"
    if stateAdded
      puts "State #{state} added for #{id}"
    else
      puts "Cannot add #{state} for #{id}"
    end
	when '4'
    print "Advocate ID: "
    id = gets.chomp
    print "Case ID: "
    caseId = gets.chomp
    print "Practicing State: "
    state = gets.chomp.upcase
    caseAdded = Advocate.advocates[id].addCase(caseId, state)
    puts "Output:"
    if caseAdded
      puts "Case #{caseId} added for #{id}"
    else
      puts "Cannot add #{caseId} for #{id}"
    end
	when '5'
    print "Advocate ID: "
    id = gets.chomp
    print "Case ID: "
    caseId = gets.chomp
    print "Practicing State: "
    state = gets.chomp.upcase
    caseRejected = Advocate.advocates[id].addCase(caseId, state, true)
    puts "Output:"
    if caseRejected
      puts "Case #{caseId} is added to the Block list for #{id}"
    else
      puts "Cannot add #{caseId} to the Block list for #{id}"
    end
  when '6'
    puts "Output:"
    if Advocate.advocates != {}
      puts "Advocates:"
      Advocate.displayAllAdvocates
    else
      puts "Advocates not found"
    end
    next
  when '7'
    print "State Id: "
    state = gets.chomp.upcase
    puts "Output:"
    unless State.statesRegistry[state]
      puts "State #{state} not found"
      next
    end
    puts state + ":"
    puts "No cases found" unless State.statesRegistry[state].displayAllCases
    next
	else
	  break
  end
  Advocate.displayDetails
end
