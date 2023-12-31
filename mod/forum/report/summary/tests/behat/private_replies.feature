@mod @mod_forum @forumreport @forumreport_summary
Feature: Include private replies in the summary report
  In order to generate accurate reports based on what is visible
  As a teacher
  I should have private replies being counted as well

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher1 | Teacher   | 1        | teacher1@example.com |
      | teacher2 | Teacher   | 2        | teacher2@example.com |
      | student1 | Student   | 1        | student1@example.com |
      | student2 | Student   | 2        | student1@example.com |
    And the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1        |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
      | teacher2 | C1     | editingteacher |
      | student1 | C1     | student        |
      | student2 | C1     | student        |
    And the following "activities" exist:
      | activity | name   | course | idnumber |
      | forum    | forum1 | C1     | forum1   |
    And the following "mod_forum > discussions" exist:
      | user     | forum  | name        | message     |
      | teacher1 | forum1 | discussion1 | t1 earliest |
      | teacher1 | forum1 | discussion2 | t1 between  |
      | teacher1 | forum1 | discussion3 | s1 latest   |
    And the following "mod_forum > posts" exist:
      | user     | parentsubject | subject                 | message                 | privatereplyto |
      | teacher1 | discussion1   | t1 between              | t1 between              |                |
      | teacher1 | discussion2   | t1 latest               | t1 latest               |                |
      | student1 | discussion1   | s1 earliest             | s1 earliest             |                |
      | teacher1 | s1 earliest   | This is a private reply | This is a private reply | 1              |

  Scenario: Private replies are counted for Teacher
    When I am on the forum1 "forum activity" page logged in as teacher2
    And I navigate to "Reports" in current page administration
    Then "Teacher 1" row "Number of replies posted" column of "forumreport_summary_table" table should contain "3"

  Scenario: Private replies are not counted when Teacher has not capability
    Given the following "permission overrides" exist:
      | capability                   | permission | role           | contextlevel | reference |
      | mod/forum:readprivatereplies | Prevent    | editingteacher | Course       | C1        |
    When I am on the forum1 "forum activity" page logged in as teacher2
    And I navigate to "Reports" in current page administration
    Then "Teacher 1" row "Number of replies posted" column of "forumreport_summary_table" table should contain "2"
