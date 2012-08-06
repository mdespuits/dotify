Feature: Linking Files

  As a Dotify user
  I want to be able to pull down dotfiles
  In order to set them up on my system

  @long_process
  @github
  Scenario: Pulling from Github without submodules
    When I successfully run `dotify github mattdbridges/simple_dotfiles`
    Then the following files should exist:
      | .gitconfig    |
      | .vimrc        |
      | .zshrc        |
      And ".gitconfig" should be linked to Dotify
      And ".vimrc" should be linked to Dotify
      And ".zshrc" should be linked to Dotify

  @long_process
  @github
  Scenario: Pulling from Github
    When I successfully run `dotify github mattdbridges/dots`
    Then the following files should exist:
      | .gitconfig    |
      | .vimrc        |
      | .zshrc        |
    And the following files should not exist:
      | .gitmodules   |
      And ".gitconfig" should be linked to Dotify
      And ".vimrc" should be linked to Dotify
      And ".gitmodules" should not be linked to Dotify
      And ".zshrc" should be linked to Dotify
      And the following files should exist:
        | .dotify/.dotrc |
