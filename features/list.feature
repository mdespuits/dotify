Feature: Listing Linked Files

  I want to know which files/directories
  Dotify is managing.

  @list
  Scenario:
    Given Dotify is setup
    And I overwrite ".dotify/.dotrc" with:
      """
      ignore:
        dotfiles:
        - .rbx
      """
      And an empty file named ".gitconfig"
      And an empty file named ".vimrc"
      And an empty file named ".zshrc"
      And an empty file named ".DS_Store"
      And I successfully run `dotify link -f`
    When I successfully run `dotify list`
    Then the output should contain "3 files"
      And the output should contain ".gitconfig"
      And the output should contain ".vimrc"
      And the output should contain ".zshrc"
      And the output should not contain ".DS_Store"
