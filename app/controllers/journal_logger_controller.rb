class JournalLoggerController < ProjectsController
  before_filter :have_project_access
end
