--- Module Manager for IMP (Indaxia Modules & Packages for Lua)
Imp = {
  ---@class ImpModuleContainer
  ---@field loaded boolean
  ---@field context fun(): any
  ---@field module any

  ---@type { [string]: ImpModuleContainer }
  containers = {},
  recursionDepth = 0,

  --- Declares IMP module name and it's context to run and get the module
  ---@generic T
  ---@param name string Exported module name
  ---@param context fun(): T Function that is called once and returns the module contents
  ---@return T definition LuaLS trick to help the inspector
  export = function(name, context)
    if (name ~= nil and type(context) == "function") then
      Imp.containers[name] = {
        loaded = false,
        context = context,
        module = nil
      }
    else
      Imp.critical("wrong module declaration: '" .. name .. "'. Provide the name and a context function callback that returns a module")
    end
    return { name = name }
  end,

  --- Loads IMP module with it's dependencies and returns it
  ---@generic T
  ---@param definition T Module definition from Imp.export()
  ---@return T module Required module
  import = function(definition)
    if(type(definition) ~= "table") then
      Imp.critical("wrong module definition type (" .. type(definition) .. "). Use the variable from Imp.export() result")
    elseif(definition.name == nil) then
      Imp.critical("wrong module definition name (" .. type(definition.name) .. "). Use the variable from Imp.export() result")
    else
      if(Imp.recursionDepth > 64) then
        Imp.critical("dependency loop detected for the module \"" .. definition.name .. "\"")
      end
      local container = Imp.containers[definition.name]
      if (type(container) ~= "table") then
        Imp.critical("module '" .. definition.name .. "' is not declared. Usage: Name = Imp.export(" .. definition.name .. ", ...)")
      elseif (not container.loaded) then
        Imp.recursionDepth = Imp.recursionDepth + 1
        container.module = container.context()
        Imp.recursionDepth = Imp.recursionDepth - 1
        container.loaded = true
      end
      return container.module
    end
    return {}
  end,

  critical = function(message)
    print("IMP Error: " .. message)
    os.exit(1)
  end
}
