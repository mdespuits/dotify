Feature: Linking Files

  As a Dotify User
  I want to be able to link dotfiles
  In order to manage them

  Background:
    Given Dotify is setup
      And an empty file named ".bash_profile"
      And an empty file named ".gemrc"
      And an empty file named ".vimrc"
      And an empty file named ".zshrc"

  @linking
  @interactive
  Scenario: Linking files
    When I run `dotify link` interactively
      And I type "no"
      And I type "no"
      And I type "yes"
      And I type "yes"
    Then a file named ".dotify/.bash_profile" should not exist
    Then a file named ".dotify/.gemrc" should not exist
    Then a file named ".dotify/.vimrc" should exist
    Then a file named ".dotify/.zshrc" should exist

  @linking
  Scenario: Linking files with force
    When I successfully run `dotify link --force`
    Then ".bash_profile" should be linked to Dotify
      And ".gemrc" should be linked to Dotify
      And ".vimrc" should be linked to Dotify
      And ".zshrc" should be linked to Dotify
