Feature: Linking individual static files and directories

  Background:
    Given the following files are in home:
      | .vimrc |
      | .zshrc |
    And the following directories are in home:
      | .vim |
      | .oh-my-zsh |

  @linking
  Scenario: Linking a single file
    When I run `dotify link .vimrc`
    And I type "yes"
    Then a file named ".dotify/.vimrc" should exist

  @linking
  Scenario: Linking a single directory
    When I run `dotify link .vim`
    And I type "yes"
    Then a directory named ".dotify/.vim" should exist

  @linking
  Scenario: Linking all files and directories
    When I run `dotify link`
    And I type "yes"
    And I type "yes"
    And I type "yes"
    And I type "yes"
    Then the following files should exist:
      | .dotify/.vimrc |
      | .dotify/.zshrc |
    And the following directories should exist:
      | .dotify/.vim |
      | .dotify/.oh-my-zsh |

  @linking
  Scenario: Force linking all files and directories
    When I run `dotify link --force`
    Then the following files should exist:
      | .dotify/.vimrc |
      | .dotify/.zshrc |
    And the following directories should exist:
      | .dotify/.vim |
      | .dotify/.oh-my-zsh |
