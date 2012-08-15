Feature: Dotify configuraiton

  As a Dotify user
  I want to be able to control my settings
  In order to increase my own productivity

  @config
  Scenario: Default configuration
    Given Dotify is setup
    When Dotify attempts to load configuration
    Then Dotify's editor should be "vim"

  @config
  Scenario: Custom configuration
    Given Dotify is setup
    And an empty file named ".dotify/.dotrc"
    And I overwrite ".dotify/.dotrc" with:
    """
    editor 'subl -w'
    """
    When Dotify attempts to load configuration
    Then Dotify's editor should be "subl -w"

  @config
  @reset_configuration
  Scenario: Custom per-platform configuration without overwrite
    Given Dotify is setup
    And an empty file named ".dotify/.dotrc"
    And the host platform is "mac"
    And I overwrite ".dotify/.dotrc" with:
    """
    editor 'vi'
    platform :linux do
      editor 'subl -w'
    end
    """
    When Dotify attempts to load configuration
    Then Dotify's editor should be "vi"

  @config
  Scenario: Custom per-platform configuration
    Given Dotify is setup
    And an empty file named ".dotify/.dotrc"
    And the host platform is "mac"
    And I overwrite ".dotify/.dotrc" with:
    """
    editor 'subl -w'
    platform :mac do
      editor 'vi'
    end
    """
    When Dotify attempts to load configuration
    Then Dotify's editor should be "vi"
