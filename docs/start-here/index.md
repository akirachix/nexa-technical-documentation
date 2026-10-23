# Get started

## The problem

Zambia is a landlocked country that relies heavily on road freight to move goods through major regional trade corridors, including the North–South and Dar es Salaam corridors. These corridors are essential to domestic and international trade, but the sector continues to face high transport costs, delays and difficulty coordinating freight.

Operators must decide which vehicle should carry a load, what it can safely accommodate, when it should move, whether to wait for a return load or return empty, and what each option is likely to cost. Trip costing often means estimating fuel, driver expenses, accommodation, taxes and maintenance by hand. When vehicle details, shipment opportunities, route information and cost calculations are spread across tools or depend on individual experience, truck capacity may not be used efficiently. The result can be empty or partly loaded journeys, unnecessary kilometres, higher operating costs, higher fuel consumption and avoidable emissions.

<div class="zl-question" markdown>
How might we enable Zambian fleet operators to get more productive value from every truck journey while navigating real-world cost, route, timing and operational constraints?
</div>

## The solution

ZamLine is a freight-matching and fleet-planning platform. It brings vehicle data, fleet requirements, shipment opportunities, route information and operating-cost estimates into one workflow so fleet operators can make better-informed decisions. ZamLine is decision support: the Fleet Manager decides whether to accept a load.

## Who uses it

| User | Role in ZamLine |
|---|---|
| **Shipper** | A person or business with cargo to move. Publishes shipments, tracks their status and receives the accepting fleet company's contact details after allocation. |
| **Fleet Manager** | The person in charge of fleet operations at a logistics company. Maintains trucks and private cost settings, reviews compatible shipments and cost estimates, and accepts or declines loads. |

Both roles belong to a company, and both company types must pass PACRA business verification before they can post or accept shipments.

## How the workflow runs

1. **Register and verify.** Shippers and Fleet Managers register and submit a PACRA certificate for verification.
2. **Publish a shipment.** A Shipper enters cargo details, origin, destination, pickup time, requirements and proposed payment.
3. **Maintain the fleet.** A Fleet Manager keeps trucks, capacity, availability and private operating-cost settings up to date.
4. **Match and assess.** The Fleet Manager reviews open shipments that available trucks can carry, with route distance, journey duration, estimated costs and margin.
5. **Accept or decline.** A valid acceptance reserves the shipment for one fleet company. Other pending matches for that shipment are closed.
6. **Hand off.** After allocation, each side can see the other's permitted business contact details.

The screens for each step are in [Pages and workflows](../frontend/workflows.md).

## What ZamLine does not do

- It does not collect driver location data.
- It does not guarantee costs or profit. Cost estimates are indicative.
- It does not release contact details or private cost settings before the rules in [Security](../security/index.md) allow it.

## How this documentation is organised

| If you need to… | Go to |
|---|---|
| Understand the system and its boundaries | [Architecture](../architecture/index.md) |
| Work on API modules and data structures | [Backend](../backend/index.md) and [Data model](../backend/data-model.md) |
| Understand cost estimation | [AI Module](../ai/index.md) |
| Work on user-facing screens | [Frontend](../frontend/index.md) |
| Understand hosting, secrets and backups | [Platform](../platform/index.md) |
| Apply security and privacy controls | [Security](../security/index.md) |
| Make a change or prepare a release | [Developer Guide](../developer-guide/index.md) |

