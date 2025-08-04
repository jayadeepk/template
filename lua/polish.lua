-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Load autocmds
require("config.autocmds")

-- Load custom mappings
require("config.mappings")

-- Load test commands
require("config.test-columns")

-- Fix for number and sign columns
require("config.column-fix")
