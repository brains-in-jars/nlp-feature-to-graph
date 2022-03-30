require 'monte_carlo/section'
require 'monte_carlo/task'
require 'monte_carlo/backlog'

RSpec.describe MonteCarlo::Section do


  let(:cycle_times){ [0,1,2,2,3,4,5,5,5,5,6,7,8,9,10] }
  let(:task1){ MonteCarlo::Task.new }
  let(:task2){ MonteCarlo::Task.new }
  let(:task3){ MonteCarlo::Task.new }
  let(:task4){ MonteCarlo::Task.new }
  let(:task5){ MonteCarlo::Task.new }
  let(:task6){ MonteCarlo::Task.new }
  let(:task7){ MonteCarlo::Task.new }
  let(:task8){ MonteCarlo::Task.new }
  let(:task9){ MonteCarlo::Task.new }

  let(:working_tasks){ [task1, task3, task5] }
  let(:queuing_tasks){ [task2, task4, task6, task8] }
  let(:feeder_tasks){ [task7, task9] }
   

  
  
  before do
    queuing_tasks.each do |task|
      task.queue!
      subject.tasks << task
    end

    working_tasks.each do |task|
      subject.tasks << task #no wip on queue columns
    end
  end

  subject{ described_class.new(wip: 3, cycle_times: cycle_times) }

  context 'working' do
    
    it 'should return only working tasks' do
      expect(subject.working).to eq working_tasks
    end
  end

  context 'queueing' do
    
    it 'should return only queuing tasks' do
      expect(subject.queuing).to eq queuing_tasks
    end

  end

  context 'feed' do

    let(:feeder){ MonteCarlo::Backlog.new(tasks: feeder_tasks) }

    before do
      subject.feeder = feeder
    end

    it 'should not call feeder when the wip == working tasks' do
      expect(feeder).to receive(:next_task).never
      subject.feed!
    end

    context 'there is one less working task than wip' do

      it 'should call feeder once when working tasks is one less than the wip' do
        task1.queue!
        expect(feeder).to receive(:next_task).once.and_call_original
        subject.feed!
      end

      it 'should call feeder twice when working tasks is two less than the wip' do
        task1.queue!
        task3.queue!
        expect(feeder).to receive(:next_task).twice.and_call_original
        subject.feed!
      end

      it 'should call feeder wip number of times when there are no working tasks' do
        subject.tasks.each{ |task| task.queue! }
        expect(feeder).to receive(:next_task).exactly(subject.wip).times.and_call_original
        subject.feed!
      end

      it 'should call reset! for each task pulled from the backlog' do
        subject.tasks.each{ |task| task.queue! }
        expect(task7).to receive(:reset!).once
        expect(task9).to receive(:reset!).once
        subject.feed!
      end

      it 'should add the backlog task to tasks' do
        subject.tasks.each{ |task| task.queue! }
        expect(subject.tasks).to receive(:<<).once.with(task7)
        expect(subject.tasks).to receive(:<<).once.with(task9)
        subject.feed!
      end

    end

  end

end