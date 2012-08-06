Feature: Setting up Dotify

  We need to be able to setup Dotify on our system.

  @setup
  Scenario: Setting up dotify
    Given Dotify is not setup
    When I run `dotify setup`
    Then a directory named ".dotify" should exist
    And a file named ".dotify/.dotrc" should exist
