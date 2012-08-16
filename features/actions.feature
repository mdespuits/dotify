Feature: Proper management of pointers

  As a Dotify user
  I want to be able to properly move, remove, and manage configuration files

  @actions
  Scenario: Remove destination file
    Given a pointer within an actor with attributes:
      | source         | destination |
      | ~/.dotify/.vim | ~/.vim      |
    And I call "remove_destination" on the actor
    Then the destination should not exist

  @actions
  Scenario: Remove source file
    Given a pointer within an actor with attributes:
      | source         | destination |
      | ~/.dotify/.vim | ~/.vim      |
    And I call "remove_source" on the actor
    Then the source should not exist
