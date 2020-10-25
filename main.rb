require_relative 'advocate'
require_relative 'case'

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
