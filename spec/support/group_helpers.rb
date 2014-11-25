def create_group(project, user)
  group = create :group, project: project
  create :group_owner, user: user, group: group
  group
end
