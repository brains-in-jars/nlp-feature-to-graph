module MonteCarlo
  class Simulation
   
    attr_accessor :backlog
    attr_accessor :done

    def sections
      @section ||= []
    end

    def section_data
      @section_data ||= {}
    end

    def initialize
      @day = 0
    end

    def run!
      @backlog_start = backlog.size
        until complete? do
          sections.each do |section|
            section.run_for_today!
            section_data[section.name] ||= []
            section_data[section.name] << { d: @day, w: section.working.size, q: section.queuing.size }
          end
          done.run!
          @day += 1
      end
    end

    def to_csv
      require 'csv'
      CSV.open("/tmp/mone-carlo.csv", "wb") do |csv|
        section_data.each do |name, data|
          csv << ["#{name}-working"] + data.collect{|d| d[:w] }
          csv << ["#{name}-queuing"] + data.collect{|d| d[:q] }
        end
      end
    end

    def complete?
      done.size == @backlog_start
    end

  end
end