Feature: Bottom Navigation

    Background:
        Given the app is running
        And I am logged in

    Scenario: Bottom navigation displays all tabs after login
        Then I see {'Home'} text
        And I see {'Statistics'} text
        And I see {'Attendance'} text
        And I see {'Features'} text
        And I see {'Profile'} text

    Scenario: Tap home navigation tab
        When I tap {Icons.home} icon
        Then I see {'Hello World - Home'} text

    Scenario: Tap statistics navigation tab
        When I tap {Icons.analytics} icon
        Then I see {'Hello World - Statistics'} text

    Scenario: Tap attendance navigation tab
        When I tap {Icons.access_time} icon
        Then I see {'Hello World - Attendance'} text

    Scenario: Tap features navigation tab
        When I tap {Icons.apps} icon
        Then I see {'Hello World - Features'} text

    Scenario: Tap profile navigation tab
        When I tap {Icons.person} icon
        Then I see {'Hello World - Profile'} text

    Scenario: Navigation between tabs
        When I tap {Icons.analytics} icon
        Then I see {'Hello World - Statistics'} text
        When I tap {Icons.person} icon
        Then I see {'Hello World - Profile'} text
        When I tap {Icons.home} icon
        Then I see {'Hello World - Home'} text