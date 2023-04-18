# Fast Prototyping and Debugging with Composer

## Introduction

This training module will introduce using Composer to prototype, test and debug Driverrowks driver, using the [Generic HTTP Sender](https://github.com/snap-one/docs-driverworks/blob/master/sample_drivers/generic_http.c4z) driver available from [this repository](https://github.com/snap-one/docs-driverworks) as an example environment.

The module will cover using the Lua tab in Composer to run new code and get output in real time in a running driver environment.

## Setup

- [Download the Generic HTTP Sender driver](https://github.com/snap-one/docs-driverworks/blob/master/sample_drivers/generic_http.c4z) if you have not done so already. Ensure that the filename saved is `generic_http.c4z` and does not contain any additional characters (for example, Windows will often append a `(1)` to the first part of a filename if you already have the file downloaded).
- Open Composer Pro, and connect to your controller.
- Click the `Driver` menu item, the select `Add or Update Driver or Agent`
- Navigate to the downloaded `generic_http.c4z` file, and click `Open`
  - If you already have the latest version of this driver on your system, you will see a dialog titled `Overwrite Driver or Agent` - click `Yes` to ensure that you have the latest downloaded version.
- You should now see a dialog titled `Update Succeeded`
- Create a new room in your project, and rename it `Lua Testing`
- On the `Search` tab in the `System Design` view in Composer, make sure that `Local` is checked, and then search for `Generic HTTP Sender`
- Add one copy of the `Generic HTTP Sender` driver to your project into the `Lua Testing` room.

## Executing Lua code and seeing live output

Select the Generic HTTP Sender driver that was added to your project in the Setup section. In the main part of the Composer window, you'll see the Properties page. This should have four tabs (Properties, Actions, Documentation and Lua). Select the Lua tab, and confirm that there are two large textboxes, labeled `Lua Command` and `Lua Output`.  The Lua Command textbox has three buttons:

- *Font* changes the displayed font for text in both the Lua Command and Lua Output textboxes. The default is Courier New, Regular, 8 point.
- *Execute* loads and runs any text in the Lua Command textbox in the Lua environment associated with the currently selected driver.
- *Clear* clears the Lua Command textbox, and has no other effect.

The Lua Output textbox has one button:

- *Clear* clears the Lua Output textbox, and has no other effect.

### Lua Command

This textbox is for entering Lua code. Nothing is done with the text entered here until the `Execute` button is pressed, so you can safely correct spelling and syntax errors. It does not provide any live validation of the code you type, nor does it do any syntax highlighting or linting, so for any non-trivial code, it is often easier to use the IDE of your choice (for example, VS Code) to generate well-written code that you can then copy/paste into this textbox. We will use both of these methods during this tutorial.

### Lua Output

This textbox is the "standard out" for the running Lua environment for this driver. This includes any Lua code that was loaded during startup of the driver, as well as any Lua code that has previously been entered and executed in the Lua Command textbox.

While you can type into this textbox, there is nothing that can be further done with anything entered. It is sometimes convenient to make notes into this textbox for a series of tests though, so you can delineate between different output from different actions.

You can also copy the text in this textbox for pasting elsewhere if you would like to see it formatted differently. We'll do this in a later module with JSON responses from a web API to take advantage of JSON formatting in your IDE.

## Prototyping

### Hello, Lua World

To start, we're going to do the standard "Hello World". In Lua, this is just one line:

`print ('Hello, World!')`

Type this into the Lua Command textbox, and then click the Execute button.

You should see `Hello, World!` immediately appear in the Lua Output textbox.

The Execute button loads and runs the entire text string that is present in the Lua Command textbox each time the Execute button is pressed, so if you click the Execute button again you'll see the same `Hello, World!` output appear again in the Lua Output textbox, below the one that was previously shown.

This demonstrates that the Lua Output textbox retains previous output. *HOWEVER* this is only true while the same driver remains selected in System Design. You can move between the tabs in the driver and return to the Lua tab and the previous Lua Output (and Lua Command) textboxes will contain whatever they had before. You can also go to the different Composer views (Connections, Media, Agents, Programming) and return to System Design and the same driver will be selected and the Lua Output will still be visible. If you change the selected driver in System Design in any way, the Lua Command and Lua Output textboxes will be cleared.

### Functions

The Lua code that is executed from the Lua Command textbox is persistent and will remain loaded if any global scope variables were created.  However, anything input will *NOT* persist across reboots or driver updates, as the Lua environment is re-created each time the driver is loaded.

This means that we create functions, and then run later them, using the Lua Command window.

```Lua
function protoHello (what)
  print ('Hello, ' .. tostring (what))
end
```

Copy this into the Lua Command textbox, and then click Execute, then click Clear.

You can still call this function, as it created a global variable `protoHello` of type `function`, so future references to `protoHello` will be valid.  Demonstrate this with

`protoHello ('Driverworks')`

### Errors

If any of the Lua code in the Lua Command textbox causes the Lua interpreter to throw an error, none of the code *after* that error will run, but any before it will do.  We can see this by forcing an error

First, clear the Lua Command and Lua Output textboxes by clicking their respective Clear buttons.

Then, copy paste this code and click Execute.

```Lua
print ('Hello, World!')
printError ('Hello, Error!')
```

It generates this error:

```Text
Hello, World!
LUA_ERROR [id: 450][name: Generic HTTP Sender][file: generic_http.c4z]: [string "C4Commands"]:2: attempt to call global 'printError' (a nil value)
stack traceback:
  [C]: in function 'printError'
  [string "C4Commands"]:2: in main chunk

```

The first line of the output (`Hello, World!`) was the output from the "good" part of this code.

The second and further lines give information about the Lua error that was generated.

The first component (`LUA_ERROR [id: 450][name: Generic HTTP Sender][file: generic_http.c4z]:`) is useful for the logging of this error in the system log, as it generates information about which driver (the `id` indicates the driver ID in the project, the `name` is the displayed name of the driver in the project, and the `file` indicates the filename of the driver that was loaded), but is always going to be "this" driver when looking at the Lua Output textbox.

The second component gives us some important information: `[string "C4Commands"]:2: attempt to call global 'printError' (a nil value)` indicates that the error was in the commands that had been loaded from the Lua Command textbox (this is shown by `string "C4Commands"`). The number (in this case, `2`), shows the line number where the error was found.  Finally, we get what the error was (trying to call a function that did not exist).

If the error was in some code that was loaded with the driver from a `.lua` file, this would instead show the name of the file that the error was in.  We can generate this by calling a pre-loaded function from the Generic HTTP Sender driver with some missing information (in a production driver, this *would* have better error handling to prevent a Lua error from being thrown):

```Lua
SendMultipart ()
```

gives

```Text
LUA_ERROR [id: 450][name: Generic HTTP Sender][file: generic_http.c4z]: driver.lua:136: attempt to concatenate local 'filename' (a nil value)
stack traceback:
  [C]: in ?
  driver.lua:136: in function 'SendMultipart'
  [string "C4Commands"]:1: in main chunk

```

This shows that the Lua error was in the `driver.lua` file associated with this driver, on line 136, where we attempted to concatenate a variable that did not exist (was `nil` to a string).

## Conclusions and Self Study

Each individual copy of a driver loaded into a project has a unique Lua sandboxed environment, containing all the Lua code that was loaded when the driver was first run on startup, and any additional code that was loaded from the Lua Command textbox since then.

We can interact directly with that environment using the Lua Command and Lua Output textboxes.

Before moving on to the next module, try writing some simple programs directly into the Lua Command textbox.  If you are looking for something simple but non trivial, try solving the first couple days of any year of [Advent Of Code](https://adventofcode.com/) directly in the Lua Output window without using any IDE.  Tip for managing the input: don't forget that variables loaded without a `local` keyword will stay resident in the Lua environment until the driver is loaded on startup or driver update.
