module MonteCarlo
  class Done
    attr_accessor :feeder

    def tasks
      @tasks ||= []
    end

    def size
      tasks.size
    end
    
    def initialize(feeder:)
      @feeder = feeder
    end

    def run!
      feeder.queuing.each do |task|
        tasks << feeder.delete(task)
      end
    end

  end
end