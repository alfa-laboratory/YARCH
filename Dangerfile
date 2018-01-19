# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

# Warn when there is a big PR
warn("Big PR") if git.lines_of_code > 500

if has_app_changes && !has_test_changes && !is_version_bump
  warn("Tests were not updated", sticky: false)
end

# Mainly to encourage writing up some reasoning about the PR, rather than
# just leaving a title
if github.pr_body.length < 5
  fail "Please provide a summary in the Pull Request description"
end

# Lint files with Swiftlint. Check .swiftlint.yml for config
swiftlint.lint_files
