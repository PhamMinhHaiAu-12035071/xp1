Feature: Environment Configuration

    Background:
        Given the app is running

    Scenario: App runs in development environment
        Then I see {'Login'} text
        # App should load with development configuration

    Scenario: Environment-specific configuration loads
        Then I see {'Welcome to Login'} text
        # Environment-specific strings and configs should be available

    Scenario: App initializes with proper environment
        Then I see {'Login'} button
        # Environment-specific features should be initialized