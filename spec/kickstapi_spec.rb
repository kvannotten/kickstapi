require 'spec_helper'

describe Kickstapi do
  it 'should have a version number' do
    Kickstapi::VERSION.should_not be_nil
  end
  
  before :all do
    @projects = Kickstapi.search_projects "Planetary Annihilation" # succesful project
    @failure = Kickstapi.get_project "Quala" # failing project
  end

  context 'projects' do
    subject { @projects }
     
    it { should be_an_instance_of Array }
    
    it { should_not be_empty }
  end
  
  context 'a project' do
    subject { @projects.first}
    
    its(:to_hash) { should be_kind_of Hash }
    
    [ :id, :name, :url, :creator, 
      :about, :pledged, :currency, 
      :percentage_funded, :backers, 
      :status].each do |method|
      it { should respond_to method }
      its(method) { should_not be_nil }
      its(:to_hash) { should have_key method }
    end
    
    its(:id) { should be_kind_of Fixnum }
    its(:id) { should > 0 }
    
    its(:pledged) { should be_kind_of Float }
    
    it "returns valid json" do
      expect { JSON.parse @projects.first.to_json }.to_not raise_error JSON::ParserError
    end
  end
  
  context 'failed project' do
    subject { @failure }
    
    its(:status) { should eql "Failed" }
    [:pledged, :percentage_funded, :backers].each do |method|
      its(method) { should be_nil }
    end
  end
end
