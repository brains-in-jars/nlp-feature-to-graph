module MonteCarlo
  class CycleTimes

    def self.from_source_data(source_array)
      cycles = new
      puts source_array.inspect
      puts source_array.max.inspect
      (0..source_array.max).each do |i|
        cycles.data << source_array.select{ |d| d.to_i == i }.count
      end
      cycles.data.freeze
      puts cycles.data.inspect
      cycles
    end

    def chance_finished_today(day_index)
      sum_to_today(day_index).to_f / data.sum.to_f 
    end

    def finished_today?(day_index)
      rand(0.0..1.0) < chance_finished_today(day_index)
    end

    def data
      @data ||= []
    end

    private

    def sum_to_today(day_index)
      (0..day_index).collect do |d|
        data[d]
      end.sum
    end
  end  
end
