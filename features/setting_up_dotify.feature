Feature: Setting up Dotify

  We need to be able to setup Dotify
  on our system.

  Scenario: Setting up dotify
    Given Dotify is not setup
    When I try to setup Dotify
    Then .dotify should exist in home
    Then .dotrc should exist in home
