require_relative 'printAdvocateInfo'
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
State.addStates(states)

while 1
  print  "Input: "
  input = gets.chomp

  case input
  when '1'
    print "Add an Advocate: "
    id = gets.chomp

    puts "Output:"
    unless Advocate.getAdvocate(id)
      puts "Advocate added #{id}" if Advocate.addAdvocate(id)
    else
      puts "Advocate #{id} already present" 
    end
  when '2'
    print "Senior Advocate ID: "
    seniorId = gets.chomp
    unless Advocate.getAdvocate(seniorId)
      puts "Advocate added #{seniorId}" if Advocate.addAdvocate(seniorId)
    end
    print "Junior ID: "
    juniorId = gets.chomp

    puts "Output:"
    puts "Advocate added #{juniorId} under #{seniorId}" if Advocate.getAdvocate(seniorId).becomeSenior.joinJunior(juniorId)
  when '3'
    print "Advocate ID: "
    id = gets.chomp
    print "Practicing State: "
    state = gets.chomp.upcase
    stateAdded = Advocate.getAdvocate(id).addState(state)

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

    puts "Output:"
    if Advocate.getAdvocate(id).addCase(caseId, state)
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

    puts "Output:"
    if Advocate.getAdvocate(id).addCase(caseId, state, true)
      puts "Case #{caseId} is added to the Block list for #{id}"
    else
      puts "Cannot add #{caseId} to the Block list for #{id}"
    end
  when '6'
    puts "Output:"
    if Advocate.advocatesRegistry != {}
      puts "Advocates:"
      PrintAdvocateInfo.displayAllAdvocates
    else
      puts "Advocates not found"
    end
    next
  when '7'
    print "State Id: "
    state = gets.chomp.upcase

    puts "Output:"
    unless State.getState(state)
      puts "State #{state} not found"
      next
    end
    puts state + ":"
    puts "No cases found" unless State.getState(state).displayAllCases
    next
  else
    break
  end
  PrintAdvocateInfo.displayCurrentDetails
end
