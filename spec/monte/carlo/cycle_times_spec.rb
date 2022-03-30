require 'monte_carlo/cycle_times'

RSpec.describe MonteCarlo::CycleTimes do

  let(:data){ [1,1,2,2,3,4,5,6,6,6,6,7,8,8,9,10] }

  # 0x0, 2x1, 2x2, 1x3, 1x4, 1x5, 4x6, 1x7, 2x8, 1x9, 1x10 
  let(:parsed_data){ [0, 2, 2, 1, 1, 1, 4, 1, 2, 1, 1] }
  let(:sum){ parsed_data.sum }


  before do
    subject.source_data = data
  end
  
  context '#build' do

    it 'should parse the data' do
      expect(subject.data).to eq parsed_data
    end

    it 'should freeze the array' do
      expect(subject.data.frozen?).to be true
    end

  end

  context 'chance_finished_today' do

    it 'should return the chance the task finishes day 0' do
      expect(subject.chance_finished_today(0)).to eq 0.0 / sum
    end

    it 'should return the chance the task finishes day 1' do
      expect(subject.chance_finished_today(1)).to eq 2.0 / sum
    end

    it 'should return the chance the task finishes day 2' do
      expect(subject.chance_finished_today(2)).to eq 4.0 / sum
    end

    it 'should return the chance the task finishes day 3' do
      expect(subject.chance_finished_today(3)).to eq 5.0 / sum
    end

    it 'should return the chance the task finishes day 4' do
      expect(subject.chance_finished_today(4)).to eq 6.0 / sum
    end

    it 'should return the chance the task finishes day 5' do
      expect(subject.chance_finished_today(5)).to eq 7.0 / sum
    end

    it 'should return the chance the task finishes day 6' do
      expect(subject.chance_finished_today(6)).to eq 11.0 / sum
    end

    it 'should return the chance the task finishes day 7' do
      expect(subject.chance_finished_today(7)).to eq 12.0 / sum
    end

    it 'should return the chance the task finishes day 8' do
      expect(subject.chance_finished_today(8)).to eq 14.0 / sum
    end

    it 'should return the chance the task finishes day 9' do
      expect(subject.chance_finished_today(9)).to eq 15.0 / sum
    end

    it 'should return the chance the task finishes day 10' do
      expect(subject.chance_finished_today(10)).to eq 16.0 / sum
    end

  end

  context 'finished_today?' do

    let(:day_index){ 5 }

    before do
      allow(subject).to receive(:chance_finished_today).with(day_index).and_return(0.8)
    end

    it 'should return true if the random number is less than chance' do
      allow(subject).to receive(:rand).and_return(0.7)
      expect(subject.finished_today?(day_index)).to be true
    end

    it 'should return false if the random number is greater than chance' do
      allow(subject).to receive(:rand).and_return(0.9)
      expect(subject.finished_today?(day_index)).to be false
    end

  end

end