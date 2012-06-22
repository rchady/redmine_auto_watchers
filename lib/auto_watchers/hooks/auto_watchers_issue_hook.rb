# Hook in to the Issues controller and update the watchers before it is
# saved.
class AutoWatchersIssuesControllerHook < Redmine::Hook::ViewListener

  def controller_issues_new_before_save(context={})
    controller_issues_edit_before_save context
  end

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
      # Add ex-assignee to watchers if they are exists and addable
      unless issue.new_record?
        current_issue = Issue.find issue.id
        if !current_issue.assigned_to.blank? and
           issue.addable_watcher_users.include?(current_issue.assigned_to)
          unless issue.watchers.any? { |i| i.user_id == current_issue.assigned_to.id }
            issue.add_watcher(current_issue.assigned_to)
          end
        end
      end
      # Add the current user if they are addable
      if issue.addable_watcher_users.include?(User.current)
        unless issue.watchers.any? { |i| i.user_id == User.current.id }
          issue.add_watcher(User.current)
        end
      end
    end
  end

end
