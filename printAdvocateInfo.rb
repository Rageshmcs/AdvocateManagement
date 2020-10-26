require_relative 'advocate'

class PrintAdvocateInfo < Advocate
  def self.displayAllAdvocates
    @@advocatesRegistry.each do |id, advocate|
      unless advocate.seniorId # senior advocates
        print "#{id}:"
        print " states:#{advocate.practisingStates}" if advocate.states != {}
        print " cases:" if advocate.cases != {} || advocate.blockedCases != {}
        print "#{advocate.allCases}" if advocate.cases != {}
        print "(Rejected)#{advocate.allBlockedCases}" if advocate.blockedCases != {}
        puts ""
        advocate.juniorIds.each do |juniorId, value| # junior advocates
          junior = Advocate.getAdvocate(juniorId)
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

  def self.displayCurrentDetails
    puts "Display:"
    @@advocatesRegistry.each do |id, advocate|
      unless advocate.seniorId # senior advocates
        puts "Advocate Name: #{id}"
        puts "practising States:#{advocate.practisingStates}" if advocate.states != {}
        puts "Practising Cases:#{advocate.allCases}" if advocate.cases != {}
        puts "Blocklist Cases:#{advocate.allBlockedCases}" if advocate.blockedCases != {}

        advocate.juniorIds.each do |juniorId, value| # junior advocates
          junior = Advocate.getAdvocate(juniorId)
          puts "-Advocate Name: #{juniorId}"
          puts "-Practising states:#{junior.practisingStates}" if junior.states != {}
          puts "-Practising Cases:#{junior.allCases}" if junior.cases != {}
          puts "-Blocklist Cases:#{junior.allBlockedCases}" if junior.blockedCases != {}
        end
      end
    end
  end
end
