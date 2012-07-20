Feature: linking files to Dotify

  In order to manage dotfiles
  we need to be able to link files
  from the home directory -> ~/.dotify.

  Scenario: Linking files
    Given Dotify is setup
    And the following files are in home:
      | .bash_profile |
      | .gemrc        |
      | .vimrc        |
      | .zshrc        |
    When they get linked by Dotify
    Then .bash_profile should be linked to Dotify
    And .gemrc should be linked to Dotify
    And .vimrc should be linked to Dotify
    And .zshrc should be linked to Dotify

  #Scenario: Linking files with ignored definitions
  #  Given Dotify is setup
  #  And .dotrc has contents:
  #    """
  #    ignore:
  #      dotfiles:
  #        - .gemrc
  #        - .zshrc
  #    """
  #  And the following files are in home:
  #    | .bash_profile |
  #    | .vimrc        |
  #    | .gemrc        |
  #    | .zshrc        |
  #  When they get linked by Dotify
  #  Then .bash_profile should be linked to Dotify
  #  And .vimrc should be linked to Dotify
  #  And .gemrc should not be linked to Dotify
  #  And .zshrc should not be linked to Dotify
