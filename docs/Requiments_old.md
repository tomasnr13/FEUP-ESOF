## Requirements

| Req. Code | Description                                                                                        |
|-----------|----------------------------------------------------------------------------------------------------|
| R1        | Students can show that they are available to make groups with other students.                      |
| R2        | Students may cancel their previous availability statements.                                        |
| R3        | Students can make requests to group with other specific students.                                  |
| R4        | An email is created whenever a group request is made.                                              |
| R5        | A Discord/Slack group is created when a new group is formed.                                       |
| R6        | Students can see how their schedules overlap to determine time slots where they can work together. |

## Use Cases Diagram

## Use Cases

|                                  |                                                                                                                                                                                                        |
|----------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Name                             | Change student's availability                                                                                                                                                                            |
| Actor                            | Student                                                                                                                                                                                                |
| Description                      | The student shows that he's available to create a group for a certain course.                                                                                                                          |
| Preconditions                    | The student is registered in the course.<br>The student is willing to create a group in that course.                                                                                                   |
| Postconditions                   | The student availability becomes visible to other users of the app, which are registered in the same course.                                                                                           |
| Normal flow                      | 1. The student accesses the app.  <br>2. From all of the courses on which he is registered, the student chooses the desired one to show is availability.  <br>3. His availability is shown on the app. |
| Alternative flows and exceptions | If the student is already on a group, only it's manager can change it's availability (from available to not available).                                                                                                                                                                                                   |                                                                                                                                                                                                     |

|                                  |                                                                                                                                                                                                                                                                                                                                                                                                                 |
|----------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Name                             | Group request                                                                                                                                                                                                                                                                                                                                                                                                   |
| Actor                            | Student                                                                                                                                                                                                                                                                                                                                                                                                         |
| Description                      | The student makes a request to create a group with other student in the same course.                                                                                                                                                                                                                                                                                                                            |
| Preconditions                    | The other student is registered in the same course as the user. <br><br>The targeted student is available in the app.                                                                                                                                                                                                                                                                                           |
| Postconditions                   | The target of the request is notified through the app that the user wants to create a group with them.                                                                                                                                                                                                                                                                                                          |
| Normal flow                      | 1. The student accesses the app. <br> <br>2. The student chooses the course on which he wants to create a group.  <br><br>3. He then checks the availability of other students. <br><br>4. After that, he chooses the student who he wants to create a group with. <br><br>5. The student sends a group request to the desired student. <br><br>6. The targeted student is notified via app (and/or via email). |
| Alternative flows and exceptions | If a certain group is still available, the student can send them a group request too, which gets sent to the group manager                                                                                   |



## User Stories

| Code | Name | Priority | Description |
|------|------|----------|-------------|
| US01 | Set Availability | high | A User wants to be able to set himself as available to form a group in a given UC |
| US02 |      |          |             |
| US03 |      |          |             |
| US04 |      |          |             |
