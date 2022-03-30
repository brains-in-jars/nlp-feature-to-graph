module MonteCarlo
  class Task

    attr_accessor :state, :day_index

    WORKING = :working 
    QUEUING = :queuing

    def initialize
      reset!
    end

    def reset!
      @day_index = 0
      @state = WORKING
    end

    def increment_day!
      @day_index += 1
    end

    def queue!
      @state = QUEUING
    end

    def queuing?
      state == Task::QUEUING
    end

    def working?
      state == Task::WORKING
    end
  end
end