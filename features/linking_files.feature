Feature: linking files to Dotify

  In order to manage dotfiles
  we need to be able to link files
  from the home directory -> ~/.dotify.

  @slow_process
  Scenario: Pulling from Github
    When I successfully run `dotify github mattdbridges/dots`
    Then the following files should exist:
      | .bash_profile |
      | .gemrc        |
      | .railsrc      |
      | .vimrc        |
      | .zshrc        |
      And ".bash_profile" should be linked to Dotify
      And ".vimrc" should be linked to Dotify
      And ".gemrc" should be linked to Dotify
      And ".railsrc" should be linked to Dotify
      And ".zshrc" should be linked to Dotify

  Scenario: Linking files
    Given a directory named ".dotify"
      And an empty file named ".dotrc"
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

  Scenario: Linking files with ignored definitions
    Given a directory named ".dotify"
      And an empty file named ".dotrc"
      And an empty file named ".bash_profile"
      And an empty file named ".gemrc"
      And an empty file named ".vimrc"
      And an empty file named ".zshrc"
    And I write to ".dotrc" with:
      """
      ignore:
        dotfiles:
          - .gemrc
          - .zshrc
      """
    When I successfully run `dotify link --force`
      And I cd to ".dotify"
    Then the following files should exist:
      | .vimrc        |
      | .bash_profile |
      And ".bash_profile" should be linked to Dotify
      And ".vimrc" should be linked to Dotify
      And the following files should not exist:
        | .gemrc |
        | .zshrc |
