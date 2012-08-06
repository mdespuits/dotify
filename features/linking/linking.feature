Feature: Linking Files

  As a Dotify User
  I want to be able to link dotfiles
  In order to manage them

  @linking
  Scenario: Linking files
    Given a directory named ".dotify"
      And an empty file named ".bash_profile"
      And an empty file named ".gemrc"
      And an empty file named ".vimrc"
      And an empty file named ".zshrc"
      And I write to ".dotrc" with:
      """
      editor: 'vi'
      """
    When I successfully run `dotify link --force`
    Then ".bash_profile" should be linked to Dotify
      And ".gemrc" should be linked to Dotify
      And ".vimrc" should be linked to Dotify
      And ".zshrc" should be linked to Dotify

  @linking
  Scenario: Linking files without force
    Given Dotify is setup
      And an empty file named ".github"
      And an empty file named ".vimrc"
    When I run `dotify link` interactively
      And I type "n"
      And I type "y"
    Then a file named ".dotify/.github" should not exist
    Then a file named ".dotify/.vimrc" should exist
