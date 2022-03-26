
## Requirements

In this section are described all the module functional and non-functional requirements.

## Requirements

| Req. Code | Description                                                                                        |
|-----------|----------------------------------------------------------------------------------------------------|
| R1        | Students can show that they are available to make groups with other students.                      |
| R2        | Students may cancel their previous availability statements.                                        |
| R3        | Students can make requests to group with other specific students.                                  |
| R4        | An email is created whenever a group request is made.                                              |
| R5        | A Discord/Slack group is created when a new group is formed.                                       |
| R6        | Students can see how their schedules overlap to determine time slots where they can work together. |

## Use Cases

![Use Case Diagram](/docs/use_case_model.png)

|                 |                                                                                                                                                                                                        |
|----------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Name                             | Change student's availability                                                                                                                                                                            |
| Actor                            | User                                                                                                                                                                                                     |
| Description                      | The student shows that he's available to create a group for a certain course.                                                                                                                          |
| Preconditions                    | The student is registered in the course.<br>The student is willing to create a group in that course.                                                                                                   |
| Postconditions                   | The student availability becomes visible to other users of the app, which are registered in the same course.                                                                                           |
| Normal flow                      | 1. The student accesses the app.  <br>2. From all of the courses on which he is registered, the student chooses the desired one to show is availability.  <br>3. His availability is shown on the app. |
| Alternative flows and exceptions | If the student is already on a group, only it's manager can change it's availability (from available to not available).                                                                                                                                                                                                   |                                                                                                                                                                                                     |

|                                  |                                                                                                                                                                                                                                                                                                                                                                                                                 |
|----------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Name                             | Group request                                                                                                                                                                                                                                                                                                                                                                                                   |
| Actor                            | User                                                                                                                                                                                                                                                                                                                                                                                                         |
| Description                      | The student makes a request to create a group with other student in the same course.                                                                                                                                                                                                                                                                                                                            |
| Preconditions                    | The other student is registered in the same course as the user. <br>The targeted student is available in the app.                                                                                                                                                                                                                                                                                           |
| Postconditions                   | The target of the request is notified through the app that the user wants to create a group with them.                                                                                                                                                                                                                                                                                                          |
| Normal flow                      | 1. The student accesses the app. <br>2. The student chooses the course on which he wants to create a group.  <br>3. He then checks the availability of other students. <br>4. After that, he chooses the student who he wants to create a group with. <br>5. The student sends a group request to the desired student. <br>6. The targeted student is notified via app (and/or via email). |
| Alternative flows and exceptions | If a certain group is still available, the student can send them a group request too, which gets sent to the group manager                                                                                   |

|                                  |                                                                                                                                                                                                                                                     |
|----------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Name                             | Create group                                                                                                                                                                                                                                        |
| Actor                            | User                                                                                                                                                                                                                               |
| Description                      | Upon accepting the group request from other student, a group is created.                                                                                                                                                                            |
| Preconditions                    | At least one student accepted a group request from another one.                                                                                                                                                                                     |
| Postconditions                   | A group flag is created on the app, showing how many people are in the group.<br>The manager of the group is given a button which lets him close the groups availability.<br>#A discord/slack group chat is created?                                |
| Normal flow                      | 1. A student accepts a group request in the app.<br>2. The group is created and the person who sent the first request becomes the manager.<br>3. The group and its members appear in the app together.<br>4. A discord/slack group chat is created. |
| Alternative flows and exceptions | If the group is still available, the manager can continue to accept group requests and adding members to it, in the same way he accepted the first one.                                                                                             |

|                                  |                                                                                                                                                      |
|----------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| Name | Schedule overlap                                                                                                                                     |
| Actor                            | User                                                                                                                        |
| Description                      | Students beloging in a group can see how all of their schedules overlap, in order to determine time slots where they can work together.              |
| Preconditions                    | All of the students belong to the same group.                                                                                                        |
| Postconditions                   | A timetable is created from the overlapping of all the student's schedules, showing and distinguishing available time slots from non-available ones. |
| Normal flow                      | 1. The group is created<br>2. In the group area, the overlapped timetable is shown.                                                                  |
| Alternative flows and exceptions |                                                                                                                                                      |

### User stories

#### User

| Code | Name | Priority | Description |
|------|------|----------|-------------|
| US01 | Set Availability | high | As a User, I want to be able to ensure that I am available to form a group in a given UC, so hat other students can create a group with me. |
| US02 | Unset Availability | high | As a User, I want to be able to garantee other students I am no longer available to form a group. |
| US03 | Select Multiple Students | high | As a User, I want to select multiple students that are available to form a group, so that I can send group requests. |
| US04 | Compare Student's Schedules | high | As a User, I want to compare the schedules of a group of students, so that I can optimize the group requests I send. |
| US05 | Send Group Requests | high | As a User, I want to be able to send a request to the selected available students, or to a group already created, so that I can invite them to form a group. |
| US06 | Accept Group Requests | high | As a User, I want to be able to accept a request sent to me (making me automatically unavailable), so that I can become part of a group and stop receiving other requests for that UC. |
| US07 | Decline Group Requests | high | As a User, I want to be able to decline a request sent to me, so that I can let the other colleagues know that I'm not interested in being a part of their group. |
| US08 | Create Invitation Email | medium | As a User, I want to be able to create an email with a predefined text, to the selected available students so that I can invite them to form group. |

#### Group Owner

