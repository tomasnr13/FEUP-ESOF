
## Requirements

In this section are described all the module functional and non-functional requirements.

### Use case model

![Use Case View](../images/UseCaseView.png)

|                                  |                                                                                                                                                                                                                                                                                                                                                                                                                 |
|----------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Name                             | Change student's availability                                                                                                                                                                            |
| Actor                            | User                                                                                                                                                                                                     |
| Description                      | The student shows that they are available to create a group for a certain course.                                                                                                                          |
| Preconditions                    | The student is registered in the course.<br>The student is willing to create a group in that course.                                                                                                   |
| Postconditions                   | The student availability becomes visible to other users of the app, which are registered in the same course.                                                                                           |
| Normal flow                      | 1. The student accesses the app.  <br>2. From all of the courses on which they are registered, the student chooses the desired one to show their availability.  <br>3. Their availability is shown on the app. |
| Alternative flows and exceptions | If the student is already on a group, only its manager can change its availability (from available to not available).                                                                                                                                                                                                   |                                                                                                                                                                                                     |

|                                  |                                                                                                                                                                                                                                                                                                                                                                                                                 |
|----------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Name                             | Make group request                                                                                                                                                                                                                                                                                                                                                                                                   |
| Actor                            | User                                                                                                                                                                                                                                                                                                                                                                                                         |
| Description                      | The student makes a request to create a group with other student in the same course.                                                                                                                                                                                                                                                                                                                            |
| Preconditions                    | The other student is registered in the same course as the user. <br>The targeted student is available in the app.                                                                                                                                                                                                                                                                                           |
| Postconditions                   | The target of the request is notified through the app that the user wants to create a group with them.                                                                                                                                                                                                                                                                                                          |
| Normal flow                      | 1. The student accesses the app. <br>2. The student chooses the course on which they want to create a group.  <br>3. They then check the availability of other students. <br>4. After that, they choose the student who they want to create a group with. <br>5. The student sends a group request to the desired student. <br>6. The targeted student is notified via app (and/or via email). |
| Alternative flows and exceptions | If a certain group is still available, the student can send them a group request too, which gets sent to the group manager.                                                                                   |

|                                  |                                                                                                                                                                                                                                                     |
|----------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Name                             | Create group                                                                                                                                                                                                                                        |
| Actor                            | User                                                                                                                                                                                                                               |
| Description                      | Upon accepting the group request from other student, a group is created.                                                                                                                                                                            |
| Preconditions                    | At least one student accepted a group request from another one.                                                                                                                                                                                     |
| Postconditions                   | A group flag is created on the app, showing how many people are in the group.<br>The manager of the group is given a button which lets them close the groups availability.<br>A discord/slack group chat is created.                               |
| Normal flow                      | 1. A student accepts a group request in the app.<br>2. The group is created and the person who sent the first request becomes the manager.<br>3. The group and its members appear in the app together.<br>4. A discord/slack group chat is created. |
| Alternative flows and exceptions | If the group is still available, the manager can continue to accept group requests and adding members to it, in the same way they accepted the first one.                                                                                             |

|                                  |                                                                                                                                                      |
|----------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| Name                             | Consult schedule overlap                                                                                                                                     |
| Actor                            | User                                                                                                                        |
| Description                      | Students beloging in a group can see how all of their schedules overlap, in order to determine time slots where they can work together.              |
| Preconditions                    | All of the students belong to the same group.                                                                                                        |
| Postconditions                   | A timetable is created from the overlapping of all the student's schedules, showing and distinguishing available time slots from non-available ones. |
| Normal flow                      | 1. The group is created.<br>2. In the group area, the overlapped timetable is shown.                                                                  |
| Alternative flows and exceptions | If a student doesn't have a schedule assigned, a special message is displayed.                                                                                                                                            |

|                                  |                                                                                                                                                                                                                                                     |
|----------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Name                             | Consult my groups                                                                                                                                                                                                                                        |
| Actor                            | User                                                                                                                                                                                                                               |
| Description                      | Students can see to what groups they belong.                                                                                                                                                                            |
| Preconditions                    | The student belongs to at least one group.                                                                                                                                                                                     |
| Postconditions                   | A list of all the groups the student is part of is shown with details about the group.                                |
| Normal flow                      | 1. A student accesses the app.<br>2. The student chooses to consult their groups.<br>3. The group information is displayed. |
| Alternative flows and exceptions | If the student has no groups, a message saying "Currently you are not part of any group" is displayed. |

|                                  |                                                                                                                                                      |
|----------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| Name                             | Join a group                                                                                                                                     |
| Actor                            | User                                                                                                                        |
| Description                      | The student without a group in a given course, sends a request to join an existing group. |
| Preconditions                    | The student is available. <br>The student doesn't have a group in the course. <br>The target group is not full.                                                                                                        |
| Postconditions                   | The target group of the request is notified through the app that the user wants to join them.  |
| Normal flow                      | 1. The group is created.<br>2. A student accesses the app. <br>3. The student chooses the course on which they want to join a group.  <br>4. After that, they choose the group that they want to join. <br>5. The student sends a join request to the desired group. <br>6. The targeted group is notified via app (and/or via email).                                                                  |
| Alternative flows and exceptions | If a student is already on a group, sending a join request to another group will trigger a confirmation message ensuring that the student is aware they will be leaving their current group if they proceed.                                                                                                                                            |

|                                  |                                                                                                                                                                                                                                                     |
|----------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Name                             | Manage my groups                                                                                                                                                                                                                                        |
| Actor                            | Group Owner                                                                                                                                                                                                                               |
| Description                      | The student that created a group can manage it, seeing received requests and choosing to accept or reject it among other things.                                                                                                                                                                            |
| Preconditions                    | The student is the group owner of a group.                                                                                                                                                                                     |
| Postconditions                   | Details about the group are shown, with the ability to edit some of them like group title or description.<br> Join requests are also shown with the option to accept or reject them.                                |
| Normal flow                      | 1. A student accesses the app.<br>2. The student chooses to consult a group they own.<br>3. The group information is displayed with the possibility for editing and join requests are also shown.<br>4. If they chose to edit any details and confirm changes those atributes of the group are changed.<br>5. Alternatively, if they accept or reject any join requests, those will be proocessed and disapear from the group page. |
| Alternative flows and exceptions | If the student has no groups they owns, they won't be able to access these options on any group. |

### User stories

User stories are located in the [GitHub Issues](https://github.com/LEIC-ES-2021-22/3LEIC07T5/issues).

### Domain model

![Domain Model](../images/DomainModel.png)

- **User**: Represents a student, with its corresponding information.
- **Student Schedule**: Represents a student's schedule, containing different class schedules.
- **Class Schedule**: Represents a class' schedule, belonging to student schedules.
- **Invite**: Represents a student's invite to another student to join its group.
- **Group**: Represents a partial or fully formed group, with a specific group owner.
- **Course**: Represents a Curricular Unit
