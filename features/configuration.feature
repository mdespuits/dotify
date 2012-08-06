Feature: Configuration Setup

  Configure Dotify to suit your needs.

  @config
  Scenario: Deafult setup when running `dotify setup`
    Given Dotify is not setup
      And I run `dotify setup`
    Then a file named ".dotify/.dotrc" should exist
      And a file named ".dotrc" should not exist
      And Dotify should have default configuration

  @config
  Scenario: Default setup with empty .dotrc file
    Given an empty file named ".dotify/.dotrc"
    Then Dotify should have default configuration

  @config
  Scenario: Setup with non-empty .dotrc file
    Given Dotify is not setup
      And I run `dotify setup`
      And I overwrite ".dotify/.dotrc" with:
      """
      editor: 'subl -w'
      """
    Then Dotify's editor should be "subl -w"
