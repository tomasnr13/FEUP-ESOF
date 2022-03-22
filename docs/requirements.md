
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

### Use cases models 

|||
| --- | --- |
| *Name* | View student's availability |
| *Actor* |  Student | 
| *Description* | The student shows that he's available to create a group for a certain course. |
| *Preconditions* | - The student is registered in the course.<br>The student is willing to create a group in that course. |
| *Postconditions* | - The student availability becomes visible to other users of the app, which are registered in the same course. |
| *Normal flow* | 1. The student accesses the app.  <br>2. From all of the courses on which he is registered, the student chooses the desired one to show is availability.  <br>3. His availability is shown on the app. |
| *Alternative flows and exceptions* |  |

### User stories 

| Code | Name | Priority | Description |
|------|------|----------|-------------|
| US01 | Set Availability | high | A User wants to be able to set himself as available to form a group in a given UC |
| US02 |      |          |             |
| US03 |      |          |             |
| US04 |      |          |             |

**User interface mockups**.
After the user story text, you should add a draft of the corresponding user interfaces, a simple mockup or draft, if applicable.

**Acceptance tests**.
For each user story you should write also the acceptance tests (textually in [Gherkin](https://cucumber.io/docs/gherkin/reference/)), i.e., a description of scenarios (situations) that will help to confirm that the system satisfies the requirements addressed by the user story.

**Value and effort**.
At the end, it is good to add a rough indication of the value of the user story to the customers (e.g. [MoSCoW](https://en.wikipedia.org/wiki/MoSCoW_method) method) and the team should add an estimation of the effort to implement it, for example, using t-shirt sizes (XS, S, M, L, XL).



### Domain model

To better understand the context of the software system, it is very useful to have a simple UML class diagram with all the key concepts (names, attributes) and relationships involved of the problem domain addressed by your module. 
Also provide a short textual description of each class. 

Example:
 <p align="center" justify="center">
  <img src="https://github.com/LEIC-ES-2021-22/templates/blob/main/images/DomainModel.png"/>
</p>
