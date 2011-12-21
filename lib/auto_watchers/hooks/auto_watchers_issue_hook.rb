# Hook in to the Issues controller and update the watchers before it is
# saved.
class AutoWatchersIssuesControllerHook < Redmine::Hook::ViewListener

  def controller_issues_edit_before_save(context={})
    configuration = Setting.plugin_redmine_auto_watchers
    if configuration['enable_watchers']
      issue = context[:issue]
      # Add the person the ticket is assigned to if it is assigned to
      # someone and they are addable.
      if !issue.assigned_to.blank? and 
         issue.addable_watcher_users.include?(issue.assigned_to)
          issue.add_watcher(issue.assigned_to)
      end
      # Add the current user if they are addable
      issue.add_watcher(User.current) if issue.addable_watcher_users.include?(User.current)
    end
  end

end
