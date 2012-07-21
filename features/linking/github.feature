Feature: Linking Files

  I want to be able to pull down dotfiles
  from a repo in Github. And set them up on
  my system.

  @slow_process
  Scenario: Pulling from Github
    When I successfully run `dotify github mattdbridges/dots`
    Then the following files should exist:
      | .gitconfig    |
      | .vimrc        |
      | .zshrc        |
    And the following files should not exist:
      | .fakefile     |
      And ".gitconfig" should be linked to Dotify
      And ".vimrc" should be linked to Dotify
      And ".zshrc" should be linked to Dotify
