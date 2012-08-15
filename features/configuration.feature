Feature: Dotify configuraiton

  As a Dotify user
  I want to be able to control my settings
  In order to increase my own productivity

  Scenario: Default configuration
    Given Dotify is setup
    When Dotify attempts to load configuration
    Then Dotify's editor should be "vim"

  Scenario: Default configuration
    Given Dotify is setup
    And a file named ".dotify/.dotrc" with:
    """
    editor 'subl -w'
    """
    When Dotify attempts to load configuration
    Then Dotify's editor should be "subl -w"
