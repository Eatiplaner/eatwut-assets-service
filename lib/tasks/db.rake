class DbTasks
  include Rake::DSL

  def initialize
    namespace :db do
    end
  end
end

def data_folder
  Rails.root.join('lib/tasks/data')
end

DbTasks.new
