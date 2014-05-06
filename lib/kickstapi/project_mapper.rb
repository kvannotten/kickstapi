require 'kickstapi/project'

module Kickstapi
  class ProjectMapper
    attr_reader :gateway

    def initialize(gateway)
      @gateway = gateway
    end

    def projects_by_filter(filter, max_results = :all)
      page = 1
      should_page = true
      projects = []

      loop do
        break unless should_page
        break unless max_results == :all || max_results.to_i >= projects.size

        projects_hashes, should_page = @gateway.projects_with_name(filter, page)
        page += 1

        projects_hashes.each do |project_hash|
          project = Project.new(data_source: self)

          project.id = project_hash[:id]
          project.url = project_hash[:url]
          project.name = project_hash[:name]

          projects << project
        end
        
      end
      projects = projects[0...max_results] unless max_results == :all
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
      if project.pledged < project.goal
        if project.end_date < DateTime.now
          project.status = :failed
        else
          project.status = :running_not_yet_achieved
        end
      else
        if project.end_date < DateTime.now
          project.status = :succesful
        else
          project.status = :running_already_achieved
        end
      end
    end
  end
end
