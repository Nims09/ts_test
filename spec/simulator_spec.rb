require 'spec_helper'

describe Simulator do

  let(:simulator) do
    Simulator.new(initial_state)
  end


  context "scenarios" do
    shared_examples "correct_state" do
      it { should eql resulting_state }
      it "should have the verdict" do
        expect(simulator.verdict).to eql verdict
      end
    end

    before do
      simulator.next
    end

    subject { simulator.state }

    context "#1" do
      let(:initial_state) do
        [
         [:soft, :hard, :none],
         [:hard, :none, :soft],
         [:none, :soft, :hard],
        ]
      end
      let(:resulting_state) do
        [
         [:soft, :hard, :none],
         [:hard, :none, :soft],
         [:none, :soft, :hard]
        ]
      end
      let(:verdict) { :push }
      include_examples "correct_state"
      
    end

    context "#2" do
      let(:initial_state) do
        [
         [:soft, :hard, :none],
         [:hard, :none, :soft],
         [:soft, :soft, :hard],
        ]
      end
      let(:resulting_state) do
        [
         [:soft, :hard, :none],
         [:none, :none, :soft],
         [:soft, :none, :hard]
        ]
      end
      let(:verdict) { :soft }

      include_examples "correct_state"
    end

    context "#3" do
      let(:initial_state) do
        [
         [:soft, :hard, :none, :soft],
         [:hard, :none, :soft, :hard],
         [:none, :none, :none, :soft],
         [:none, :soft, :hard, :none],
        ]
      end
      let(:resulting_state) do
        [
         [:soft, :hard, :none, :soft],
         [:hard, :none, :none, :hard],
         [:none, :none, :none, :soft],
         [:none, :none, :hard, :none],
        ]
      end
      let(:verdict) { :hard }

      include_examples "correct_state"
    end

    context "#4" do
      let(:initial_state) do
        [
         [:soft, :hard, :hard, :soft],
         [:none, :none, :none, :none],
         [:none, :none, :none, :none],
         [:hard, :soft, :hard, :soft],
        ]
      end
      let(:resulting_state) do
        [
         [:none, :hard, :hard, :none],
         [:none, :hard, :hard, :none],
         [:none, :hard, :soft, :none],
         [:none, :soft, :hard, :none],
        ]
      end
      let(:verdict) { :hard }

      include_examples "correct_state"
    end

    context "#5" do
      let(:initial_state) do
        [
         [:none, :hard, :hard, :none],
         [:none, :hard, :hard, :none],
         [:none, :soft, :soft, :none],
         [:none, :soft, :soft, :none],
        ]
      end
      let(:resulting_state) do
        [
         [:none, :hard, :hard, :none],
         [:hard, :none, :none, :hard],
         [:soft, :none, :none, :soft],
         [:none, :soft, :soft, :none],
        ]
      end
      let(:verdict) { :push }

      include_examples "correct_state"
    end
  end

  context "#private" do
    let(:initial_state) do
      [
       [:soft, :none, :none],
       [:hard, :none, :soft],
       [:none, :none, :hard],
      ]
    end    

    describe "#in_array_range?" do
      it "should return true for a value in range" do
        expect( simulator.send(:in_array_range?, 0, 0) ).to eq true
      end

      it "should return true for a value on the edge of range" do
        expect( simulator.send(:in_array_range?, 0, (initial_state.size-1)) ).to eq true
      end

      it "should return false for a value outside of range" do
        expect( simulator.send(:in_array_range?, 0, (initial_state.size)) ).to eq false
      end
    end

    describe "#update_opinion_for" do
      it "should return 'none'" do
        sim = Simulator.new([
         [:soft, :none],
         [:hard, :none],
        ])
        expect( sim.send(:update_opinion_for, 0, 0) ).to eq :none
      end 

      it "should return 'none'" do
        sim = Simulator.new([
         [:soft, :hard, :hard],
         [:hard, :soft, :soft],
         [:none, :none, :hard],
        ])    
        expect( sim.send(:update_opinion_for, 1, 1) ).to eq :none
      end 

      it "should return 'soft'" do
        sim = Simulator.new([
         [:none, :soft],
         [:hard, :soft],
        ])    
        expect( sim.send(:update_opinion_for, 0, 0) ).to eq :soft
      end   

      it "should return 'hard'" do
        sim = Simulator.new([
         [:none, :soft],
         [:hard, :hard],
        ])    
        expect( sim.send(:update_opinion_for, 0, 0) ).to eq :hard
      end        

      it "should return 'none' without changing" do
        sim = Simulator.new([
         [:none, :none],
         [:hard, :hard],
        ])    
        expect( sim.send(:update_opinion_for, 0, 0) ).to eq :none
      end   

      it "should return 'soft' without changing" do
        sim = Simulator.new([
         [:soft, :hard],
         [:hard, :none],
        ])    
        expect( sim.send(:update_opinion_for, 0, 0) ).to eq :soft
      end         
    end 
  end 

  context "ArgumentError" do
    it "should raise an ArgumentError when given bad input" do 
      expect { Simulator.new([
       [:not_an_expected_value, :hard, :none],
       [:hard, :none, :soft],
       [:none, :soft, :hard],
      ])}.to raise_error
    end

    it "should not raise ArgumentError with expected input" do 
      expect { Simulator.new([
       [:soft, :hard, :none],
       [:hard, :none, :soft],
       [:none, :soft, :hard],
      ])}.not_to raise_error
    end    
  end
end