| Code | Name | Priority | Description |
|------|------|----------|-------------|
| US11 | Send Group Invite | high | As a Group Owner, I want to be able to send an invite to the selected available students, so that I can fulfill my group needs. |
| US12 | Accept Join Request | high | As a Group Owner, I want to be able to accept an invite sent to join the group, so that the User becames part of the group.  |
| US13 | Decline Join Request | high | As a Group Owner, I want to be able to decline an invite sent to join the group, so that the User doesn't can keep searching for a group for the UC in question. |
| US14 | Send Group Merge Request | high | As a Group Owner, I want to be able to send a Group Merge Request to another Group Owner, so that I can show them I'm interested in merging our groups together. |
| US15 | Accept Group Merge Request | high | As a Group Owner, I want to be able to accept a Group Merge Request, so that our groups are merged together. |
| US16 | Decline Group Merge Request | high | As a Group Owner, I want to be able to decline a Group Merge Request, so that our groups aren't merged together and we  can continue our search to complete the group. |
| US17 | Expel Group Member | high | As a Group Owner, I want to be able to expel a Group Member, so that said Member isn't a part of my group anymore and he can restart searching for a group for the UC in question. |

#### Group Member

| Code | Name | Priority | Description |
|------|------|----------|-------------|
| US21 | Leave Group | high | As a Group Member, I want to be able to leave my current group, so that I can search for a new one. |


### **User interface mockups**.
After the user story text, you should add a draft of the corresponding user interfaces, a simple mockup or draft, if applicable.

### **Acceptance tests**.
For each user story you should write also the acceptance tests (textually in [Gherkin](https://cucumber.io/docs/gherkin/reference/)), i.e., a description of scenarios (situations) that will help to confirm that the system satisfies the requirements addressed by the user story.

**Feature:** US01 - Set Availability
- Given that I am enrolled in a certain course
- When I set myself as available
- Then other students in the same course should be able to see me as available to form a group.

**Feature:** US02 - Unset Availability
- Given that I am enrolled in a certain course
- And I am already set as available
- When I set myself as unavailable
- Then other students in the same course should no longer be able to see me as available to form a group.

**Feature:** US03 - Select multiple students
- Given that I am enrolled in a certain course
- And I am not unavailable
- When I want to form a group
- Then I should be able to select multiple students from the ones available for the group.

**Feature:** US04 - Compare student's schedules
- Given that I am enrolled in a certain course
- When I am forming a group
- Then I should be able to see and compare the schedules of the different available students for group formation.

**Feature:** US05 - Send Group Requests
  - Scenario: Create a new group
    - Given that I am enrolled in a certain course
    - When I select other students to form a group
    - Then a request is sent to the other students inviting them to form a group.
  - Scenario: Join existing group
    - Given that I am enrolled in a certain course
    - When I select an incomplete group
    - Then a request is sent to the group owner asking to join the group.

**Feature:** US06 - Accept Group Requests
- Given I am a available student enroled in a course
- When I receive and accept a group request
- Then I should automatically join the group.

**Feature:** US07 - Decline Group Requests
- Given I am a available student enroled in a course
- When I receive and decline a group request
- Then the request should be eliminated.

**Feature:** US08 - Create email inviting students to form group
- Given that I am enrolled in a certain course
- When I select other students to form a group
- Then an email is created to be sent to the other students inviting them to form a group.

**Feature:** US11 - Send Group Invite
- Given that I am a group owner
- When my group is not yet full
- Then I should be able to send group requests to available students until my group is complete.

**Feature:** US12 - Accept Join Request
- Given that I am a group owner
- When I receive a join request from other user
- Then I should be able to accept the other user as a new member.

**Feature:** US13 - Decline Join Request
- Given that I am a group owner
- When I receive a join request from other user
- Then I should be able to decline the other user's request.

**Feature:** US14 - Send Group Merge Request
- Given that I am a group owner
- When my group is incomplete
- Then I should be able send a request to another group for merging the two groups together.

**Feature:** US15 - Accept Group Merge Request
- Given that I am a group owner
- When I receive a group merge request from other user and accept it
- Then I and the other members of my group should automatically join the other group and my original group is deleted.

**Feature:** US16 - Decline Group Merge Request
- Given that I am a group owner
- When I receive a group merge request from other user and decline it
- Then the merge request should be deleted.

**Feature:** US17 - Expel Group Member
- Given that I am a group owner
- When I want to manage the group members
- Then I should be able to kick them out.

### **Value and effort**.
At the end, it is good to add a rough indication of the value of the user story to the customers (e.g. [MoSCoW](https://en.wikipedia.org/wiki/MoSCoW_method) method) and the team should add an estimation of the effort to implement it, for example, using t-shirt sizes (XS, S, M, L, XL).

| Code | Effort |
|------|--------|
| US01 |  S |
| US02 |  S |
| US03 | XS |
| US04 |  L |
| US05 |  M |
| US06 |  S |
| US07 | XS |
| US08 |  M |
| US11 |  S |
| US12 |  S |
| US13 | XS |
| US14 |  S |
| US15 |  M |
| US16 | XS |
| US17 |  M |
| US21 |  S |s


### Domain model

To better understand the context of the software system, it is very useful to have a simple UML class diagram with all the key concepts (names, attributes) and relationships involved of the problem domain addressed by your module.
Also provide a short textual description of each class.

Example:
 <p align="center" justify="center">
  <img src="https://github.com/LEIC-ES-2021-22/templates/blob/main/images/DomainModel.png"/>
</p>
