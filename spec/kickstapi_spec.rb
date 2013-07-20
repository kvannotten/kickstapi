require 'spec_helper'

describe Kickstapi do
  it 'should have a version number' do
    Kickstapi::VERSION.should_not be_nil
  end
  
  before :all do
    @projects = Kickstapi.search_projects "Planetary Annihilation" # succesful project
    @failures = Kickstapi.search_projects "Quala" # failing project
  end

  context 'projects' do
    subject { @projects }
     
    it { should be_an_instance_of Array }
    
    it { should_not be_empty }
  end
  
  context 'a project' do
    subject { @projects.first }
    
    [:name, :url, :creator, :about, :pledged, :percentage_funded, :backers, :status].each do |method|
      it { should respond_to method }
      its(method) { should_not be_empty }
    end
  end
  
  context 'failed project' do
    subject { @failures.first }
    
    its(:status) { should eql "Failed" }
    [:pledged, :percentage_funded, :backers].each do |method|
      its(method) { should be_nil }
    end
  end
end
