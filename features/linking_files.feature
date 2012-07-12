Feature: linking files to Dotify

  In order to manage dotfiles
  we need to be able to link files
  from the home directory -> ~/.dotify.

  Scenario: Setting up dotify
    Given Dotify is not setup
    When I try to setup Dotify
    Then .dotify should exist in home
    Then .dotrc should exist in home

  Scenario: Linking a file
    Given I have setup Dotify
    And the following files are in home:
      | .bash_profile |
      | .gemrc        |
    When they are linked by Dotify
    Then they are all linked to Dotify
