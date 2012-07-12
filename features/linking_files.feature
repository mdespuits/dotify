Feature: linking files to Dotify

  In order to manage dotfiles
  we need to be able to link files
  from the home directory -> ~/.dotify.

  Scenario: Linking a file
    Given I have setup Dotify
    And the following files are in home:
      | .bash_profile |
      | .gemrc        |
    When they get linked by Dotify
    Then they are all linked to the dotify path
