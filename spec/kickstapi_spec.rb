require 'spec_helper'

describe Kickstapi do
  it 'should have a version number' do
    expect(Kickstapi::VERSION).not_to be_nil
  end
  
  before :all do
    @projects = Kickstapi.find_projects_with_filter "Planetary Annihilation" # succesful project
    @failure = Kickstapi.find_projects_with_filter("Quala").first # failing project
    @project_by_name = Kickstapi.find_projects_by_username("kristofv").first
  end

  context 'projects' do
    subject { @projects }
     
    it { should be_an_instance_of Array }
    
    it { should_not be_empty }
  end
  
  context 'a username project' do
    subject { @project_by_name }

    its(:creator) { should be_eql :not_loaded } # the creator field cannot be fetched from this page

    its(:name) { should_not be_eql :not_loaded } # the name object should still be fetched
  end

  context 'Planetary Annihilation data' do
    subject { @projects.first } # This is the planetary annihilation project
    
    its(:creator) { should be_eql 'Uber Entertainment Inc'}
    its(:name) { should be_eql 'Planetary Annihilation - A Next Generation RTS' }
    its(:id) { should be_eql 1957695328 }
    its(:url) { should be_eql 'https://www.kickstarter.com/projects/659943965/planetary-annihilation-a-next-generation-rts'}
    its(:pledged) { should be_eql 2229344.0 }
    its(:percentage_funded) {  should be_eql 247.7049288888889 }
    its(:backers) { should be_eql 44162 }
    its(:status) { should be_eql :successful }
    its(:currency) { should be_eql 'USD' }
    its(:goal) { should be_eql 900000.0 }
    its(:hours_left) { should be_eql 0.0 }
  end

  context 'a project' do
    subject { @projects.first}
    
    its(:to_hash) { should be_kind_of Hash }
    
    its(:id) { should be_kind_of Fixnum }
    
    its(:pledged) { should be_kind_of Float }
    
    it "returns valid json" do
      expect { @projects.first.load; JSON.parse @projects.first.to_json }.not_to raise_error 
    end

    it "should be in ghost state when first fetched" do
      temp_project = Kickstapi.find_projects_with_filter("Ewe Topia").first
      expect(temp_project.load_state).to eq(:ghost)
    end

    it "should do an initial fetch of some fields, while in ghost state" do
      temp_project = Kickstapi.find_projects_with_filter("Ewe Topia").first
      temp_project.id
      temp_project.creator
      temp_project.url
      temp_project.name
      expect(temp_project.load_state).to eq(:ghost)
    end

    it "should lazily load all the arguments" do
      temp_project = Kickstapi.find_projects_with_filter("Ewe Topia").first
      temp_project.backers # fetch an item that is lazily loaded
      expect(temp_project.load_state).to eq(:loaded)
    end

    it "should be retrievable from it's URL" do
      temp_project = Kickstapi.find_project_by_url(@failure.url)
      expect(temp_project.name).to eq(@failure.name)
      expect(temp_project.creator).to eq(@failure.creator)
    end

    it "should be comparable" do
      temp_project = Kickstapi.find_project_by_url(@projects.first.url)
      expect(temp_project == @projects.first).to eq(true)
    end

    it "should be different from another project" do
      expect(@projects.first == @failure).to eq(false)
    end

    it "should mark a successful project" do
      expect(@projects.first.status).to eq(:successful)
    end

    it "should mark an unsuccessful project" do
      expect(@failure.status).to eq(:failed)
    end
  end
  
end
