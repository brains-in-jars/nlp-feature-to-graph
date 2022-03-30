require 'monte_carlo'

simulation = MonteCarlo::Simulation.new

refinement_cycle_times = (0..100).collect { rand(10) }
doing_cycle_times = (0..100).collect { rand(30) }
testing_cycle_times = (0..100).collect { rand(15) }
tasks = (0..50).each { MonteCarlo::Task.new }

simulation.backlog = MonteCarlo::Backlog.new(tasks: tasks)

simulation.sections <<  MonteCarlo::Section.new(cycle_times: refinement_cycle_times, feeder: simulation.backlog)
simulation.sections <<  MonteCarlo::Section.new(cycle_times: doing_cycle_times, feeder: simulation.sections.last)
simulation.sections <<  MonteCarlo::Section.new(cycle_times: testing_cycle_times, feeder: simulation.sections.last)

simulation.done = MonteCarlo::Done.new(feeder: simulation.sections.last)

simulation.run!