require 'kickstapi/project'

module Kickstapi
  class ProjectMapper
    attr_reader :gateway
    
    def initialize(gateway)
      @gateway = gateway
    end

    def projects_by_filter(filter)
      projects_hashes = @gateway.projects_with_name(filter)
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

    def project_by_url(url)
      project_hash = @gateway.project_by_url(url)
      project = Project.new(data_source: self)
      project.url = project_hash[:url]

      fill_project(project, project_hash)
      project
    end

    def load(project)
      fill_project(project, @gateway.project_by_url(project.url))
    end

    private

    def fill_project(project, project_hash = {})
      project.complete(project_hash)
      project.load_state = :loaded
    end
  end
end
