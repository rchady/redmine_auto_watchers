# Hook in to the Issues controller and update the watchers before it is
# saved.
class AutoWatchersIssuesControllerHook < Redmine::Hook::ViewListener

  def controller_issues_edit_before_save(context={})
    configuration = Setting.plugin_redmine_auto_watchers
    if configuration['enable_watchers']
      issue = context[:issue]
      if !issue.assigned_to.blank? and 
         issue.addable_watcher_users.include?(issue.assigned_to)
          issue.add_watcher(issue.assigned_to)
      end
      issue.add_watcher(User.current) unless !issue.addable_watcher_users.include?(User.current.id)
    end
  end

end
