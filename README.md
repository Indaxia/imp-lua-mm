# Lua Module Manager for IMP

[IMP](https://github.com/Indaxia/imp) - Indaxia Modules & Packages for Lua (Package Manager).

Provides functions to create and use [ES6-style modules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/export#Using_the_default_export) in lua code.

Modules let you write componentized and sharable code. IMP Module Manager allows you to declare your modules in any order. 
It arranges everything for you: dependency tree, loop detection, lazy loading, naming conflicts isolation etc.

It is **friendly for code inspectors** like:
- [LuaLS](https://luals.github.io) - [install for vscode](https://luals.github.io/#vscode-install) and other IDEs
- [EmmyLua](https://plugins.jetbrains.com/plugin/9768-emmylua) for Intellij

<img src="https://github.com/user-attachments/assets/d3e7c02c-5eae-422c-8777-3daa6fb214b5" width="320px" height="auto">

## Automatic installation
Initialize and build your project using [IMP](https://github.com/Indaxia/imp)

## Manual installation
Copy [imp-module-manager.lua](src/imp-module-manager.lua) to your code head section.

## Example Usage

```lua
-- file 1
Hello = Imp.export("Hello", function()
  -- make any init code here that is executed once

  -- export module (your data & functions or empty table)
  return {
    foo = "bar",
    welcome = function() print "Hello world!" end
  }
end)

-- file 2
World = Imp.export("World", function()
  -- import modules
  local Hello = Imp.import(Hello)

  -- make any init code here that is executed once
  Hello.welcome()

  -- export module (your data & functions or empty table)
  return {}
end)

-- init section (main)
local World = Imp.import(World)
```

Result:
```
Hello world!
```

## Alternate naming
You can rename globally defined modules in case of conflict and use both:

```lua
-- vendor module 1
Hello = Imp.export("Hello", function()
  return {
    x = "this is A"
  }
end)

-- vendor module 2
Hello = Imp.export("Hello", function()
  return {
    y = "this is B"
  }
end)

-- vendor module 3
Hello = Imp.export("Hello", function()
  return {
    z = "this is C"
  }
end)

-- your module
World = Imp.export("World", function()
  ---@type { x: string }
  local A = Imp.import({ name = "Hello" })
  ---@type { y: string }
  local B = Imp.import({ name = "Hello*" })
  ---@type { z: string }
  local C = Imp.import({ name = "Hello**" })

  print(A.x .. ", " .. B.y .. ", " .. C.z)
end)

-- init section (main)
World = Imp.import(World)
```
Result:
```
this is A, this is B, this is C
```
