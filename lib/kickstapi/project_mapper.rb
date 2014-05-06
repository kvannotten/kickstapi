require 'kickstapi/project'

module Kickstapi
  class ProjectMapper
    attr_reader :gateway
    
    def initialize(gateway:)
      @gateway = gateway
    end

    def projects_by_filter(filter:)
      projects_hashes = @gateway.projects_with_name(filter: filter)
      projects = []
      projects_hashes.each do |project_hash|
        project = Project.new(data_source: self)

        project.id = project_hash[:id]
        project.url = project_hash[:url]
        project.name = project_hash[:name]

        projects << project
      end
      projects
    end

    def project_by_url(url:)
      project_hash = @gateway.project_by_url(url: url)
      project = Project.new(data_source: self)
      project.url = project_hash[:url]

      fill_project(project, project_hash)
    end

    def load(project)
      fill_project(project, @gateway.project_by_url(url: project.url))
    end

    private

    # lazy_accessor :creator, :about,  :pledged, :goal, 
    #              :currency, :percentage_funded, :backers, 
    #              :status, :end_date
    def fill_project(project, project_hash = {})
      project.creator = project_hash.fetch(:creator) { :not_found }
      project.about = project_hash.fetch(:about) { :not_found }
      project.pledged = project_hash.fetch(:pledged) { :not_found }
      project.goal = project_hash.fetch(:goal) { :not_found }
      project.currency = project_hash.fetch(:currency) { :not_found }
      project.percentage_funded = project_hash.fetch(:percentage_funded) { :not_found }
      project.backers = project_hash.fetch(:backers) { :not_found }
      project.status = project_hash.fetch(:status) { :not_found }
      project.end_date = project_hash.fetch(:end_date) { :not_found }
      project.load_state = :loaded
    end
  end
end
