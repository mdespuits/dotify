Feature: Unlinking files

  As a Dotify User
  I want to be able to unlink files
  In order to stop Dotify from managing files

  Background:
    Given Dotify is setup
      And an empty file named ".gitconfig"
      And an empty file named ".vimrc"
      And an empty file named ".zshrc"

  @unlinking
  @interactive
  Scenario: Unlinking
    Given I successfully run `dotify link --force`
    When I run `dotify unlink` interactively
      And I type "n"
      And I type "y"
      And I type "y"
    Then a file named ".dotify/.gitconfig" should exist
      And a file named ".dotify/.vimrc" should not exist
      And a file named ".vimrc" should exist
      And a file named ".dotify/.zshrc" should not exist
      And a file named ".zshrc" should exist

  @unlinking
  @interactive
  Scenario: Unlinking with force
    Given I successfully run `dotify link --force`
    When I successfully run `dotify unlink --force`
    Then a file named ".gitconfig" should exist
      And a file named ".vimrc" should exist
      And a file named ".dotify/gitconfig" should not exist
      And a file named ".dotify/vimrc" should not exist
