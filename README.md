# MyWorld

MyWorld is an iOS travel history application designed for frequent travellers who want to maintain a structured visual record of their trips, visited places, and travel memories.

The application allows users to record trips, add visited places, attach photos and videos, and explore their travel history through an interactive world map.

## Domain Context

Travel information is often distributed across photographs, map applications, notes, browsers, and other digital platforms. As a traveller's history grows, it can become difficult to reconstruct previous journeys and connect individual places and memories with particular trips.

MyWorld addresses this problem by providing a centralised travel history where trips, visited places, and travel memories are organised and visualised geographically.

## Architecture

MyWorld follows a layered architecture using:

- SwiftUI for the user interface
- MVVM for presentation logic
- Use Cases for domain business operations and validation
- Repository Pattern for data abstraction
- Core Data for persistent storage
- Semantic domain models including `TripModel`, `VisitedPlaceModel`, and `MediaItemModel`

The main dependency flow is:

`Views → ViewModels → Use Cases → TravelRepositoryProtocol → CoreDataTravelRepository → Core Data`

This separation prevents Views and ViewModels from directly accessing Core Data and allows domain logic to be tested independently using a mock repository.

## Core Data

MyWorld uses Core Data because travel history is private and structured data that should be stored locally and remain accessible without requiring an internet connection.

The primary Core Data entities are:

- `Trip`
- `VisitedPlace`
- `MediaItem`

A `Trip` can contain multiple `VisitedPlace` records, and a `VisitedPlace` can contain multiple `MediaItem` records.

Media files are stored locally in the application's `Documents/Media` directory using `MediaStorageService`, while Core Data stores the associated media metadata.

Database access is abstracted through `TravelRepositoryProtocol` and implemented by `CoreDataTravelRepository`.

The repository also supports domain-specific queries, including retrieving trips by country and retrieving visited places associated with a particular trip.

## Use Cases

Business operations are separated from the user interface through domain Use Cases.

Examples include:

- `RecordTripUseCase`
- `GetTravelHistoryUseCase`
- `UpdateTripUseCase`
- `DeleteTripUseCase`
- `AddVisitedPlaceUseCase`
- `GetPlacesForTripUseCase`
- `UpdateVisitedPlaceUseCase`
- `DeleteVisitedPlaceUseCase`
- `AddMediaItemUseCase`
- `GetMediaItemsForPlaceUseCase`
- `GetMediaItemsForTripUseCase`
- `UpdateTravelSummaryUseCase`

Use Cases are responsible for coordinating domain operations and, where appropriate, enforcing business rules such as requiring valid trip information and ensuring that a visited date falls within the associated trip dates.

## Main Features

MyWorld provides:

- Create, view, edit, and delete trips
- Select countries for trips
- Add visited places to trips
- Search for places using MapKit
- Restrict place selection to the trip's selected country
- View visited places on an interactive world map
- Edit and delete visited places
- Attach photos and videos to visited places
- View memories associated with individual places
- View media from all visited places within a trip
- View recent visited places
- Share travel-related URLs or text with MyWorld
- View travel statistics through a Home Screen widget

## System Extensions

### WidgetKit Extension

The MyWorld Widget provides an at-a-glance summary of the traveller's travel history from the Home Screen.

It displays:

- Number of countries visited
- Number of trips
- Number of places visited

The widget supports both small and medium widget families.

Summary information is shared between MyWorld and the WidgetKit extension using an App Group. When relevant travel information changes, the main application updates the shared summary and requests a WidgetKit timeline reload so that the widget remains consistent with the application.

### Share Extension

The Share Extension allows users to share travel-related URLs or text from other applications, such as Safari, directly with MyWorld.

The extension receives the shared content and stores it in the App Group shared container. MyWorld then reads the content and displays it on the My World dashboard for later reference.

This reduces the need for users to manually copy and paste travel-related information between applications.

## App Group

MyWorld, the WidgetKit extension, and the Share Extension use the following App Group:

`group.com.gracechong.MyWorld`

The App Group is used for:

- Widget travel-summary data
- URLs and text received through the Share Extension

## Testing

MyWorld includes seven unit tests covering core domain business rules and Use Cases.

The tests use `MockTravelRepository` rather than the real Core Data stack so that domain logic can be tested independently from persistence.

The current unit tests cover:

- Rejecting a trip with an empty country
- Rejecting a trip where the end date is earlier than the start date
- Successfully saving a valid trip
- Retrieving saved trips through `GetTravelHistoryUseCase`
- Rejecting a visited place with an empty name
- Rejecting a visited place with a visited date outside the trip date range
- Successfully saving a valid visited place

The tests cover successful operations, boundary conditions, and domain validation errors across:

- `RecordTripUseCase`
- `GetTravelHistoryUseCase`
- `AddVisitedPlaceUseCase`

### Running Unit Tests

To run the unit tests in Xcode:

1. Open the MyWorld project.
2. Select the `MyWorld` scheme.
3. Select **Product → Test** or press **Command-U**.
4. Confirm that all tests in `MyWorldTests` pass.

## Setup Instructions

1. Clone or download the repository.
2. Open the MyWorld project in Xcode.
3. Select the `MyWorld` target.
4. Configure a valid Apple Development Team under **Signing & Capabilities**.
5. Confirm that App Groups are enabled for:
   - MyWorld
   - MyWorldWidget
   - MyWorldShareExtension
6. Confirm that all three targets use the following App Group:
   `group.com.gracechong.MyWorld`
7. Select an iPhone Simulator.
8. Build and run the `MyWorld` scheme.

## Testing the Widget

1. Run MyWorld in the Simulator.
2. Create at least one trip and visited place.
3. Return to the Simulator Home Screen.
4. Add the MyWorld widget.
5. Select either the small or medium widget.
6. Confirm that the displayed country, trip, and place counts match the information stored in MyWorld.
7. Add or delete travel information in MyWorld and confirm that the widget updates accordingly.

## Testing the Share Extension

1. Run MyWorld at least once.
2. Open Safari in the Simulator.
3. Open a webpage.
4. Tap the system Share button.
5. Select MyWorld from the Share Sheet.
6. Tap Post.
7. Open MyWorld.
8. Navigate to the My World dashboard.
9. Confirm that the shared URL appears in the `Shared with MyWorld` section.

The Share Extension can also receive supported plain text shared from other applications.

## Technologies

- Swift
- SwiftUI
- MapKit
- Core Data
- WidgetKit
- App Groups
- Share Extension
- XCTest

## Project Structure

The project is organised into the following main layers:

- `Views` — SwiftUI presentation and user interaction
- `ViewModels` — presentation state and coordination
- `Domain/Models` — semantic travel domain models
- `Domain/UseCases` — business operations and validation
- `Domain/Repositories` — repository abstraction
- `Data/Repositories` — Core Data repository implementation
- `Data/CoreData` — persistent data model
- `Resources` — supporting services including media storage, place search, and shared data
- `MyWorldWidget` — WidgetKit extension
- `MyWorldShareExtension` — Share Extension
- `MyWorldTests` — unit tests and mock repository
