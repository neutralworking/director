# Inbox Event System Guide

## Part 1: Running the Test Scripts

The test scripts provided are designed to be run from the command line using the Godot executable. This allows for quick verification without loading the full editor interface.

### Prerequisites
You need to know the path to your Godot executable. On macOS, it is typically:
`/Applications/Godot.app/Contents/MacOS/Godot`

### 1. Generating Test Data
This script creates the "Leak Dilemma" event resources in `res://data/events/`.

**Command:**
```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless -s scripts/systems/events/event_generator.gd
```
*Note: Replace the path to Godot with your actual installation path if different.*

### 2. Running the System Test
This script loads the generated event, triggers it via the `InboxManager`, and simulates a choice.

**Command:**
```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless -s scripts/tests/test_inbox_system.gd
```

---

## Part 2: How to Create New Events

The power of this system is that you can create events entirely within the Godot Editor using the Inspector, without writing code for every scenario.

### Workflow: Bottom-Up Creation
It is best to create the "leaves" of the data tree first (Effects), then the branches (Options), and finally the trunk (Event).

### Step 1: Create Effects
1.  In the **FileSystem** panel, right-click the folder where you want to save (e.g., `res://data/events/effects/`).
2.  Select **Create New...** -> **Resource**.
3.  Search for `EventEffect` (or a specific type like `EffectModifyOpinion`).
4.  **Save** the file (e.g., `eff_opinion_minus_10.tres`).
5.  In the **Inspector**, set the properties (e.g., `Value Change: -10`).

### Step 2: Create Options
1.  Right-click in the FileSystem -> **Create New...** -> **Resource**.
2.  Search for `EventOption`.
3.  **Save** the file (e.g., `opt_deny_accusations.tres`).
4.  In the **Inspector**:
    *   Set **Text** (e.g., "Deny everything").
    *   Locate the **Effects** array.
    *   Click **Add Element**.
    *   **Drag and Drop** your Effect resource (from Step 1) into the empty slot.

### Step 3: Create the Event
1.  Right-click in the FileSystem -> **Create New...** -> **Resource**.
2.  Search for `GameEvent`.
3.  **Save** the file (e.g., `evt_media_scandal.tres`).
4.  In the **Inspector**:
    *   Set **Title** and **Description**.
    *   Locate the **Options** array.
    *   Click **Add Element** for each choice you want to offer.
    *   **Drag and Drop** your Option resources (from Step 2) into the slots.

### Step 4: Triggering In-Game
To trigger this event in your game code:

```gdscript
var my_event = load("res://data/events/evt_media_scandal.tres")
InboxManager.trigger_event(my_event, player_context)
```
