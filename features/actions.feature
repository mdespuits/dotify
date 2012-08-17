Feature: Proper management of pointers

  As a Dotify user
  I want to be able to properly move, remove, and manage configuration files

  @actions
  Scenario: Remove destination file
    Given an empty file named ".dotify/.vim"
      And an empty file named ".vim"
      And a pointer within an builder with attributes:
        | source       | destination |
        | .dotify/.vim | .vim        |
    When I call "remove_destination" on the builder
    Then a file named ".vim" should not exist

  @actions
  Scenario: Remove source file
    Given an empty file named ".dotify/.vim"
      And an empty file named ".vim"
      And a pointer within an builder with attributes:
        | source       | destination |
        | .dotify/.vim | .vim        |
    When I call "remove_source" on the builder
    Then a file named ".dotify/.vim" should not exist
