module MonteCarlo
  class Section

    attr_accessor :feeder, :wip, :name

    def initialize(name:, cycle_times:, feeder:, wip: 3)
      @name = name
      @wip = wip
      @feeder = feeder
      @cycle_times = cycle_times
    end

    def tasks
      @tasks ||= []
    end

    def queue
      @queue ||= []
    end

    def run_for_today!
      feed!
      working.each do |task|
        if @cycle_times.finished_today?(task.day_index)
          task.queue!
        end
      end
      increment_day!
    end

    def increment_day!
      tasks.each do |task|
        task.increment_day!
      end
    end

    def feed!
      (0...capacity).each do
        new_task = feeder.next_task
        if new_task #the feeder queue may be empty today
          new_task.reset!
          tasks << new_task
        end 
      end
    end

    def next_task
      tasks.delete(queuing.first)
    end

    def delete(task)
      @tasks.delete(task)
    end

    def capacity
      @wip - working.length
    end

    def working
      tasks.select{ |task| task.working? }
    end

    def queuing
      tasks.select{ |task| task.queuing? }
    end
  end
end