require 'redmine'

require 'auto_watchers/hooks/auto_watchers_issue_hook'

Redmine::Plugin.register :redmine_auto_watchers do
  name 'Automatic Watchers'
  author 'Robert Chady'
  description 'Automatic Watchers is a Redmine project that automatically adds people that touch an issue as watchers."'
  version '0.3.0'

  requires_redmine :version_or_higher => '0.9.0'

  settings :default => {
               'enable_watchers' => 'on'
            }, :partial => 'settings/auto_watchers'
end
