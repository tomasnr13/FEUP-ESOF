
## Requirements

In this section are described all the module functional and non-functional requirements.

### Use cases models 

|||
| --- | --- |
| *Name* | Purchase tickets online |
| *Actor* |  Customer | 
| *Description* | The customer purchases one or more tickets for an event, using an electronic payment method, having the option to choose places. |
| *Preconditions* | - The customer has electronic payment means. <br> - The event has tickets available on-sale. |
| *Postconditions* | - The customer gets the electronic tickets with a QR code. <br> - The customer is charged of the tickets’ cost, and the seller credited. <br> - Information of tickets sold & seats available for the event is updated. |
| *Normal flow* | 1. The customer accesses the web page of the ticketing system.<br> 2. The system shows the list of events with tickets on-sale.<br> 3. The customer selects the event and the number of tickets.<br> 4. If wanted, the costumer may Choose Places.<br> 5. The system shows the total price to pay.<br> 6. The system redirects the customer to Electronic Payment.<br> 7. The system delivers the electronic tickets to the customer with a unique identifier and QR code. |
| *Alternative flows and exceptions* | 1. [Payment failure] If, in step 6 of the normal flow the payment fails, the system gives the user the possibility to cancel or retry. |

### User stories 

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
