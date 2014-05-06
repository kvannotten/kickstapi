require 'spec_helper'

describe Kickstapi do
  it 'should have a version number' do
    Kickstapi::VERSION.should_not be_nil
  end
  
  before :all do
    @projects = Kickstapi.find_projects_with_filter "Planetary Annihilation" # succesful project
    @failure = Kickstapi.find_projects_with_filter("Quala").first # failing project
  end

  context 'projects' do
    subject { @projects }
     
    it { should be_an_instance_of Array }
    
    it { should_not be_empty }
  end
  
  context 'a project' do
    subject { @projects.first}
    
    its(:to_hash) { should be_kind_of Hash }
    
    its(:id) { should be_kind_of Fixnum }
    
    its(:pledged) { should be_kind_of Float }
    
    it "returns valid json" do
      expect { JSON.parse @projects.first.to_json }.not_to raise_error 
    end

    it "should be in ghost state when first fetched" do
      temp_project = Kickstapi.find_projects_with_filter("Ewe Topia").first
      temp_project.load_state.should be_eql :ghost
    end

    it "should lazily load all the arguments" do
      temp_project = Kickstapi.find_projects_with_filter("Ewe Topia").first
      temp_project.backers # fetch an item that is lazily loaded
      temp_project.load_state.should be_eql :loaded
    end

    it "should be retrievable from it's URL" do
      temp_project = Kickstapi.find_project_by_url(@failure.url)
      temp_project.name.should be_eql @failure.name
    end

    it "should be comparable" do
      temp_project = Kickstapi.find_project_by_url(@projects.first.url)
      (temp_project == @projects.first).should be_true
    end

    it "should be different from another project" do
      (@projects.first == @failure).should be_false
    end

    it "should mark a successful project" do
      @projects.first.status.should be_eql :succesful
    end

    it "should mark an unsuccessful project" do
      @failure.status.should be_eql :failed
    end
  end
  
end
