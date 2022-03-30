module MonteCarlo
  class Backlog

    def initialize(tasks:)
      @tasks = tasks
    end

    def next_task
      @tasks.pop
    end

    def size
      @tasks.size
    end
    
  end
end